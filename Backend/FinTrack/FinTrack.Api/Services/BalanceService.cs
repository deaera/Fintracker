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
    var initialBalance = await _context.Accounts
        .Where(a => a.Id == accountId)
        .Select(a => a.InitialBalance)
        .SingleAsync();

    var income = await _context.CashTransactions
        .Where(t => t.AccountId == accountId &&
                    t.Category.Type == CategoryType.Income)
        .SumAsync(t => (decimal?)t.Amount) ?? 0;

    var expenses = await _context.CashTransactions
        .Where(t => t.AccountId == accountId &&
                    t.Category.Type == CategoryType.Expense)
        .SumAsync(t => (decimal?)t.Amount) ?? 0;

    var transferOut = await _context.CashTransactions
        .Where(t => t.AccountId == accountId && t.IsOutgoingTransfer)
        .SumAsync(t => (decimal?)t.Amount) ?? 0;

    var transferIn = await _context.CashTransactions
        .Where(t => t.AccountId == accountId &&
                    t.TransferPairId != null &&
                    !t.IsOutgoingTransfer)
        .SumAsync(t => (decimal?)t.Amount) ?? 0;

    return initialBalance + income - expenses - transferOut + transferIn;
}
}