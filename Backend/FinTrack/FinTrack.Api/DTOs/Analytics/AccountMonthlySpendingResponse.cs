namespace FinTrack.Api.DTOs.Analytics;

public class AccountMonthlySpendingResponse
{
    public int Year { get; set; }

    public int Month { get; set; }

    public Guid AccountId { get; set; }

    public string AccountName { get; set; } = string.Empty;

    public string AccountCurrency { get; set; } = "EUR";

    public decimal Income { get; set; }

    public decimal Expenses { get; set; }
}