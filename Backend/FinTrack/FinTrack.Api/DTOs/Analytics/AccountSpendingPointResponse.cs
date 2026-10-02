using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Analytics;

public class AccountSpendingPointResponse
{
    public int Year { get; set; }

    public int Month { get; set; }

    public Guid AccountId { get; set; }

    public string AccountName { get; set; } = string.Empty;

    public string AccountCurrency { get; set; } = "EUR";

    public CategoryType CategoryType { get; set; }

    /// <summary>Amount normalized to EUR for this group.</summary>
    public decimal Amount { get; set; }
}