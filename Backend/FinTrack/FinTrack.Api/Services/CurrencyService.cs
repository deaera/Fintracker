using System.Net.Http.Json;
using FinTrack.Api.DTOs.Currency;

namespace FinTrack.Api.Services;

public class CurrencyService
{
    private static readonly HttpClient Http = new()
    {
        Timeout = TimeSpan.FromSeconds(8),
        BaseAddress = new Uri("https://open.er-api.com/v6/latest/")
    };

    private static readonly TimeSpan CacheDuration = TimeSpan.FromHours(1);

    private static readonly object Lock = new();

    private static CurrencyRatesResponse? _cache;

    private static DateTimeOffset _cachedAt;

    private static readonly Dictionary<string, decimal> FallbackRates = new()
    {
        ["EUR"] = 1m,
        ["USD"] = 1.08m,
        ["RON"] = 4.98m,
        ["GBP"] = 1.14m,
        ["CHF"] = 1.20m
    };

    public async Task<CurrencyRatesResponse> GetRatesAsync()
    {
        lock (Lock)
        {
            if (_cache is not null &&
                DateTimeOffset.UtcNow - _cachedAt < CacheDuration)
            {
                return _cache;
            }
        }

        try
        {
            var payload = await Http.GetFromJsonAsync<OpenErResponse>("EUR");

            if (payload?.Rates is { Count: > 0 })
            {
                foreach (var fallback in FallbackRates)
                {
                    payload.Rates.TryAdd(fallback.Key, fallback.Value);
                }

                var response = new CurrencyRatesResponse
                {
                    Base = "EUR",
                    Rates = payload.Rates,
                    UpdatedAt = DateTimeOffset.UtcNow,
                    Source = "live"
                };

                lock (Lock)
                {
                    _cache = response;
                    _cachedAt = DateTimeOffset.UtcNow;
                }

                return response;
            }
        }
        catch
        {
            // API unreachable -> fall back to cached/default rates below.
        }

        return new CurrencyRatesResponse
        {
            Base = "EUR",
            Rates = new Dictionary<string, decimal>(FallbackRates),
            UpdatedAt = DateTimeOffset.UtcNow,
            Source = "fallback"
        };
    }

    /// <summary>Converts an amount from one currency to another. Missing currencies are treated as 1:1.</summary>
    public async Task<decimal> ConvertAsync(decimal amount, string from, string to)
    {
        if (amount == 0 || from == to)
            return amount;

        var rates = await GetRatesAsync();
        return Convert(amount, from, to, rates.Rates);
    }

    public decimal ConvertToBase(decimal amount, string from, Dictionary<string, decimal> rates)
        => Convert(amount, from, "EUR", rates);

    /// <summary>Converts an amount to a target currency using pre-fetched rates. Missing currencies are treated as 1:1.</summary>
    public decimal ConvertTo(decimal amount, string from, string to, Dictionary<string, decimal> rates)
        => Convert(amount, from, to, rates);

    private static decimal Convert(decimal amount, string from, string to, Dictionary<string, decimal> rates)
    {
        var fromRate = rates.TryGetValue(ConvertCode(from), out var f) ? f : 1m;
        var toRate = rates.TryGetValue(ConvertCode(to), out var t) ? t : 1m;

        return amount * toRate / fromRate;
    }

    private static string ConvertCode(string code) => code.ToUpperInvariant();

    private sealed class OpenErResponse
    {
        public Dictionary<string, decimal>? Rates { get; set; }
    }
}