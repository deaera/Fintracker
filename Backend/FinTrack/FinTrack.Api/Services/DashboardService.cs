using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Dashboard;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class DashboardService
{
    private readonly FinanceDbContext _context;
    private readonly BalanceService _balanceService;

    public DashboardService(
        FinanceDbContext context,
        BalanceService balanceService)
    {
        _context = context;
        _balanceService = balanceService;
    }

    public async Task<DashboardResponse> GetDashboardAsync(int? month = null, int? year = null)
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

        var expensesByCategory = periodTransactions
            .Where(t => t.Category.Type == CategoryType.Expense)
            .GroupBy(t => new { t.Category.Name, t.Category.Color })
            .Select(g => new CategorySummaryResponse
            {
                Category = g.Key.Name,
                Amount = g.Sum(x => x.Amount),
                Color = g.Key.Color
            })
            .OrderByDescending(x => x.Amount)
            .ToList();

        var recentTransactions = await _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Category)
            .Include(t => t.Account)
            .OrderByDescending(t => t.Date)
            .ThenByDescending(t => t.Id)
            .Take(10)
            .Select(t => new LatestTransactionResponse
            {
                Id = t.Id,
                Date = t.Date,
                Description = t.Description,
                Amount = t.Amount,
                Category = t.Category.Name,
                CategoryType = t.Category.Type,
                Account = t.Account.Name
            })
            .ToListAsync();

        var totalBalance = await _balanceService.GetTotalCashAsync();

        var monthlyTrend = await GetMonthlyTrendAsync(today, month, year);

        return new DashboardResponse
        {
            TotalBalance = totalBalance,
            Income = income,
            Expenses = expenses,
            Savings = savings,
            SavingsRate = savingsRate,
            ExpensesByCategory = expensesByCategory,
            RecentTransactions = recentTransactions,
            MonthlyTrend = monthlyTrend
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

    private async Task<List<MonthlyTrendResponse>> GetMonthlyTrendAsync(
        DateOnly today,
        int? month,
        int? year)
    {
        var transactions = await _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Category)
            .ToListAsync();

        var grouped = transactions
            .GroupBy(t => new { t.Date.Year, t.Date.Month })
            .Select(g => new MonthlyTrendResponse
            {
                Year = g.Key.Year,
                Month = g.Key.Month,
                Income = g.Where(x => x.Category.Type == CategoryType.Income).Sum(x => x.Amount),
                Expenses = g.Where(x => x.Category.Type == CategoryType.Expense).Sum(x => x.Amount)
            })
            .ToList();

        foreach (var item in grouped)
        {
            item.Savings = item.Income - item.Expenses;
        }

        var allTime = !month.HasValue && !year.HasValue;

        if (allTime)
        {
            var start = new DateOnly(today.Year, today.Month, 1).AddMonths(-5);

            return Enumerable.Range(0, 6)
                .Select(offset => start.AddMonths(offset))
                .Select(monthStart => new MonthlyTrendResponse
                {
                    Year = monthStart.Year,
                    Month = monthStart.Month,
                    Income = 0,
                    Expenses = 0,
                    Savings = 0
                })
                .GroupJoin(
                    grouped,
                    frame => (frame.Year, frame.Month),
                    actual => (actual.Year, actual.Month),
                    (frame, actual) => actual.FirstOrDefault() ?? frame)
                .ToList();
        }

        return grouped
            .Where(g => g.Income != 0 || g.Expenses != 0)
            .OrderBy(g => g.Year)
            .ThenBy(g => g.Month)
            .ToList();
    }
}