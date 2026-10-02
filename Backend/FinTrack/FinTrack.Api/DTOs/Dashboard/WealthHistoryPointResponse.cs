namespace FinTrack.Api.DTOs.Dashboard;

/// <summary>One month-end snapshot of net worth and its components, all normalized to EUR.</summary>
public class WealthHistoryPointResponse
{
    public int Year { get; set; }

    public int Month { get; set; }

    public decimal TotalBalance { get; set; }

    public decimal InvestmentValue { get; set; }

    public decimal CreditDebt { get; set; }

    public decimal NetWorth { get; set; }
}