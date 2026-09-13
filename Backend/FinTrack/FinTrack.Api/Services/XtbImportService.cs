using System.Globalization;
using System.Text.RegularExpressions;
using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Investments;
using FinTrack.Api.Entities;
using FinTrack.Api.Utils.Enums;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public partial class XtbImportService
{
    private readonly FinanceDbContext _context;

    public XtbImportService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<XtbImportParseResponse> ParseAsync(string cashRows, string? openPositions, string accountCurrency)
        => await BuildParseResponseAsync(cashRows, openPositions, closed: null, accountCurrency: accountCurrency, fileName: null);

    public async Task<XtbImportParseResponse> ParseWorkbookAsync(string fileName, byte[] content, string accountCurrency)
    {
        var workbook = XtbWorkbookParser.Extract(content);

        if (string.IsNullOrWhiteSpace(workbook.CashText))
        {
            throw new InvalidDataException(
                workbook.ParsedSheets.Count == 0
                    ? "No recognizable sheets found in the workbook. Make sure it is an XTB report exported as .xlsx."
                    : $"Workbook read failed for \"{fileName}\". Found sheets: {string.Join(", ", workbook.ParsedSheets)}. Could not read the Cash Operations table. If your export uses non-English sheet names, rename the cash sheet to \"Cash Operations\" or paste the table instead.");
        }

        var response = await BuildParseResponseAsync(
            workbook.CashText,
            workbook.OpenText,
            workbook.Closed,
            accountCurrency,
            fileName);

        response.ParsedSheets = workbook.ParsedSheets;

        return response;
    }

    private async Task<XtbImportParseResponse> BuildParseResponseAsync(
        string cashRows,
        string? openPositions,
        IReadOnlyList<(string Ticker, int Trades, decimal Profit)>? closed,
        string accountCurrency,
        string? fileName)
    {
        var rows = ParseCashRows(cashRows);
        var existingTickers = await LoadTickerSetAsync();
        var newAssets = rows
            .Where(r => r.Supported && r.Type is
                InvestmentTransactionType.Buy or
                InvestmentTransactionType.Sell or
                InvestmentTransactionType.Dividend)
            .Select(r => r.Ticker)
            .Distinct()
            .Count(t => !existingTickers.Contains(t));

        var computedProfit = ComputeRealizedByTicker(rows);

        return new XtbImportParseResponse
        {
            AccountCurrency = NormalizeCurrency(accountCurrency),
            SourceFile = fileName ?? string.Empty,
            ParsedSheets = [],
            CashRows = cashRows,
            Rows = rows,
            Reconciliation = ParseOpenPositions(openPositions, rows),
            ClosedPositions = closed?.Select(c => new XtbClosedRow
            {
                Ticker = c.Ticker,
                Trades = c.Trades,
                BrokerProfit = c.Profit,
                ComputedProfit = decimal.Round(computedProfit.GetValueOrDefault(c.Ticker), 2)
            }).ToList(),
            TotalCount = rows.Count,
            SupportedCount = rows.Count(r => r.Supported),
            SkippedCount = rows.Count(r => !r.Supported),
            NewAssets = newAssets,
            FinalCash = ComputeEndingCash(rows)
        };
    }

    public async Task<XtbImportCommitResponse> CommitAsync(
        string accountName,
        string accountCurrency,
        string cashRows)
    {
        await using var transaction = await _context.Database.BeginTransactionAsync();

        var rows = ParseCashRows(cashRows).Where(r => r.Supported).ToList();

        if (rows.Count == 0)
            throw new Exception("Nothing to import: no supported rows were found.");

        var currency = NormalizeCurrency(accountCurrency);
        var name = string.IsNullOrWhiteSpace(accountName) ? "XTB" : accountName.Trim();

        var account = await _context.InvestmentAccounts.FirstOrDefaultAsync(a => a.Name == name);

        if (account is null)
        {
            account = new InvestmentAccount
            {
                Name = name,
                Institution = "XTB",
                Currency = currency,
                OpeningBalance = 0
            };
            _context.InvestmentAccounts.Add(account);
        }
        else if (account.Currency != currency)
        {
            account.Currency = currency;
        }

        await _context.SaveChangesAsync();

        var existing = await _context.InvestmentTransactions
            .Where(t => t.InvestmentAccountId == account.Id)
            .AsNoTracking()
            .ToListAsync();

        var existingKeys = new HashSet<string>(existing.Select(CommitKey), StringComparer.Ordinal);

        var assetByTicker = await _context.Assets
            .AsNoTracking()
            .ToDictionaryAsync(a => a.Ticker, StringComparer.OrdinalIgnoreCase);
        var createdAssets = new List<string>();

        foreach (var group in rows
                     .Where(r => r.Type is
                         InvestmentTransactionType.Buy or
                         InvestmentTransactionType.Sell or
                         InvestmentTransactionType.Dividend)
                     .GroupBy(r => r.Ticker)
                     .OrderBy(g => g.Key))
        {
            if (assetByTicker.ContainsKey(group.Key))
                continue;

            var sample = group.First();
            var asset = new Asset
            {
                Ticker = group.Key,
                Name = string.IsNullOrWhiteSpace(sample.Name) ? group.Key : sample.Name,
                Type = MapAssetType(sample.AssetClass),
                Currency = currency,
                StooqSymbol = YahooSymbol(sample.Ticker)
            };

            _context.Assets.Add(asset);
            assetByTicker[asset.Ticker] = asset;
            createdAssets.Add(asset.Ticker);
        }

        await _context.SaveChangesAsync();

        var newRows = rows
            .Where(r => !existingKeys.Contains(CommitKey(r, assetByTicker)))
            .ToList();

        var skipped = rows.Count - newRows.Count;

        var slots = ValidateAndBuildSlots(account.Id, newRows);

        _context.InvestmentTransactions.AddRange(
            newRows.Select(r => new InvestmentTransaction
            {
                InvestmentAccountId = account.Id,
                AssetId = r.Type is
                    InvestmentTransactionType.Buy or
                    InvestmentTransactionType.Sell or
                    InvestmentTransactionType.Dividend
                    ? assetByTicker[r.Ticker].Id
                    : null,
                Type = r.Type!.Value,
                Date = r.Date,
                Quantity = r.Quantity,
                Price = r.Price,
                Amount = r.Amount,
                Fee = 0,
                Note = r.Note.Length > 300 ? r.Note[..300] : r.Note
            }));

        await _context.SaveChangesAsync();
        await transaction.CommitAsync();

        return new XtbImportCommitResponse
        {
            AccountId = account.Id,
            Imported = newRows.Count,
            Deleted = 0,
            Skipped = skipped,
            CreatedAssets = createdAssets,
            FinalCash = slots.FinalCash
        };
    }

    private static string CommitKey(InvestmentTransaction t)
        => BuildCommitKey(t.Type, t.Date, t.Amount, t.AssetId, t.Quantity, t.Price);

    private static string CommitKey(XtbImportRow r, IReadOnlyDictionary<string, Asset> assets)
        => BuildCommitKey(
            r.Type!.Value,
            r.Date,
            r.Amount,
            r.Ticker.Length > 0 && assets.TryGetValue(r.Ticker, out var asset) ? asset.Id : null,
            r.Quantity,
            r.Price);

    private static string BuildCommitKey(
        InvestmentTransactionType type,
        DateOnly date,
        decimal amount,
        Guid? assetId,
        decimal quantity,
        decimal price)
    {
        var amountRounded = decimal.Round(amount, 2, MidpointRounding.AwayFromZero);
        var quantityRounded = decimal.Round(quantity, 4, MidpointRounding.AwayFromZero);
        var priceRounded = decimal.Round(price, 4, MidpointRounding.AwayFromZero);

        return $"{type}|{date:yyyy-MM-dd}|{amountRounded:0.00}|{assetId?.ToString() ?? "-"}|{quantityRounded:0.0000}|{priceRounded:0.0000}";
    }

    private static Dictionary<string, decimal> ComputeRealizedByTicker(List<XtbImportRow> rows)
    {
        var slots = new Dictionary<string, SlotState>();
        var realized = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase);

        foreach (var r in rows.Where(r => r.Supported))
        {
            switch (r.Type)
            {
                case InvestmentTransactionType.Buy:
                    if (!slots.TryGetValue(r.Ticker, out var buy))
                    {
                        buy = new SlotState();
                        slots[r.Ticker] = buy;
                    }
                    buy.Qty += r.Quantity;
                    buy.Cost += r.Amount;
                    break;

                case InvestmentTransactionType.Sell:
                    if (!slots.TryGetValue(r.Ticker, out var sell))
                    {
                        sell = new SlotState();
                        slots[r.Ticker] = sell;
                    }
                    var allocated = r.Quantity * (sell.Qty == 0 ? 0 : sell.Cost / sell.Qty);
                    sell.Qty -= r.Quantity;
                    sell.Cost -= Math.Min(allocated, sell.Cost);
                    realized[r.Ticker] = realized.GetValueOrDefault(r.Ticker) + r.Amount - allocated;
                    break;

                case InvestmentTransactionType.Dividend:
                    realized[r.Ticker] = realized.GetValueOrDefault(r.Ticker) + r.Amount;
                    break;
            }
        }

        return realized;
    }

    private sealed class SlotState
    {
        public decimal Qty { get; set; }

        public decimal Cost { get; set; }
    }

    private static (Dictionary<string, SlotState> Slots, decimal FinalCash) ValidateAndBuildSlots(
        Guid accountId,
        List<XtbImportRow> rows)
    {
        var slots = new Dictionary<string, SlotState>();
        decimal cash = 0;

        foreach (var r in rows)
        {
            switch (r.Type)
            {
                case InvestmentTransactionType.Buy:
                case InvestmentTransactionType.Sell:
                    if (!slots.TryGetValue(r.Ticker, out var slot))
                    {
                        slot = new SlotState();
                        slots[r.Ticker] = slot;
                    }

                    if (r.Type == InvestmentTransactionType.Buy)
                    {
                        slot.Qty += r.Quantity;
                        slot.Cost += r.Amount;
                        cash -= r.Amount;
                    }
                    else
                    {
                        var allocated = r.Quantity * (slot.Qty == 0 ? 0 : slot.Cost / slot.Qty);
                        slot.Qty -= r.Quantity;
                        slot.Cost -= Math.Min(allocated, slot.Cost);
                        cash += r.Amount;
                    }
                    break;

                case InvestmentTransactionType.Dividend:
                case InvestmentTransactionType.Interest:
                    cash += r.Amount;
                    break;

                case InvestmentTransactionType.TransferIn:
                    cash += r.Amount;
                    break;

                case InvestmentTransactionType.TransferOut:
                case InvestmentTransactionType.Fee:
                    cash -= r.Amount;
                    break;
            }
        }

        var negative = slots
            .Where(kv => kv.Value.Qty < -0.0001m)
            .Select(kv => kv.Key)
            .ToList();

        if (negative.Count > 0)
            throw new Exception($"Import would sell more than bought for: {string.Join(", ", negative)}");

        return (slots, decimal.Round(cash, 2));
    }

    private static List<XtbImportRow> ParseCashRows(string raw)
    {
        var rows = new List<XtbImportRow>();

        foreach (var rawLine in raw.Replace("\r\n", "\n").Split('\n'))
        {
            var line = rawLine.Trim('\u00A0', ' ').Trim('\t', ' ');

            if (line.Length == 0)
                continue;

            var cells = SplitCells(line);

            if (IsHeader(cells))
                continue;

            var typeText = Get(cells, 0);
            var note = Get(cells, 7);
            var tickerRaw = Get(cells, 2);
            var name = Get(cells, 1);
            var assetClass = Get(cells, 3);

            if (string.IsNullOrWhiteSpace(typeText))
                continue;

            if (Normalize(typeText).Contains("total"))
            {
                rows.Add(Skip(typeText, "Total row", date: null, amountRaw: null, tickerRaw: null, note));
                continue;
            }

            var amount = ParseDecimal(Get(cells, 5));

            if (!TryParseDate(Get(cells, 4), out var date))
            {
                rows.Add(Skip(typeText, "Invalid or missing date", date, amount, tickerRaw, note));
                continue;
            }

            var classification = Classify(typeText, note);

            switch (classification)
            {
                case BuyOrSell.Buy:
                case BuyOrSell.Sell:
                    if (string.IsNullOrWhiteSpace(tickerRaw))
                    {
                        rows.Add(Skip(typeText, "Missing ticker", date, amount, null, note));
                        continue;
                    }

                    var (qty, price) = ParseTradeAmount(typeText, note, amount);

                    if (qty <= 0)
                    {
                        rows.Add(Skip(typeText, "Missing quantity/price in note", date, amount, tickerRaw, note));
                        continue;
                    }

                    var tradeAmount = decimal.Round(qty * price, 2);

                    if (amount.HasValue && Math.Abs(tradeAmount - Math.Abs(amount.Value)) > 0.02m)
                    {
                        tradeAmount = decimal.Round(Math.Abs(amount.Value), 2);
                        price = decimal.Round(tradeAmount / qty, 6);
                    }

                    rows.Add(new XtbImportRow
                    {
                        RawType = typeText,
                        Type = classification == BuyOrSell.Buy ? InvestmentTransactionType.Buy : InvestmentTransactionType.Sell,
                        Supported = true,
                        Ticker = CleanTicker(tickerRaw),
                        Name = Clean(name),
                        AssetClass = assetClass,
                        Date = date,
                        Quantity = qty,
                        Price = price,
                        Amount = tradeAmount,
                        Note = note
                    });
                    break;

                case BuyOrSell.Dividend:
                    if (string.IsNullOrWhiteSpace(tickerRaw))
                    {
                        rows.Add(Skip(typeText, "Missing ticker", date, amount, null, note));
                        continue;
                    }

                    if (!amount.HasValue || amount.Value == 0)
                    {
                        rows.Add(Skip(typeText, "Missing amount", date, amount, tickerRaw, note));
                        continue;
                    }

                    rows.Add(new XtbImportRow
                    {
                        RawType = typeText,
                        Type = InvestmentTransactionType.Dividend,
                        Supported = true,
                        Ticker = CleanTicker(tickerRaw),
                        Name = Clean(name),
                        AssetClass = assetClass,
                        Date = date,
                        Quantity = 0,
                        Price = 0,
                        Amount = decimal.Round(Math.Abs(amount.Value), 2),
                        Note = note
                    });
                    break;

                case BuyOrSell.Interest:
                case BuyOrSell.Fee:
                case BuyOrSell.Transfer:
                    if (!amount.HasValue || amount.Value == 0)
                    {
                        rows.Add(Skip(typeText, "Missing amount", date, amount, tickerRaw, note));
                        continue;
                    }

                    rows.Add(new XtbImportRow
                    {
                        RawType = typeText,
                        Type = classification switch
                        {
                            BuyOrSell.Interest => InvestmentTransactionType.Interest,
                            BuyOrSell.Fee => InvestmentTransactionType.Fee,
                            _ => amount.Value > 0 ? InvestmentTransactionType.TransferIn : InvestmentTransactionType.TransferOut
                        },
                        Supported = true,
                        Ticker = string.Empty,
                        Name = string.Empty,
                        AssetClass = string.Empty,
                        Date = date,
                        Quantity = 0,
                        Price = 0,
                        Amount = decimal.Round(Math.Abs(amount.Value), 2),
                        Note = note
                    });
                    break;

                default:
                    rows.Add(Skip(typeText, "Unrecognized operation type", date, amount, tickerRaw, note));
                    break;
            }
        }

        return rows.OrderBy(r => r.Date)
            .ThenBy(r => r.RawType, StringComparer.Ordinal)
            .ThenBy(r => r.Ticker, StringComparer.Ordinal)
            .ToList();
    }

    private static XtbImportRow Skip(
        string typeText,
        string reason,
        DateOnly? date,
        decimal? amountRaw,
        string? tickerRaw,
        string note) => new()
    {
        RawType = typeText,
        Supported = false,
        Reason = reason,
        Ticker = tickerRaw is null ? string.Empty : CleanTicker(tickerRaw),
        Name = string.Empty,
        AssetClass = string.Empty,
        Date = date ?? default,
        Quantity = 0,
        Price = 0,
        Amount = amountRaw.HasValue ? decimal.Round(Math.Abs(amountRaw.Value), 2) : 0,
        Note = note
    };

    private static BuyOrSell Classify(string typeText, string note)
    {
        var n = Normalize(typeText);

        if (string.IsNullOrWhiteSpace(n))
            return BuyOrSell.Unsupported;

        var noteLower = Normalize(note);

        if (n.Contains("tax") || n.Contains("commission") || n.Contains("comission")
            || n.Contains("fee") || n.Contains("conversion") || n.Contains("withholding")
            || n.Contains("exchange rate"))
            return BuyOrSell.Fee;

        if (n.Contains("sell") || n.Contains("sale"))
            return BuyOrSell.Sell;

        if (n.Contains("purchase") || n.Contains("buy"))
            return BuyOrSell.Buy;

        if (n.Contains("interest"))
            return BuyOrSell.Interest;

        if (n.Contains("dividend"))
            return BuyOrSell.Dividend;

        if (n.Contains("deposit"))
            return BuyOrSell.Transfer;

        if (n.Contains("withdraw"))
            return BuyOrSell.Transfer;

        if (n.Contains("transfer"))
            return BuyOrSell.Transfer;

        if (noteLower.Contains("dividend"))
            return BuyOrSell.Dividend;

        return BuyOrSell.Unsupported;
    }

    private static (decimal Qty, decimal Price) ParseTradeAmount(string typeText, string note, decimal? rowAmount)
    {
        var match = TradeRegex().Match(note ?? string.Empty);

        if (!match.Success)
            match = LooseTradeRegex().Match(note ?? string.Empty);

        if (match.Success)
        {
            var qty = ParseDecimal(match.Groups[1].Value) ?? 0;
            var price = ParseDecimal(match.Groups[2].Value) ?? 0;
            return (qty, price);
        }

        return (0, 0);
    }

    private static List<XtbReconciliationRow>? ParseOpenPositions(string? raw, List<XtbImportRow> rows)
    {
        if (string.IsNullOrWhiteSpace(raw))
            return null;

        var expected = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase);

        int? tickerIndex = null;
        int? qtyIndex = null;

        foreach (var rawLine in raw.Replace("\r\n", "\n").Split('\n'))
        {
            var line = rawLine.Trim('\u00A0', ' ').Trim('\t', ' ');

            if (line.Length == 0)
                continue;

            var cells = SplitCells(line);
            var lower = cells.Select(c => c.ToLowerInvariant()).ToList();

            if (tickerIndex is null)
            {
                var tickerIdx = lower.FindIndex(c => c is "symbol" or "ticker" or "instrument" or "code" or "name");
                var qtyIdx = lower.FindIndex(c => c is "quantity" or "volume" or "size" or "position" or "positions" or "contracts");

                if (tickerIdx >= 0 && qtyIdx >= 0)
                {
                    tickerIndex = tickerIdx;
                    qtyIndex = qtyIdx;
                    continue;
                }

                continue;
            }

            if (tickerIndex is not { } ti || qtyIndex is not { } qi)
                continue;

            var tickerRaw = Get(cells, ti);

            if (string.IsNullOrWhiteSpace(tickerRaw))
                continue;

            var qty = ParseDecimal(Get(cells, qi));

            if (!qty.HasValue)
                continue;

            var baseTicker = CleanTicker(tickerRaw);
            expected[baseTicker] = expected.GetValueOrDefault(baseTicker) + Math.Abs(qty.Value);
        }

        if (expected.Count == 0)
            return null;

        var imported = rows
            .Where(r => r.Supported && r.Type is InvestmentTransactionType.Buy or InvestmentTransactionType.Sell)
            .GroupBy(r => r.Ticker)
            .ToDictionary(g => g.Key, g => g.Sum(r => r.Type == InvestmentTransactionType.Buy ? r.Quantity : -r.Quantity), StringComparer.OrdinalIgnoreCase);

        var tickers = expected.Keys
            .Concat(imported.Where(kv => kv.Value > 0.0001m).Select(kv => kv.Key))
            .Distinct();

        return tickers
            .Select(t => new XtbReconciliationRow
            {
                Ticker = t,
                ExpectedQuantity = expected.GetValueOrDefault(t),
                ImportedQuantity = imported.GetValueOrDefault(t),
                Match = Math.Abs(expected.GetValueOrDefault(t) - imported.GetValueOrDefault(t)) < 0.01m
            })
            .Where(r => r.ExpectedQuantity > 0.0001m || r.ImportedQuantity > 0.0001m)
            .OrderBy(r => r.Ticker)
            .ToList();
    }

    private static decimal ComputeEndingCash(List<XtbImportRow> rows)
    {
        decimal cash = 0;

        foreach (var r in rows.Where(r => r.Supported))
        {
            switch (r.Type)
            {
                case InvestmentTransactionType.Buy:
                case InvestmentTransactionType.TransferOut:
                case InvestmentTransactionType.Fee:
                    cash -= r.Amount;
                    break;
                default:
                    cash += r.Amount;
                    break;
            }
        }

        return decimal.Round(cash, 2);
    }

    private async Task<HashSet<string>> LoadTickerSetAsync()
        => (await _context.Assets.AsNoTracking().Select(a => a.Ticker).ToListAsync())
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

    private static bool IsHeader(List<string> cells)
        => cells.Count > 0 && Normalize(cells[0]) is "type" or "operation" or "symbol" or "name" or "instrument" or "time" or "datetime" or "date";

    private static string Get(List<string> cells, int index)
        => index < cells.Count ? cells[index].Trim() : string.Empty;

    private static List<string> SplitCells(string line)
    {
        var cells = line.Contains('\t') ? line.Split('\t') : line.Split(',');

        return cells.Select(c => c.Trim()).ToList();
    }

    private static string Clean(string value)
        => string.IsNullOrWhiteSpace(value) ? string.Empty : value.Trim();

    private static string CleanTicker(string raw)
    {
        var ticker = raw.Trim().ToUpperInvariant();
        var dot = ticker.IndexOf('.');

        return dot > 0 ? ticker[..dot] : ticker;
    }

    private static string? YahooSymbol(string raw)
    {
        var ticker = raw.Trim().ToUpperInvariant();

        if (ticker.EndsWith(".US"))
            return ticker[..^3];

        if (ticker.EndsWith(".UK"))
            return ticker[..^3] + ".L";

        if (ticker.EndsWith(".DE"))
            return ticker;

        return null;
    }

    private static decimal? ParseDecimal(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
            return null;

        if (decimal.TryParse(value, NumberStyles.Number, CultureInfo.InvariantCulture, out var parsed))
            return parsed;

        return decimal.TryParse(value, NumberStyles.Number, CultureInfo.CurrentCulture, out parsed)
            ? parsed
            : null;
    }

    private static bool TryParseDate(string value, out DateOnly date)
    {
        date = default;

        if (string.IsNullOrWhiteSpace(value))
            return false;

        var v = value.Trim();

        if (DateOnly.TryParse(v, CultureInfo.InvariantCulture, out var only))
        {
            date = only;
            return true;
        }

        if (DateTime.TryParse(v, CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt))
        {
            date = DateOnly.FromDateTime(dt);
            return true;
        }

        return false;
    }

    private static string Normalize(string value)
        => string.IsNullOrWhiteSpace(value) ? string.Empty : value.Trim().ToLowerInvariant();

    private static string NormalizeCurrency(string value)
        => string.IsNullOrWhiteSpace(value) ? "EUR" : value.Trim().ToUpperInvariant();

    private static AssetType MapAssetType(string assetClass)
    {
        var n = Normalize(assetClass);

        return n switch
        {
            "stock" or "shares" or "share" => AssetType.Stock,
            "etf" or "etfs" => AssetType.ETF,
            "fund" or "funds" => AssetType.Fund,
            "bond" or "bonds" => AssetType.Bond,
            "crypto" or "cryptocurrency" => AssetType.Crypto,
            "cash" => AssetType.Cash,
            _ => AssetType.Other
        };
    }

    private enum BuyOrSell
    {
        Buy,
        Sell,
        Dividend,
        Interest,
        Fee,
        Transfer,
        Unsupported
    }

    [GeneratedRegex(@"\b(?:OPEN|CLOSE)\s+(?:BUY|SELL)\s+(\d+(?:[.,]\d+)?)(?:\s*\/\s*\d+(?:[.,]\d+)?)?\s*@\s*(\d+(?:[.,]\d+)?)", RegexOptions.IgnoreCase)]
    private static partial Regex TradeRegex();

    [GeneratedRegex(@"\b(?:BUY|SELL)\s+(\d+(?:[.,]\d+)?)(?:\s*\/\s*\d+(?:[.,]\d+)?)?\s*@\s*(\d+(?:[.,]\d+)?)", RegexOptions.IgnoreCase)]
    private static partial Regex LooseTradeRegex();
}