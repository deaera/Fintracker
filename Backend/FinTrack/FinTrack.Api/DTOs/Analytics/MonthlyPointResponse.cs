namespace FinTrack.Api.DTOs.Analytics;

public class MonthlyPointResponse
{
    public int Year { get; set; }

    public int Month { get; set; }

    public decimal Income { get; set; }

    public decimal Expenses { get; set; }

    public decimal Savings { get; set; }
}