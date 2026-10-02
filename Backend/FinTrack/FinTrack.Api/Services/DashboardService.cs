using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Dashboard;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class DashboardService
{
    private readonly FinanceDbContext _context;
    private readonly BalanceService _balanceService;
    private readonly InvestmentPortfolioService _portfolioService;
    private readonly CurrencyService _currency;

    public DashboardService(
        FinanceDbContext context,
        BalanceService balanceService,
        InvestmentPortfolioService portfolioService,
        CurrencyService currency)
    {
        _context = context;
        _balanceService = balanceService;
        _portfolioService = portfolioService;
        _currency = currency;
    }

    public async Task<DashboardResponse> GetDashboardAsync(int? month = null, int? year = null)
    {
        var today = DateOnly.FromDateTime(DateTime.Today);

        var rates = (await _currency.GetRatesAsync()).Rates;

        decimal ToEur(decimal amount, string currency)
            => _currency.ConvertToBase(amount, currency, rates);

        var periodTransactions = await GetPeriodTransactionsAsync(month, year, today);

        var income = periodTransactions
            .Where(t => t.Category.Type == CategoryType.Income)
            .Sum(t => ToEur(t.Amount, t.Currency));

        var expenses = periodTransactions
            .Where(t => t.Category.Type == CategoryType.Expense)
            .Sum(t => ToEur(t.Amount, t.Currency));

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
                Amount = g.Sum(x => ToEur(x.Amount, x.Currency)),
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
                Currency = t.Currency,
                Category = t.Category.Name,
                CategoryType = t.Category.Type,
                Account = t.Account.Name
            })
            .ToListAsync();

        var totalBalance = await _balanceService.GetTotalCashAsync();

        var investmentValue = await _portfolioService.GetCurrentTotalValueAsync();

        var creditCards = await GetCreditCardsAsync(today, rates);

        var creditDebt = creditCards.Sum(c => c.DebtInEur);

        var monthlyTrend = await GetMonthlyTrendAsync(today, month, year);

        var wealthHistory = await GetWealthHistoryAsync(today, rates);

        return new DashboardResponse
        {
            TotalBalance = totalBalance,
            InvestmentValue = investmentValue,
            CreditDebt = creditDebt,
            NetWorth = totalBalance + investmentValue - creditDebt,
            Income = income,
            Expenses = expenses,
            Savings = savings,
            SavingsRate = savingsRate,
            ExpensesByCategory = expensesByCategory,
            RecentTransactions = recentTransactions,
            MonthlyTrend = monthlyTrend,
            CreditCards = creditCards,
            WealthHistory = wealthHistory
        };
    }

    /// <summary>
    /// Month-end snapshots for the last 12 months. Total balance is reconstructed
    /// from the recorded cash transactions up to each month-end; the investment
    /// value uses held quantities priced at the known price at that date; credit
    /// card debt is applied from the card's balance date onward.
    /// </summary>
    private async Task<List<WealthHistoryPointResponse>> GetWealthHistoryAsync(
        DateOnly today,
        Dictionary<string, decimal> rates)
    {
        decimal ToEur(decimal amount, string currency)
            => _currency.ConvertToBase(amount, currency, rates);

        var accounts = await _context.Accounts
            .AsNoTracking()
            .Where(a => a.Type != AccountType.CreditCard)
            .ToListAsync();

        var transactions = await _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Category)
            .Where(t => t.AffectsBalance)
            .ToListAsync();

        var byAccount = transactions.ToLookup(t => t.AccountId);

        var cards = await _context.Accounts
            .AsNoTracking()
            .Where(a => a.Type == AccountType.CreditCard)
            .ToListAsync();

        var currentMonth = new DateOnly(today.Year, today.Month, 1);

        var startMonth = accounts.Count > 0
            ? new DateOnly(
                accounts.Min(a => a.BalanceDate).Year,
                accounts.Min(a => a.BalanceDate).Month,
                1)
            : currentMonth;

        var dates = new List<DateOnly>();

        for (var m = startMonth; m <= currentMonth; m = m.AddMonths(1))
        {
            var lastDay = m.AddMonths(1).AddDays(-1);
            dates.Add(lastDay > today ? today : lastDay);
        }

        var investmentDates = dates.Where(d => d <= today).ToList();
        var investmentValues = await _portfolioService.GetHistoricalTotalValuesAsync(investmentDates);
        var investmentValueByDate = investmentDates
            .Select((date, i) => (date, investmentValues[i]))
            .ToDictionary(x => x.date, x => x.Item2);

        var history = new List<WealthHistoryPointResponse>(dates.Count);

        foreach (var date in dates)
        {
            decimal balanceEur = 0;

            foreach (var account in accounts)
            {
                decimal income = 0;
                decimal expenses = 0;
                decimal transferOut = 0;
                decimal transferIn = 0;

                decimal ToAccountCurrency(decimal amount, string currency)
                    => _currency.ConvertTo(amount, currency, account.Currency, rates);

                foreach (var t in byAccount[account.Id])
                {
                    if (t.Date <= account.BalanceDate || t.Date > date)
                        continue;

                    var value = ToAccountCurrency(t.Amount, t.Currency);

                    switch (t.Category.Type)
                    {
                        case CategoryType.Income:
                            income += value;
                            break;
                        case CategoryType.Expense:
                            expenses += value;
                            break;
                        case CategoryType.Transfer when t.IsOutgoingTransfer:
                            transferOut += value;
                            break;
                        case CategoryType.Transfer:
                            transferIn += value;
                            break;
                    }
                }

                var balanceInAccountCurrency = account.InitialBalance + income - expenses - transferOut + transferIn;
                balanceEur += ToEur(balanceInAccountCurrency, account.Currency);
            }

            var debtEur = cards
                .Where(c => (c.OutstandingBalance ?? 0) > 0 && c.BalanceDate <= date)
                .Sum(c => ToEur(c.OutstandingBalance!.Value, c.Currency));

            var investmentValue = investmentValueByDate.TryGetValue(date, out var investmentAtDate)
                ? investmentAtDate
                : 0;

            history.Add(new WealthHistoryPointResponse
            {
                Year = date.Year,
                Month = date.Month,
                TotalBalance = decimal.Round(balanceEur, 2),
                InvestmentValue = investmentValue,
                CreditDebt = decimal.Round(debtEur, 2),
                NetWorth = decimal.Round(balanceEur + investmentValue - debtEur, 2)
            });
        }

        return history;
    }

    private async Task<List<CreditCardInfoResponse>> GetCreditCardsAsync(
        DateOnly today,
        Dictionary<string, decimal> rates)
    {
        var cards = await _context.Accounts
            .AsNoTracking()
            .Where(a => a.Type == AccountType.CreditCard)
            .ToListAsync();

        return cards.Select(card =>
        {
            var outstanding = card.OutstandingBalance ?? 0;
            var limit = card.CreditLimit ?? 0;

            var remaining = card.RemainingPayments
                ?? (card.InstallmentMonths is int total
                    ? Math.Max(0, total - BalanceService.MonthsElapsed(card.InstallmentStartDate, today))
                    : (int?)null);

            return new CreditCardInfoResponse
            {
                Id = card.Id,
                Name = card.Name,
                Currency = card.Currency,
                CreditLimit = limit,
                OutstandingBalance = outstanding,
                AvailableCredit = card.AvailableCredit ?? Math.Max(0, limit - outstanding),
                MonthlyPayment = card.MonthlyPayment,
                InstallmentMonths = card.InstallmentMonths,
                RemainingPayments = remaining,
                MonthlyInterestRate = card.MonthlyInterestRate,
                AnnualFee = card.AnnualFee,
                DebtInEur = outstanding > 0 ? _currency.ConvertToBase(outstanding, card.Currency, rates) : 0
            };
        }).ToList();
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

        var rates = (await _currency.GetRatesAsync()).Rates;

        decimal ToEur(decimal amount, string currency)
            => _currency.ConvertToBase(amount, currency, rates);

        var grouped = transactions
            .GroupBy(t => new { t.Date.Year, t.Date.Month })
            .Select(g => new MonthlyTrendResponse
            {
                Year = g.Key.Year,
                Month = g.Key.Month,
                Income = g.Where(x => x.Category.Type == CategoryType.Income).Sum(x => ToEur(x.Amount, x.Currency)),
                Expenses = g.Where(x => x.Category.Type == CategoryType.Expense).Sum(x => ToEur(x.Amount, x.Currency))
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