using FinTrack.Api.Data;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class BalanceService
{
    private readonly FinanceDbContext _context;
    private readonly CurrencyService _currency;

    public BalanceService(FinanceDbContext context, CurrencyService currency)
    {
        _context = context;
        _currency = currency;
    }

    /// <summary>Sum of account balances, normalized to EUR. Credit cards are excluded — their outstanding balance is debt, not cash.</summary>
    public async Task<decimal> GetTotalCashAsync()
    {
        var rates = (await _currency.GetRatesAsync()).Rates;

        var accounts = await _context.Accounts
            .AsNoTracking()
            .Select(a => new { a.Id, a.Currency, a.Type })
            .Where(a => a.Type != AccountType.CreditCard)
            .ToListAsync();

        decimal totalEur = 0;

        foreach (var account in accounts)
        {
            var balance = await GetAccountBalanceAsync(account.Id);
            totalEur += _currency.ConvertToBase(balance, account.Currency, rates);
        }

        return totalEur;
    }

    public async Task<decimal> GetTotalCreditDebtAsync()
    {
        var rates = (await _currency.GetRatesAsync()).Rates;

        var cards = await _context.Accounts
            .AsNoTracking()
            .Where(a => a.Type == AccountType.CreditCard)
            .Select(a => new { a.Currency, a.OutstandingBalance })
            .ToListAsync();

        return cards
            .Where(c => c.OutstandingBalance is > 0)
            .Sum(c => _currency.ConvertToBase(c.OutstandingBalance!.Value, c.Currency, rates));
    }

    /// <summary>Full months elapsed since a given month, clamped to >= 0.</summary>
    public static int MonthsElapsed(DateOnly? start, DateOnly today)
    {
        if (start is null || start > today)
            return 0;

        var months = (today.Year - start.Value.Year) * 12 + today.Month - start.Value.Month;
        return months < 0 ? 0 : months;
    }

    public async Task<decimal> GetAccountBalanceAsync(Guid accountId)
    {
var account = await _context.Accounts
        .AsNoTracking()
        .Where(a => a.Id == accountId)
        .Select(a => new { a.InitialBalance, a.Currency, a.BalanceDate, a.Type })
        .SingleAsync();

        // A credit card account holds debt, not cash — the outstanding balance is
        // reported separately and subtracted from net worth.
        if (account.Type == AccountType.CreditCard)
            return 0;

        var rates = (await _currency.GetRatesAsync()).Rates;

        decimal ToAccountCurrency(decimal amount, string currency)
            => _currency.ConvertTo(amount, currency, account.Currency, rates);

        var transactions = await _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Category)
            .Where(t =>
                t.AccountId == accountId &&
                t.AffectsBalance &&
                t.Date > account.BalanceDate)
            .ToListAsync();

        decimal income = 0;
        decimal expenses = 0;
        decimal transferOut = 0;
        decimal transferIn = 0;

        foreach (var t in transactions)
        {
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

        return account.InitialBalance + income - expenses - transferOut + transferIn;
    }
}