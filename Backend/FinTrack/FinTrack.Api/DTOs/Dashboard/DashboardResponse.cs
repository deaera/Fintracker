namespace FinTrack.Api.DTOs.Dashboard;

public class DashboardResponse
{
    public decimal TotalBalance { get; set; }

    public decimal Income { get; set; }

    public decimal Expenses { get; set; }

    public decimal Savings { get; set; }

    public decimal SavingsRate { get; set; }

    public List<CategorySummaryResponse> ExpensesByCategory { get; set; } = [];

    public List<LatestTransactionResponse> RecentTransactions { get; set; } = [];

    public List<MonthlyTrendResponse> MonthlyTrend { get; set; } = [];
}