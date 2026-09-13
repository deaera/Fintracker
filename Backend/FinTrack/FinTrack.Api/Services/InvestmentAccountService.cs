using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Investments;
using FinTrack.Api.Entities;
using FinTrack.Api.Utils.Enums;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class InvestmentAccountService
{
    private readonly FinanceDbContext _context;

    public InvestmentAccountService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<List<InvestmentAccountResponse>> GetAllAsync()
    {
        var accounts = await _context.InvestmentAccounts
            .AsNoTracking()
            .OrderBy(a => a.Name)
            .ToListAsync();

        var transactions = await _context.InvestmentTransactions
            .AsNoTracking()
            .Select(t => new { t.InvestmentAccountId, t.Type, t.Amount, t.Fee })
            .ToListAsync();

        var cashEffects = transactions
            .GroupBy(t => t.InvestmentAccountId)
            .ToDictionary(
                g => g.Key,
                g => g.Sum(t => CashEffect(t.Type, t.Amount, t.Fee)));

        return accounts
            .Select(a => new InvestmentAccountResponse
            {
                Id = a.Id,
                Name = a.Name,
                Institution = a.Institution,
                Currency = a.Currency,
                OpeningBalance = a.OpeningBalance,
                CashBalance = a.OpeningBalance + (cashEffects.TryGetValue(a.Id, out var delta) ? delta : 0)
            })
            .ToList();
    }

    public async Task<InvestmentAccountResponse> CreateAsync(CreateInvestmentAccountRequest request)
    {
        var account = new InvestmentAccount
        {
            Name = string.IsNullOrWhiteSpace(request.Name) ? "Investment account" : request.Name.Trim(),
            Institution = request.Institution?.Trim() ?? string.Empty,
            Currency = NormalizeCurrency(request.Currency),
            OpeningBalance = request.OpeningBalance
        };

        _context.InvestmentAccounts.Add(account);
        await _context.SaveChangesAsync();

        return new InvestmentAccountResponse
        {
            Id = account.Id,
            Name = account.Name,
            Institution = account.Institution,
            Currency = account.Currency,
            OpeningBalance = account.OpeningBalance,
            CashBalance = account.OpeningBalance
        };
    }

    public async Task<InvestmentAccountResponse?> UpdateAsync(Guid id, UpdateInvestmentAccountRequest request)
    {
        var account = await _context.InvestmentAccounts.FindAsync(id);

        if (account is null)
            return null;

        account.Name = string.IsNullOrWhiteSpace(request.Name) ? account.Name : request.Name.Trim();
        account.Institution = request.Institution?.Trim() ?? string.Empty;
        account.Currency = NormalizeCurrency(request.Currency);
        account.OpeningBalance = request.OpeningBalance;

        await _context.SaveChangesAsync();

        var all = await GetAllAsync();
        return all.FirstOrDefault(a => a.Id == id);
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var account = await _context.InvestmentAccounts.FindAsync(id);

        if (account is null)
            return false;

        var hasTransactions = await _context.InvestmentTransactions.AnyAsync(t => t.InvestmentAccountId == id);

        if (hasTransactions)
            throw new Exception("Delete its transactions first.");

        _context.InvestmentAccounts.Remove(account);
        await _context.SaveChangesAsync();

        return true;
    }

    private static decimal CashEffect(InvestmentTransactionType type, decimal amount, decimal fee) => type switch
    {
        InvestmentTransactionType.Buy => -(amount + fee),
        InvestmentTransactionType.Sell => amount - fee,
        InvestmentTransactionType.Dividend => amount,
        InvestmentTransactionType.Interest => amount,
        InvestmentTransactionType.Fee => -amount,
        InvestmentTransactionType.TransferIn => amount,
        InvestmentTransactionType.TransferOut => -amount,
        _ => 0
    };

    private static string NormalizeCurrency(string currency)
        => string.IsNullOrWhiteSpace(currency) ? "EUR" : currency.Trim().ToUpperInvariant();
}