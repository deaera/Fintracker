namespace FinTrack.Api.DTOs.Dashboard;

public class CategorySummaryResponse
{
    public string Category { get; set; } = string.Empty;

    public decimal Amount { get; set; }

    public string Color { get; set; } = "#78909C";
}