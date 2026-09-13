using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Investments;
using FinTrack.Api.Entities;
using FinTrack.Api.Utils.Enums;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class InvestmentPortfolioService
{
    private readonly FinanceDbContext _context;
    private readonly CurrencyService _currency;
    private readonly MarketDataService _market;

    private static readonly string[] Palette =
    [
        "#4F46E5", "#EF5350", "#26A69A", "#FFB300", "#8E24AA", "#1E88E5",
        "#43A047", "#EC407A", "#FF7043", "#29B6F6", "#AB47BC", "#66BB6A",
        "#5C6BC0", "#E57373", "#FFA726", "#7E57C2"
    ];

    public InvestmentPortfolioService(
        FinanceDbContext context,
        CurrencyService currency,
        MarketDataService market)
    {
        _context = context;
        _currency = currency;
        _market = market;
    }

    private sealed class Slot
    {
        public decimal Qty { get; set; }

        public decimal Cost { get; set; }

        public decimal Avg => Qty == 0 ? 0 : Cost / Qty;
    }

    private sealed class PriceCursor
    {
        public List<PriceHistory> Rows { get; set; } = [];

        public int Index { get; set; }

        public decimal? Last { get; set; }
    }

    public async Task<OverviewResponse> GetOverviewAsync()
    {
        var snapshot = await GetSnapshotAsync();

        return new OverviewResponse
        {
            TotalValue = snapshot.TotalValue,
            TotalInvested = snapshot.TotalInvested,
            ProfitLoss = snapshot.TotalValue - snapshot.TotalInvested,
            ReturnPct = snapshot.TotalInvested == 0
                ? 0
                : (snapshot.TotalValue - snapshot.TotalInvested) / snapshot.TotalInvested * 100,
            RealizedGain = snapshot.RealizedGain,
            UnrealizedGain = snapshot.UnrealizedGain,
            CashBalance = snapshot.CashBalance,
            HoldingsCount = snapshot.Holdings.Count,
            AccountCount = snapshot.AccountCount
        };
    }

    public async Task<List<HoldingResponse>> GetHoldingsAsync()
    {
        var snapshot = await GetSnapshotAsync();

        return snapshot.Holdings
            .OrderByDescending(h => h.CurrentValue)
            .ToList();
    }

    public async Task<PerformanceResponse> GetPerformanceAsync(string range)
    {
        return await BuildPerformanceAsync(range);
    }

    public async Task<List<AllocationEntry>> GetAllocationAsync(string by)
    {
        var snapshot = await GetSnapshotAsync();
        var grouped = new List<(string Label, decimal Value)>();

        switch (by)
        {
            case "broker":
                grouped = snapshot.AccountCash
                    .Select(c => (Label: c.AccountName, Value: c.CashEur))
                    .Concat(snapshot.Holdings.Select(h => (Label: h.AccountName, Value: h.CurrentValue)))
                    .GroupBy(x => x.Label)
                    .Select(g => (Label: g.Key, Value: g.Sum(x => x.Value)))
                    .ToList();
                break;

            case "currency":
                grouped = snapshot.AccountCash
                    .Select(c => (Label: c.AccountCurrency, Value: c.CashEur))
                    .Concat(snapshot.Holdings.Select(h => (Label: h.Currency, Value: h.CurrentValue)))
                    .GroupBy(x => x.Label)
                    .Select(g => (Label: g.Key, Value: g.Sum(x => x.Value)))
                    .ToList();
                break;

            case "holding":
                grouped = snapshot.Holdings
                    .Select(h => (Label: $"{h.Ticker} · {h.AccountName}", Value: h.CurrentValue))
                    .GroupBy(x => x.Label)
                    .Select(g => (Label: g.Key, Value: g.Sum(x => x.Value)))
                    .ToList();
                break;

            default:
            case "type":
                grouped = snapshot.AccountCash
                    .Select(c => (Label: "Cash", Value: c.CashEur))
                    .Concat(snapshot.Holdings.Select(h => (Label: h.AssetType, Value: h.CurrentValue)))
                    .GroupBy(x => x.Label)
                    .Select(g => (Label: g.Key, Value: g.Sum(x => x.Value)))
                    .ToList();
                break;
        }

        return grouped
            .OrderByDescending(x => x.Value)
            .Select((entry, index) => new AllocationEntry
            {
                Label = entry.Label,
                Value = entry.Value,
                Color = Palette[index % Palette.Length]
            })
            .ToList();
    }

    public async Task<List<ContributionEntry>> GetContributionsAsync()
    {
        var rates = (await _currency.GetRatesAsync()).Rates;
        var transactions = await LoadOrderedTransactionsAsync();
        var accounts = await _context.InvestmentAccounts.AsNoTracking().ToListAsync();

        var accountById = accounts.ToDictionary(a => a.Id);

        decimal ToEur(decimal amount, string currency)
            => ToEurFromRates(amount, currency, rates);

        var monthly = new Dictionary<(int Year, int Month), decimal>();
        DateOnly? firstActivity = transactions.Count > 0 ? transactions.Min(t => t.Date) : null;

        foreach (var account in accounts)
        {
            var month = firstActivity ?? DateOnly.FromDateTime(DateTime.Today);
            AddContribution(month, ToEur(account.OpeningBalance, account.Currency));
        }

        foreach (var t in transactions)
        {
            var account = accountById[t.InvestmentAccountId];
            var currency = t.AssetId.HasValue ? t.Asset?.Currency ?? account.Currency : account.Currency;

            switch (t.Type)
            {
                case InvestmentTransactionType.TransferIn:
                    AddContribution(t.Date, ToEur(t.Amount, currency));
                    break;
                case InvestmentTransactionType.TransferOut:
                    AddContribution(t.Date, -ToEur(t.Amount, currency));
                    break;
            }
        }

        decimal cumulative = 0;

        var result = monthly
            .OrderBy(kv => kv.Key.Year)
            .ThenBy(kv => kv.Key.Month)
            .Select(kv =>
            {
                cumulative += kv.Value;
                return new ContributionEntry
                {
                    Year = kv.Key.Year,
                    Month = kv.Key.Month,
                    Contributed = kv.Value,
                    Cumulative = cumulative
                };
            })
            .ToList();

        return result;

        void AddContribution(DateOnly date, decimal value)
        {
            var key = (date.Year, date.Month);
            monthly[key] = monthly.GetValueOrDefault(key) + value;
        }
    }

    public async Task<DividendResponse> GetDividendsAsync(int? year)
    {
        var targetYear = year ?? DateTime.Today.Year;
        var today = DateOnly.FromDateTime(DateTime.Today);

        var rows = await _context.InvestmentTransactions
            .AsNoTracking()
            .Where(t => t.Type == InvestmentTransactionType.Dividend)
            .OrderByDescending(t => t.Date)
            .Select(t => new DividendRow
            {
                Id = t.Id,
                Date = t.Date,
                Ticker = t.Asset != null ? t.Asset.Ticker : string.Empty,
                AssetName = t.Asset != null ? t.Asset.Name : string.Empty,
                AccountName = t.InvestmentAccount.Name,
                Amount = t.Amount,
                Currency = t.Asset != null ? t.Asset.Currency : t.InvestmentAccount.Currency
            })
            .ToListAsync();

        var rates = (await _currency.GetRatesAsync()).Rates;

        var monthly = rows
            .Where(r => r.Date.Year == targetYear)
            .GroupBy(r => r.Date.Month)
            .Select(g => new DividendMonthSummary
            {
                Month = g.Key,
                Total = g.Sum(r => ToEurFromRates(r.Amount, r.Currency, rates))
            })
            .OrderBy(m => m.Month)
            .ToList();

        var yearlyTotal = rows
            .Where(r => r.Date.Year == targetYear)
            .Sum(r => ToEurFromRates(r.Amount, r.Currency, rates));

        return new DividendResponse
        {
            Year = targetYear,
            YearlyTotal = yearlyTotal,
            Payments = rows,
            Monthly = monthly,
            Upcoming = rows.Where(r => r.Date > today).ToList()
        };
    }

    public async Task<List<SaleGainResponse>> GetSalesAsync()
    {
        var transactions = await LoadOrderedTransactionsAsync();
        var accounts = await _context.InvestmentAccounts.AsNoTracking().ToListAsync();
        var assets = await _context.Assets.AsNoTracking().ToListAsync();

        var assetById = assets.ToDictionary(a => a.Id);
        var accountById = accounts.ToDictionary(a => a.Id);
        var slots = new Dictionary<(Guid, Guid), Slot>();
        var sales = new List<SaleGainResponse>();

        foreach (var t in transactions)
        {
            if (t.AssetId is not { } assetId)
                continue;

            var key = (t.InvestmentAccountId, assetId);
            var slot = slots.GetValueOrDefault(key) ?? new Slot();

            if (t.Type == InvestmentTransactionType.Buy)
            {
                slot.Qty += t.Quantity;
                slot.Cost += t.Amount + t.Fee;
            }
            else if (t.Type == InvestmentTransactionType.Sell)
            {
                var allocated = Clamp(t.Quantity * slot.Avg, slot.Cost);
                slot.Qty -= t.Quantity;
                slot.Cost -= allocated;

                var asset = assetById[assetId];
                var account = accountById[t.InvestmentAccountId];

                sales.Add(new SaleGainResponse
                {
                    Date = t.Date,
                    Ticker = asset.Ticker,
                    AssetName = asset.Name,
                    AccountName = account.Name,
                    Quantity = t.Quantity,
                    Price = t.Price,
                    Amount = t.Amount,
                    Fee = t.Fee,
                    AllocatedCost = allocated,
                    RealizedGain = t.Amount - t.Fee - allocated
                });
            }

            if (slot.Qty <= 0.0001m)
            {
                slot.Qty = 0;
                slot.Cost = 0;
            }

            slots[key] = slot;
        }

        return sales
            .OrderByDescending(s => s.Date)
            .ThenBy(s => s.Ticker)
            .ToList();
    }

    public async Task<BenchmarkResponse> GetBenchmarkAsync(
        string range,
        string symbol,
        PerformanceResponse portfolioSeries)
    {
        var resolved = await _market.ResolveSymbolAsync(symbol, symbol);

        if (resolved is null)
        {
            return new BenchmarkResponse
            {
                Symbol = symbol,
                Dates = portfolioSeries.Dates,
                Portfolio = portfolioSeries.Values,
                Benchmark = []
            };
        }

        var series = await _market.GetDailySeriesAsync(resolved) ?? [];

        if (series.Count == 0)
        {
            return new BenchmarkResponse
            {
                Symbol = resolved,
                Dates = portfolioSeries.Dates,
                Portfolio = portfolioSeries.Values,
                Benchmark = []
            };
        }

        var byDate = series.ToDictionary(x => x.Date, x => x.Close);

        var benchmarkValues = new List<decimal>();
        decimal last = 0;

        foreach (var dateText in portfolioSeries.Dates)
        {
            var date = DateOnly.Parse(dateText);

            if (byDate.TryGetValue(date, out var close))
            {
                last = close;
            }

            benchmarkValues.Add(last);
        }

        return BuildBenchmarkResponse(portfolioSeries, benchmarkValues, resolved);
    }

    public async Task<PriceRefreshResponse> RefreshPricesAsync()
    {
        var assets = await _context.Assets.AsNoTracking().ToListAsync();
        var response = new PriceRefreshResponse();
        var today = DateOnly.FromDateTime(DateTime.Today);

        foreach (var asset in assets)
        {
            if (asset.ManualPrice.HasValue)
                continue;

            var symbol = await _market.ResolveSymbolAsync(asset.StooqSymbol ?? string.Empty, asset.Ticker);

            if (symbol is null)
            {
                response.Failed++;
                response.Errors.Add(asset.Ticker);
                continue;
            }

            var latest = await _market.GetLatestAsync(symbol);

            if (!latest.HasValue)
            {
                response.Failed++;
                response.Errors.Add(asset.Ticker);
                continue;
            }

            var lastRow = await _context.PriceHistory
                .Where(p => p.AssetId == asset.Id)
                .OrderByDescending(p => p.Date)
                .ThenByDescending(p => p.Id)
                .FirstOrDefaultAsync();

            if (lastRow is null)
            {
                _context.PriceHistory.Add(new PriceHistory
                {
                    AssetId = asset.Id,
                    Date = today,
                    Price = latest.Value,
                    IsManual = false
                });

                response.Updated++;
            }
            else if (lastRow.Date == today)
            {
                if (lastRow.Price != latest.Value)
                {
                    lastRow.Price = latest.Value;
                    _context.PriceHistory.Update(lastRow);
                    response.Updated++;
                }
            }
            else
            {
                _context.PriceHistory.Add(new PriceHistory
                {
                    AssetId = asset.Id,
                    Date = today,
                    Price = latest.Value,
                    IsManual = false
                });

                response.Updated++;
            }
        }

        await _context.SaveChangesAsync();

        return response;
    }

    /// <summary>Current total value (holdings + investment cash) in EUR — feeds net worth.</summary>
    public async Task<decimal> GetCurrentTotalValueAsync()
    {
        var snapshot = await GetSnapshotAsync();
        return snapshot.TotalValue;
    }

    private async Task<Snapshot> GetSnapshotAsync()
    {
        var rates = (await _currency.GetRatesAsync()).Rates;

        decimal ToEur(decimal amount, string currency)
            => ToEurFromRates(amount, currency, rates);

        var accounts = await _context.InvestmentAccounts.AsNoTracking().ToListAsync();
        var assets = await _context.Assets.AsNoTracking().ToListAsync();
        var transactions = await LoadOrderedTransactionsAsync();
        var prices = await _context.PriceHistory
            .AsNoTracking()
            .OrderBy(p => p.AssetId)
            .ThenBy(p => p.Date)
            .ToListAsync();

        var assetById = assets.ToDictionary(a => a.Id);
        var accountById = accounts.ToDictionary(a => a.Id);

        var slots = new Dictionary<(Guid AccountId, Guid AssetId), Slot>();
        var accountCash = accounts.ToDictionary(a => a.Id, a => a.OpeningBalance);
        var lastPriceByAsset = prices
            .GroupBy(p => p.AssetId)
            .ToDictionary(g => g.Key, g => g.Last());

        decimal realizedEur = 0;
        decimal investedEur = 0;

        foreach (var t in transactions)
        {
            var account = accountById[t.InvestmentAccountId];

            if (t.AssetId is null)
            {
                switch (t.Type)
                {
                    case InvestmentTransactionType.Dividend:
                    case InvestmentTransactionType.Interest:
                        realizedEur += ToEur(t.Amount, account.Currency);
                        break;
                }
            }

            if (t.AssetId is { } assetId && assetById.TryGetValue(assetId, out var asset))
            {
                var key = (t.InvestmentAccountId, assetId);
                var slot = slots.GetValueOrDefault(key) ?? new Slot();

                switch (t.Type)
                {
                    case InvestmentTransactionType.Buy:
                        slot.Qty += t.Quantity;
                        slot.Cost += t.Amount + t.Fee;
                        accountCash[t.InvestmentAccountId] -= t.Amount + t.Fee;
                        break;

                    case InvestmentTransactionType.Sell:
                        var allocated = Clamp(t.Quantity * slot.Avg, slot.Cost);
                        slot.Qty -= t.Quantity;
                        slot.Cost -= allocated;
                        accountCash[t.InvestmentAccountId] += t.Amount - t.Fee;
                        realizedEur += ToEur(t.Amount - t.Fee - allocated, asset.Currency);
                        break;

                    case InvestmentTransactionType.Dividend:
                        accountCash[t.InvestmentAccountId] += t.Amount;
                        realizedEur += ToEur(t.Amount, asset.Currency);
                        break;
                }

                if (slot.Qty < 0.0001m)
                {
                    slot.Qty = 0;
                    slot.Cost = 0;
                }

                slots[key] = slot;
            }
        }

        foreach (var t in transactions)
        {
            var account = accountById[t.InvestmentAccountId];
            var currency = t.AssetId is { } assetId && assetById.TryGetValue(assetId, out var a)
                ? a.Currency
                : account.Currency;

            switch (t.Type)
            {
                case InvestmentTransactionType.TransferIn:
                    accountCash[t.InvestmentAccountId] += t.Amount;
                    investedEur += ToEur(t.Amount, currency);
                    break;
                case InvestmentTransactionType.TransferOut:
                    accountCash[t.InvestmentAccountId] -= t.Amount;
                    investedEur -= ToEur(t.Amount, currency);
                    break;
                case InvestmentTransactionType.Fee:
                    accountCash[t.InvestmentAccountId] -= t.Amount;
                    break;
            }
        }

        investedEur += accounts.Sum(a => ToEur(a.OpeningBalance, a.Currency));

        var holdings = new List<HoldingResponse>();

        foreach (var (key, slot) in slots.Where(kv => kv.Value.Qty > 0.0001m))
        {
            var asset = assetById[key.AssetId];
            var account = accountById[key.AccountId];

            var lastPrice = lastPriceByAsset.GetValueOrDefault(key.AssetId);
            var currentPrice = asset.ManualPrice ?? lastPrice?.Price ?? slot.Avg;
            var priceSource = asset.ManualPrice.HasValue
                ? "manual"
                : lastPrice != null
                    ? (lastPrice.IsManual ? "manual" : "market")
                    : "estimated";

            var valueInCurrency = slot.Qty * currentPrice;
            var valueEur = ToEur(valueInCurrency, asset.Currency);
            var costEur = ToEur(slot.Cost, asset.Currency);

            holdings.Add(new HoldingResponse
            {
                AssetId = key.AssetId,
                Ticker = asset.Ticker,
                Name = asset.Name,
                AssetType = asset.Type.ToString(),
                Currency = asset.Currency,
                AccountId = key.AccountId,
                AccountName = account.Name,
                Quantity = slot.Qty,
                AvgCost = slot.Avg,
                Cost = costEur,
                CurrentPrice = currentPrice,
                PriceSource = priceSource,
                CurrentValueInCurrency = valueInCurrency,
                CurrentValue = valueEur,
                Gain = valueEur - costEur,
                GainPct = costEur == 0 ? 0 : (valueEur - costEur) / costEur * 100
            });
        }

        var cashEur = accountCash.Sum(kv => ToEur(kv.Value, accountById[kv.Key].Currency));
        var totalValue = holdings.Sum(h => h.CurrentValue) + cashEur;
        var unrealized = holdings.Sum(h => h.Gain);

        return new Snapshot
        {
            TotalValue = totalValue,
            TotalInvested = investedEur,
            RealizedGain = realizedEur,
            UnrealizedGain = unrealized,
            CashBalance = cashEur,
            Holdings = holdings,
            AccountCash = accounts
                .Select(a => (a.Name, a.Currency, CashEur: ToEur(accountCash[a.Id], a.Currency)))
                .ToList(),
            AccountCount = accounts.Count
        };
    }

    private async Task<PerformanceResponse> BuildPerformanceAsync(string range)
    {
        var rates = (await _currency.GetRatesAsync()).Rates;
        var today = DateOnly.FromDateTime(DateTime.Today);

        var transactions = await LoadOrderedTransactionsAsync();
        var accounts = await _context.InvestmentAccounts.AsNoTracking().ToListAsync();
        var assets = await _context.Assets.AsNoTracking().ToListAsync();

        var accountById = accounts.ToDictionary(a => a.Id);
        var assetById = assets.ToDictionary(a => a.Id);

        var start = ResolveStart(today, range, transactions);
        var stepDays = range.ToUpperInvariant() == "ALL" ? 7 : 1;

        var dates = BuildDates(start, today, stepDays);

        var slots = new Dictionary<(Guid AccountId, Guid AssetId), Slot>();
        var accountCash = accounts.ToDictionary(a => a.Id, a => a.OpeningBalance);
        var assetAggregate = new Dictionary<Guid, Slot>();

        var priceCursors = assets.ToDictionary(a => a.Id, _ => new PriceCursor());

        var prices = await _context.PriceHistory
            .AsNoTracking()
            .OrderBy(p => p.AssetId)
            .ThenBy(p => p.Date)
            .ToListAsync();

        foreach (var group in prices.GroupBy(p => p.AssetId))
        {
            if (priceCursors.TryGetValue(group.Key, out var cursor))
                cursor.Rows = group.ToList();
        }

        decimal ToEur(decimal amount, string currency) => ToEurFromRates(amount, currency, rates);

        decimal CurrentPriceFor(Guid assetId)
        {
            var asset = assetById[assetId];

            if (asset.ManualPrice.HasValue)
                return asset.ManualPrice.Value;

            var cursor = priceCursors[assetId];

            if (cursor.Last.HasValue)
                return cursor.Last.Value;

            if (assetAggregate.TryGetValue(assetId, out var aggregate) && aggregate.Qty > 0)
                return aggregate.Avg;

            return 0;
        }

        int txIndex = 0;
        var values = new List<decimal>();

        foreach (var date in dates)
        {
            while (txIndex < transactions.Count && transactions[txIndex].Date <= date)
            {
                var t = transactions[txIndex];

                if (t.AssetId is { } assetId && assetById.ContainsKey(assetId))
                {
                    var key = (t.InvestmentAccountId, assetId);
                    var slot = slots.GetValueOrDefault(key) ?? new Slot();
                    var aggregate = assetAggregate.GetValueOrDefault(assetId) ?? new Slot();

                    switch (t.Type)
                    {
                        case InvestmentTransactionType.Buy:
                            slot.Qty += t.Quantity;
                            slot.Cost += t.Amount + t.Fee;
                            aggregate.Qty += t.Quantity;
                            aggregate.Cost += t.Amount + t.Fee;
                            accountCash[t.InvestmentAccountId] -= t.Amount + t.Fee;
                            break;

                        case InvestmentTransactionType.Sell:
                            var allocated = Clamp(t.Quantity * slot.Avg, slot.Cost);
                            slot.Qty -= t.Quantity;
                            slot.Cost -= allocated;
                            aggregate.Qty -= t.Quantity;
                            aggregate.Cost -= allocated;
                            accountCash[t.InvestmentAccountId] += t.Amount - t.Fee;
                            break;

                        case InvestmentTransactionType.Dividend:
                            accountCash[t.InvestmentAccountId] += t.Amount;
                            break;
                    }

                    if (slot.Qty <= 0.0001m)
                    {
                        slot.Qty = 0;
                        slot.Cost = 0;
                    }

                    if (aggregate.Qty <= 0.0001m)
                    {
                        aggregate.Qty = 0;
                        aggregate.Cost = 0;
                    }

                    slots[key] = slot;
                    assetAggregate[assetId] = aggregate;
                }
                else if (t.AssetId is null)
                {
                    switch (t.Type)
                    {
                        case InvestmentTransactionType.Dividend:
                        case InvestmentTransactionType.Interest:
                        case InvestmentTransactionType.TransferIn:
                            accountCash[t.InvestmentAccountId] += t.Amount;
                            break;
                        case InvestmentTransactionType.Fee:
                        case InvestmentTransactionType.TransferOut:
                            accountCash[t.InvestmentAccountId] -= t.Amount;
                            break;
                    }
                }

                txIndex++;
            }

            foreach (var asset in assets)
            {
                var cursor = priceCursors[asset.Id];

                while (cursor.Index < cursor.Rows.Count && cursor.Rows[cursor.Index].Date <= date)
                {
                    cursor.Last = cursor.Rows[cursor.Index].Price;
                    cursor.Index++;
                }
            }

            var value = 0m;

            foreach (var (key, slot) in slots)
            {
                if (slot.Qty <= 0.0001m)
                    continue;

                var asset = assetById[key.AssetId];
                var price = CurrentPriceFor(asset.Id);
                value += ToEur(slot.Qty * price, asset.Currency);
            }

            foreach (var account in accounts)
            {
                value += ToEur(accountCash[account.Id], account.Currency);
            }

            values.Add(decimal.Round(value, 2));
        }

        return new PerformanceResponse
        {
            Range = range,
            Dates = dates.Select(d => d.ToString("yyyy-MM-dd")).ToList(),
            Values = values
        };
    }

    private async Task<List<InvestmentTransaction>> LoadOrderedTransactionsAsync()
        => await _context.InvestmentTransactions
            .AsNoTracking()
            .Include(t => t.Asset)
            .OrderBy(t => t.Date)
            .ThenBy(t => t.Id)
            .ToListAsync();

    private static DateOnly ResolveStart(
        DateOnly today,
        string range,
        List<InvestmentTransaction> transactions)
    {
        return range.ToUpperInvariant() switch
        {
            "1M" => today.AddMonths(-1),
            "3M" => today.AddMonths(-3),
            "YTD" => new DateOnly(today.Year, 1, 1),
            "1Y" => today.AddYears(-1),
            _ => transactions.Count == 0
                ? today.AddMonths(-11)
                : transactions.Min(t => t.Date)
        };
    }

    private static List<DateOnly> BuildDates(DateOnly start, DateOnly today, int stepDays)
    {
        var dates = new List<DateOnly>();

        for (var d = start; d <= today; d = d.AddDays(stepDays))
            dates.Add(d);

        if (dates.Count == 0 || dates[^1] != today)
            dates.Add(today);

        if (dates.Count == 1 && start != today)
            dates.Insert(0, start);

        return dates.Count <= 400 ? dates : Downsample(dates);
    }

    private static List<DateOnly> Downsample(List<DateOnly> dates)
    {
        var step = dates.Count / 400;

        return dates
            .Where((_, i) => i % step == 0)
            .Append(dates[^1])
            .Distinct()
            .ToList();
    }

    private static BenchmarkResponse BuildBenchmarkResponse(
        PerformanceResponse portfolio,
        List<decimal> benchmarkValues,
        string symbol)
    {
        var firstIndex = -1;

        for (var i = 0; i < benchmarkValues.Count; i++)
        {
            if (benchmarkValues[i] > 0 && portfolio.Values[i] > 0)
            {
                firstIndex = i;
                break;
            }
        }

        if (firstIndex < 0)
        {
            return new BenchmarkResponse
            {
                Symbol = symbol,
                Dates = portfolio.Dates,
                Portfolio = portfolio.Values,
                Benchmark = []
            };
        }

        var portfolioRef = portfolio.Values[firstIndex];
        var benchmarkRef = benchmarkValues[firstIndex];

        return new BenchmarkResponse
        {
            Symbol = symbol,
            Dates = portfolio.Dates,
            Portfolio = portfolio.Values
                .Select(v => v == 0 ? 0 : decimal.Round(v / portfolioRef * 100, 2))
                .ToList(),
            Benchmark = benchmarkValues
                .Select(v => v == 0 ? 0 : decimal.Round(v / benchmarkRef * 100, 2))
                .ToList()
        };
    }

    private static decimal Clamp(decimal value, decimal max)
        => value < 0 ? 0 : Math.Min(value, max);

    private static decimal ToEurFromRates(decimal amount, string currency, Dictionary<string, decimal> rates)
    {
        if (amount == 0 || currency == "EUR")
            return amount;

        return rates.TryGetValue(currency.ToUpperInvariant(), out var rate) && rate > 0
            ? amount / rate
            : amount;
    }

    private sealed class Snapshot
    {
        public decimal TotalValue { get; init; }

        public decimal TotalInvested { get; init; }

        public decimal RealizedGain { get; init; }

        public decimal UnrealizedGain { get; init; }

        public decimal CashBalance { get; init; }

        public List<HoldingResponse> Holdings { get; init; } = [];

        public List<(string AccountName, string AccountCurrency, decimal CashEur)> AccountCash { get; init; } = [];

        public int AccountCount { get; init; }
    }
}