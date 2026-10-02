using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Analytics;

public class AccountCategoryMonthlyResponse
{
    public int Year { get; set; }

    public int Month { get; set; }

    public Guid AccountId { get; set; }

    public string AccountName { get; set; } = string.Empty;

    public string CategoryName { get; set; } = string.Empty;

    public string CategoryColor { get; set; } = "#9E9E9E";

    public CategoryType CategoryType { get; set; }

    /// <summary>Amount normalized to EUR for this group.</summary>
    public decimal Amount { get; set; }
}