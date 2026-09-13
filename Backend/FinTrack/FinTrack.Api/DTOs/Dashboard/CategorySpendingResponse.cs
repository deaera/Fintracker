namespace FinTrack.Api.DTOs.Dashboard;

public class CategorySpendingResponse
{
    public string Category { get; set; } = string.Empty;

    public decimal Amount { get; set; }

    public double Percentage { get; set; }

    public string Color { get; set; } = "#78909C";
}