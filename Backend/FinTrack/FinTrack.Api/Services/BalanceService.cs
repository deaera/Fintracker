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

    /// <summary>Sum of all account balances, normalized to EUR.</summary>
    public async Task<decimal> GetTotalCashAsync()
    {
        var rates = (await _currency.GetRatesAsync()).Rates;

        var accounts = await _context.Accounts
            .AsNoTracking()
            .Select(a => new { a.Id, a.Currency })
            .ToListAsync();

        decimal totalEur = 0;

        foreach (var account in accounts)
        {
            var balance = await GetAccountBalanceAsync(account.Id);
            totalEur += _currency.ConvertToBase(balance, account.Currency, rates);
        }

        return totalEur;
    }

    public async Task<decimal> GetAccountBalanceAsync(Guid accountId)
    {
var account = await _context.Accounts
        .AsNoTracking()
        .Where(a => a.Id == accountId)
        .Select(a => new { a.InitialBalance, a.Currency, a.BalanceDate })
        .SingleAsync();

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