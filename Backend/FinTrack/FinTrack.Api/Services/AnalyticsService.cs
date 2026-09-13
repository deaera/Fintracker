using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Analytics;
using FinTrack.Api.DTOs.Dashboard;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class AnalyticsService
{
    private readonly FinanceDbContext _context;

    public AnalyticsService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<AnalyticsResponse> GetAnalyticsAsync(int? month = null, int? year = null)
    {
        var today = DateOnly.FromDateTime(DateTime.Today);

        var periodTransactions = await GetPeriodTransactionsAsync(month, year, today);

        var income = periodTransactions
            .Where(t => t.Category.Type == CategoryType.Income)
            .Sum(t => t.Amount);

        var expenses = periodTransactions
            .Where(t => t.Category.Type == CategoryType.Expense)
            .Sum(t => t.Amount);

        var savings = income - expenses;

        var savingsRate = income == 0
            ? 0
            : savings / income * 100;

        var monthly = await GetMonthlyAsync(month, year, today);

        var monthlyWithData = monthly
            .Where(m => m.Income != 0 || m.Expenses != 0)
            .ToList();

        var monthCount = monthlyWithData.Count;

        var averageMonthlySpending = monthCount == 0
            ? 0
            : expenses / monthCount;

        var bestMonth = monthlyWithData
            .OrderByDescending(m => m.Savings)
            .FirstOrDefault();

        return new AnalyticsResponse
        {
            TotalIncome = income,
            TotalExpenses = expenses,
            Savings = savings,
            SavingsRate = savingsRate,
            AverageMonthlySpending = averageMonthlySpending,
            MonthCount = monthCount,
            BestMonth = bestMonth,
            Monthly = monthlyWithData,
            IncomeBreakdown = BuildBreakdown(periodTransactions, CategoryType.Income, income),
            ExpenseBreakdown = BuildBreakdown(periodTransactions, CategoryType.Expense, expenses)
        };
    }

    private async Task<List<CashTransaction>> GetPeriodTransactionsAsync(
        int? month,
        int? year,
        DateOnly today)
    {
        var query = _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Category)
            .AsQueryable();

        if (month.HasValue)
        {
            var targetYear = year ?? today.Year;
            query = query.Where(t =>
                t.Date.Month == month.Value &&
                t.Date.Year == targetYear);
        }
        else if (year.HasValue)
        {
            query = query.Where(t => t.Date.Year == year.Value);
        }

        return await query.ToListAsync();
    }

    private async Task<List<MonthlyPointResponse>> GetMonthlyAsync(
        int? month,
        int? year,
        DateOnly today)
    {
        var query = _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Category)
            .AsQueryable();

        if (month.HasValue)
        {
            var targetYear = year ?? today.Year;
            query = query.Where(t =>
                t.Date.Month == month.Value &&
                t.Date.Year == targetYear);
        }
        else if (year.HasValue)
        {
            query = query.Where(t => t.Date.Year == year.Value);
        }

        var transactions = await query.ToListAsync();

        return transactions
            .GroupBy(t => new { t.Date.Year, t.Date.Month })
            .Select(g => new MonthlyPointResponse
            {
                Year = g.Key.Year,
                Month = g.Key.Month,
                Income = g.Where(x => x.Category.Type == CategoryType.Income).Sum(x => x.Amount),
                Expenses = g.Where(x => x.Category.Type == CategoryType.Expense).Sum(x => x.Amount)
            })
            .OrderBy(m => m.Year)
            .ThenBy(m => m.Month)
            .Select(m =>
            {
                m.Savings = m.Income - m.Expenses;
                return m;
            })
            .ToList();
    }

    private List<CategorySpendingResponse> BuildBreakdown(
        List<CashTransaction> transactions,
        CategoryType type,
        decimal total)
    {
        return transactions
            .Where(t => t.Category.Type == type)
            .GroupBy(t => new { t.Category.Name, t.Category.Color })
            .Select(g => new CategorySpendingResponse
            {
                Category = g.Key.Name,
                Amount = g.Sum(x => x.Amount),
                Percentage = total == 0
                    ? 0
                    : (double)(g.Sum(x => x.Amount) / total * 100),
                Color = g.Key.Color
            })
            .OrderByDescending(x => x.Amount)
            .ToList();
    }
}