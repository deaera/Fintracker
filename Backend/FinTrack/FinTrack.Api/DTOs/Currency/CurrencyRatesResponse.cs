namespace FinTrack.Api.DTOs.Currency;

public class CurrencyRatesResponse
{
    public string Base { get; set; } = "EUR";

    public Dictionary<string, decimal> Rates { get; set; } = new();

    public DateTimeOffset UpdatedAt { get; set; }

    public string Source { get; set; } = "live";
}