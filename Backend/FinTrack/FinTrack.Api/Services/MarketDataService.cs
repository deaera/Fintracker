using System.Globalization;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace FinTrack.Api.Services;

/// <summary>Keyless market-data provider backed by Yahoo Finance's public chart API.</summary>
public class MarketDataService
{
    private static readonly HttpClient Http = new(new HttpClientHandler
    {
        AutomaticDecompression = System.Net.DecompressionMethods.All,
        UseCookies = false
    })
    {
        Timeout = TimeSpan.FromSeconds(12)
    };

    static MarketDataService()
    {
        Http.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36");
        Http.DefaultRequestHeaders.Add("Accept", "*/*");
    }

    private static readonly Dictionary<string, string> RangeMap = new()
    {
        ["1M"] = "1mo",
        ["3M"] = "3mo",
        ["YTD"] = "1y",
        ["1Y"] = "1y",
        ["ALL"] = "max"
    };

    /// <summary>Resolves a provider symbol by trying explicit override then ticker guesses.</summary>
    public async Task<string?> ResolveSymbolAsync(string explicitSymbol, string ticker)
    {
        var candidates = new List<string>();

        if (!string.IsNullOrWhiteSpace(explicitSymbol))
            candidates.Add(explicitSymbol.Trim());

        var t = ticker.Trim();

        if (t.Contains('.'))
        {
            candidates.Add(t);
        }
        else
        {
            candidates.Add(t);
            candidates.Add(t + ".DE");
            candidates.Add(t + ".US");
        }

        foreach (var candidate in candidates.Distinct())
        {
            var price = await GetLatestAsync(candidate);

            if (price.HasValue)
                return candidate;
        }

        return null;
    }

    public async Task<decimal?> GetLatestAsync(string symbol)
    {
        var node = await FetchChartNodeAsync(symbol, "1d");

        if (node is null)
            return null;

        var meta = node["chart"]?["result"]?[0]?["meta"];

        if (meta?["regularMarketPrice"] is { } price)
        {
            var raw = price.GetValue<double>();

            if (raw > 0)
                return decimal.Round(Convert.ToDecimal(raw, CultureInfo.InvariantCulture), 4);
        }

        var closes = node["chart"]?["result"]?[0]?["indicators"]?["quote"]?[0]?["close"]?.AsArray();

        if (closes is not null)
        {
            for (var i = closes.Count - 1; i >= 0; i--)
            {
                if (closes[i]?.AsValue() is { } cv && cv.GetValueKind() == JsonValueKind.Number)
                {
                    var raw = cv.GetValue<double>();

                    if (raw > 0)
                        return decimal.Round(Convert.ToDecimal(raw, CultureInfo.InvariantCulture), 4);
                }
            }
        }

        return null;
    }

    /// <summary>Returns daily closes (oldest first) for a symbol, or null when unavailable.</summary>
    public async Task<List<(DateOnly Date, decimal Close)>?> GetDailySeriesAsync(string symbol, string range = "1Y")
    {
        var yahooRange = RangeMap.TryGetValue(range.ToUpperInvariant(), out var mapped) ? mapped : "1y";
        var node = await FetchChartNodeAsync(symbol, yahooRange);

        if (node is null)
            return null;

        var timestamps = node["chart"]?["result"]?[0]?["timestamp"]?.AsArray();
        var closes = node["chart"]?["result"]?[0]?["indicators"]?["quote"]?[0]?["close"]?.AsArray();

        if (timestamps is null || closes is null)
            return null;

        var rows = new List<(DateOnly, decimal)>();

        for (var i = 0; i < timestamps.Count; i++)
        {
            if (i >= closes.Count || timestamps[i]?.AsValue() is not { } tv || closes[i]?.AsValue() is not { } cv)
                continue;

            if (cv.GetValueKind() != JsonValueKind.Number)
                continue;

            var close = Convert.ToDecimal(cv.GetValue<double>(), CultureInfo.InvariantCulture);

            if (close <= 0)
                continue;

            var date = DateTimeOffset.FromUnixTimeSeconds(tv.GetValue<long>()).UtcDateTime.ToLocalTime();

            rows.Add((DateOnly.FromDateTime(date), decimal.Round(close, 4)));
        }

        return rows.Count == 0 ? null : rows;
    }

    private static async Task<JsonNode?> FetchChartNodeAsync(string symbol, string yahooRange)
    {
        var url = $"https://query1.finance.yahoo.com/v8/finance/chart/{Uri.EscapeDataString(symbol.ToUpperInvariant())}?range={yahooRange}&interval=1d";

        try
        {
            using var response = await Http.GetAsync(url);
            var body = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
            {
                Console.WriteLine($"[MarketData] HTTP {(int)response.StatusCode} for {symbol}: {body[..Math.Min(150, body.Length)]}");
                return null;
            }

            var node = JsonNode.Parse(body);

            if (node?["chart"]?["result"] is not { } result || result.AsArray().Count == 0)
            {
                Console.WriteLine($"[MarketData] empty chart for {symbol}: {body[..Math.Min(150, body.Length)]}");
                return null;
            }

            return node;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[MarketData] {symbol}: {ex.Message}");
            return null;
        }
    }
}