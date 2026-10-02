using FinTrack.Api.DTOs.Dashboard;

namespace FinTrack.Api.DTOs.Analytics;

public class AnalyticsResponse
{
    public decimal TotalIncome { get; set; }

    public decimal TotalExpenses { get; set; }

    public decimal Savings { get; set; }

    public decimal SavingsRate { get; set; }

    public decimal AverageMonthlySpending { get; set; }

    public int MonthCount { get; set; }

    public MonthlyPointResponse? BestMonth { get; set; }

    public List<MonthlyPointResponse> Monthly { get; set; } = [];

    public List<CategorySpendingResponse> IncomeBreakdown { get; set; } = [];

    public List<CategorySpendingResponse> ExpenseBreakdown { get; set; } = [];

    /// <summary>Monthly totals per account (all-time; can be filtered client-side by account/type).</summary>
    public List<AccountMonthlySpendingResponse> AccountMonthly { get; set; } = [];

    /// <summary>Monthly totals per account and category (for stacked expense/income breakdowns).</summary>
    public List<AccountCategoryMonthlyResponse> AccountCategoryMonthly { get; set; } = [];
}