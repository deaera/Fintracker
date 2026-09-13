using System.Globalization;
using System.Text;
using ClosedXML.Excel;

namespace FinTrack.Api.Services;

/// <summary>
/// Extracts the three XTB report sheets (Cash Operations, Open Positions,
/// Closed Positions) from a .xlsx export into plain tab-separated text that
/// the line-based parsers already understand.
/// </summary>
public static class XtbWorkbookParser
{
    public sealed class WorkbookResult
    {
        public List<string> ParsedSheets { get; set; } = [];

        public string CashText { get; set; } = string.Empty;

        public string? OpenText { get; set; }

        public List<(string Ticker, int Trades, decimal Profit)> Closed { get; set; } = [];
    }

    public static WorkbookResult Extract(byte[] bytes)
    {
        var result = new WorkbookResult();

        using var stream = new MemoryStream(bytes);
        using var wb = new XLWorkbook(stream);

        foreach (var ws in wb.Worksheets)
        {
            var role = DetectRole(ws);

            switch (role)
            {
                case Role.Cash:
                    var cash = ExtractCash(ws);
                    if (cash.Count > 0)
                    {
                        result.CashText = string.Join('\n', cash);
                        result.ParsedSheets.Add(PrettyName(ws.Name, "Cash Operations"));
                    }
                    break;

                case Role.Open:
                    var open = ExtractOpen(ws);
                    if (open.Count > 0)
                    {
                        result.OpenText = "Symbol\tQuantity\n" + string.Join('\n', open);
                        result.ParsedSheets.Add(PrettyName(ws.Name, "Open Positions"));
                    }
                    break;

                case Role.Closed:
                    var closed = ExtractClosed(ws);
                    if (closed.Count > 0)
                    {
                        result.Closed = closed;
                        result.ParsedSheets.Add(PrettyName(ws.Name, "Closed Positions"));
                    }
                    break;
            }
        }

        return result;
    }

    private static List<string> ExtractCash(IXLWorksheet ws)
    {
        var lastRow = ws.LastRowUsed()?.RowNumber() ?? 0;

        if (lastRow == 0)
            return [];

        var header = FindHeaderRow(ws, lastRow, CashKeywords);

        int typeCol = header > 0 ? Column(ws, header, "type") : 1;
        int nameCol = header > 0 ? FirstColumn(ws, header, "name", "instrument") : 2;
        int symbolCol = header > 0 ? Column(ws, header, "symbol", "ticker", "code") : 3;
        int classCol = header > 0 ? Column(ws, header, "class", "asset") : 4;
        int timeCol = header > 0 ? Column(ws, header, "time", "date") : 5;
        int amountCol = header > 0 ? Column(ws, header, "amount", "value") : 6;
        int orderCol = header > 0 ? Column(ws, header, "order", "id") : 7;
        int noteCol = header > 0 ? Column(ws, header, "note", "description", "comment") : 8;

        var lines = new List<string>();

        for (var r = header > 0 ? header + 1 : 1; r <= lastRow; r++)
        {
            var type = CellText(ws, r, typeCol);

            if (string.IsNullOrWhiteSpace(type))
                continue;

            var line = string.Join('\t', new[]
            {
                type,
                CellText(ws, r, nameCol),
                CellText(ws, r, symbolCol),
                CellText(ws, r, classCol),
                CellText(ws, r, timeCol),
                CellText(ws, r, amountCol),
                CellText(ws, r, orderCol),
                CellText(ws, r, noteCol)
            });

            lines.Add(line);
        }

        return lines;
    }

    private static List<string> ExtractOpen(IXLWorksheet ws)
    {
        var lastRow = ws.LastRowUsed()?.RowNumber() ?? 0;

        if (lastRow == 0)
            return [];

        var header = FindHeaderRow(ws, lastRow, OpenKeywords);

        if (header <= 0)
            return [];

        var symbolCol = Column(ws, header, "ticker", "symbol", "code");

        if (symbolCol < 0)
            symbolCol = Column(ws, header, "instrument", "name");

        var qtyCol = Column(ws, header, "quantity", "volume", "size");

        var typeCol = Column(ws, header, "type", "side", "direction");

        if (symbolCol < 0 || qtyCol < 0)
            return [];

        var lines = new List<string>();

        for (var r = header + 1; r <= lastRow; r++)
        {
            var ticker = CellText(ws, r, symbolCol).Trim();

            if (string.IsNullOrWhiteSpace(ticker))
                continue;

            if (typeCol >= 0 && !string.IsNullOrWhiteSpace(CellText(ws, r, typeCol)))
                continue;

            var qty = CellText(ws, r, qtyCol);

            lines.Add($"{ticker}\t{qty}");
        }

        return lines;
    }

    private static List<(string Ticker, int Trades, decimal Profit)> ExtractClosed(IXLWorksheet ws)
    {
        var lastRow = ws.LastRowUsed()?.RowNumber() ?? 0;

        if (lastRow == 0)
            return [];

        var header = FindHeaderRow(ws, lastRow, ClosedKeywords);

        if (header <= 0)
            return [];

        var symbolCol = Column(ws, header, "ticker", "symbol", "code");

        if (symbolCol < 0)
            symbolCol = Column(ws, header, "instrument", "name");

        var profitCol = Column(ws, header, "profit", "loss", "result", "gain", "p/l", "p&l");

        if (symbolCol < 0)
            return [];

        var rows = new List<(string Ticker, int Trades, decimal Profit)>();
        var acc = new Dictionary<string, (int Trades, decimal Profit)>(StringComparer.OrdinalIgnoreCase);

        for (var r = header + 1; r <= lastRow; r++)
        {
            var ticker = CellText(ws, r, symbolCol).Trim();

            if (string.IsNullOrWhiteSpace(ticker))
                continue;

            if (profitCol >= 0 && IsTotalRow(CellText(ws, r, profitCol)))
                continue;

            var tickerKey = Normalize(ticker);

            var value = accumulated(acc, tickerKey);
            value.Trades++;

            if (profitCol >= 0 && decimal.TryParse(CellText(ws, r, profitCol), NumberStyles.Number, CultureInfo.InvariantCulture, out var profit))
                value.Profit += profit;

            acc[tickerKey] = value;
        }

        foreach (var kv in acc)
        {
            var ticker = kv.Key;

            if (ticker.IndexOf('.') > 0)
                ticker = ticker[..ticker.IndexOf('.')];

            rows.Add((ticker.ToUpperInvariant(), kv.Value.Trades, decimal.Round(kv.Value.Profit, 2)));
        }

        return rows;

        static (int Trades, decimal Profit) accumulated(Dictionary<string, (int, decimal)> dict, string key)
            => dict.TryGetValue(key, out var v) ? v : (0, 0);
    }

    private static bool IsTotalRow(string value)
    {
        var n = Normalize(value);

        return n.Contains("total") || n.Length == 0;
    }

    private static int FindHeaderRow(IXLWorksheet ws, int lastRow, string[][] keywords)
    {
        var limit = Math.Min(lastRow, 30);

        for (var r = 1; r <= limit; r++)
        {
            int cells = 0;
            bool hasDominant = false;

            var lastCol = ws.LastColumnUsed()?.ColumnNumber() ?? 0;

            for (var c = 1; c <= lastCol; c++)
            {
                var text = Normalize(CellText(ws, r, c));

                if (text.Length == 0)
                    continue;

                if (keywords.Any(g => g.Any(k => text == k || text.StartsWith(k + " ") || text.Contains(k))))
                    cells++;
            }

            if (cells < 2)
                continue;

            for (var c = 1; c <= lastCol; c++)
            {
                var text = Normalize(CellText(ws, r, c));

                if (text is "type" or "symbol" or "ticker" or "amount" or "profit" or "quantity")
                {
                    hasDominant = true;
                    break;
                }
            }

            if (hasDominant)
                return r;
        }

        return 0;
    }

    private static int Column(IXLWorksheet ws, int headerRow, params string[] terms)
        => OrderedMatch(primary: true, ws, headerRow, terms) ?? OrderedMatch(primary: false, ws, headerRow, terms) ?? -1;

    private static int FirstColumn(IXLWorksheet ws, int headerRow, params string[] terms)
        => OrderedMatch(primary: false, ws, headerRow, terms, firstOnly: true) ?? -1;

    private static int? OrderedMatch(bool primary, IXLWorksheet ws, int headerRow, string[] terms, bool firstOnly = false)
    {
        var lastCol = ws.LastColumnUsed()?.ColumnNumber() ?? 0;

        for (var c = 1; c <= lastCol; c++)
        {
            var text = Normalize(CellText(ws, headerRow, c));

            if (text.Length == 0 || text == "my trades")
                continue;

            bool matches;

            if (primary)
                matches = terms.Any(t => text == t || text.StartsWith(t + " ") || text.StartsWith(t + "/"));
            else
                matches = terms.Any(text.Contains);

            if (matches)
                return c;
        }

        return null;
    }

    private static Role DetectRole(IXLWorksheet ws)
    {
        var name = Normalize(ws.Name);

        if (name.Contains("cash") || name.Contains("operation") || name.Contains("activity"))
            return Role.Cash;

        if (name.Contains("closed") || name.Contains("closed positions"))
            return Role.Closed;

        if (name.Contains("open"))
            return Role.Open;

        var lastRow = ws.LastRowUsed()?.RowNumber() ?? 0;

        if (lastRow > 0 && FindHeaderRow(ws, lastRow, CashKeywords) > 0)
            return Role.Cash;

        if (lastRow > 0 && FindHeaderRow(ws, lastRow, OpenKeywords) > 0)
            return Role.Open;

        if (lastRow > 0 && FindHeaderRow(ws, lastRow, ClosedKeywords) > 0)
            return Role.Closed;

        return Role.Unknown;
    }

    private static string CellText(IXLWorksheet ws, int row, int col)
    {
        if (col <= 0)
            return string.Empty;

        var cell = ws.Cell(row, col);

        if (cell.IsEmpty())
            return string.Empty;

        var value = cell.Value;

        if (value.IsDateTime)
            return value.GetDateTime().ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);

        if (value.IsNumber)
            return value.GetNumber().ToString("0.################", CultureInfo.InvariantCulture);

        return value.ToString().Trim();
    }

    private static string PrettyName(string sheetName, string fallback)
        => string.IsNullOrWhiteSpace(sheetName) ? fallback : sheetName.Trim();

    private static string Normalize(string value)
        => string.IsNullOrWhiteSpace(value) ? string.Empty : value.Trim().ToLowerInvariant();

    private static readonly string[][] CashKeywords =
    [
        ["type", "operation"],
        ["symbol", "ticker", "code"],
        ["name"],
        ["class"],
        ["time", "date"],
        ["amount", "value"],
        ["order", "id"],
        ["note", "description", "comment"]
    ];

    private static readonly string[][] OpenKeywords =
    [
        ["symbol", "ticker", "code", "instrument"],
        ["quantity", "volume", "size", "position", "contracts"]
    ];

    private static readonly string[][] ClosedKeywords =
    [
        ["symbol", "ticker", "code", "instrument"],
        ["profit", "loss", "result", "gain", "p/l", "p&l"]
    ];

    private enum Role
    {
        Unknown,
        Cash,
        Open,
        Closed
    }
}