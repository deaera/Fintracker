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
        ["RON"] = 4.98m
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

            if (payload?.Rates is { Count: > 0 } &&
                payload.Rates.TryGetValue("USD", out var usd) &&
                payload.Rates.TryGetValue("RON", out var ron))
            {
                var response = new CurrencyRatesResponse
                {
                    Base = "EUR",
                    Rates = new Dictionary<string, decimal>
                    {
                        ["EUR"] = 1m,
                        ["USD"] = usd,
                        ["RON"] = ron
                    },
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

    private sealed class OpenErResponse
    {
        public Dictionary<string, decimal>? Rates { get; set; }
    }
}