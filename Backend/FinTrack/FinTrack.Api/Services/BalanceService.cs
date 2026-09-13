using FinTrack.Api.Data;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class BalanceService
{
    private readonly FinanceDbContext _context;

    public BalanceService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<decimal> GetTotalCashAsync()
    {
        var accounts = await _context.Accounts
            .AsNoTracking()
            .ToListAsync();

        decimal total = 0;

        foreach (var account in accounts)
        {
            total += await GetAccountBalanceAsync(account.Id);
        }

        return total;
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

    return initialBalance + income - expenses;
}
}