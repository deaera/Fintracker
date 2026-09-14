namespace FinTrack.Api.DTOs.Dashboard;

public class DashboardResponse
{
    public decimal TotalBalance { get; set; }

    public decimal InvestmentValue { get; set; }

    public decimal NetWorth { get; set; }

    /// <summary>Total credit card debt, normalized to EUR (positive number; subtracted from net worth).</summary>
    public decimal CreditDebt { get; set; }

    public decimal Income { get; set; }

    public decimal Expenses { get; set; }

    public decimal Savings { get; set; }

    public decimal SavingsRate { get; set; }

    public List<CategorySummaryResponse> ExpensesByCategory { get; set; } = [];

    public List<LatestTransactionResponse> RecentTransactions { get; set; } = [];

    public List<MonthlyTrendResponse> MonthlyTrend { get; set; } = [];

    public List<CreditCardInfoResponse> CreditCards { get; set; } = [];
}