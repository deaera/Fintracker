using FinTrack.Api.Data;
using FinTrack.Api.DTOs.CashTransactions;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class CashTransactionService
{
    private readonly FinanceDbContext _context;

    public CashTransactionService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<List<CashTransactionResponse>> GetAllAsync(int? month = null, int? year = null)
    {
        var query = _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Account)
            .Include(t => t.Category)
            .AsQueryable();

        if (year.HasValue)
        {
            query = query.Where(t => t.Date.Year == year.Value);
        }

        if (month.HasValue)
        {
            query = query.Where(t => t.Date.Month == month.Value);
        }

        return await query
            .OrderByDescending(t => t.Date)
            .Select(t => new CashTransactionResponse
            {
                Id = t.Id,
                Date = t.Date,
                Amount = t.Amount,
                Currency = t.Currency,
                Description = t.Description,

                AccountId = t.AccountId,
                AccountName = t.Account.Name,

                CategoryId = t.CategoryId,
                CategoryName = t.Category.Name,
                CategoryType = t.Category.Type,
                IsTransfer = t.TransferPairId != null,
                IsOutgoingTransfer = t.IsOutgoingTransfer,
                AffectsBalance = t.AffectsBalance
            })
            .ToListAsync();
    }

    public async Task<CashTransactionResponse?> GetByIdAsync(Guid id)
    {
        return await _context.CashTransactions
            .AsNoTracking()
            .Include(t => t.Account)
            .Include(t => t.Category)
            .Where(t => t.Id == id)
            .Select(t => new CashTransactionResponse
            {
                Id = t.Id,
                Date = t.Date,
                Amount = t.Amount,
                Currency = t.Currency,
                Description = t.Description,

                AccountId = t.AccountId,
                AccountName = t.Account.Name,

                CategoryId = t.CategoryId,
                CategoryName = t.Category.Name,
                CategoryType = t.Category.Type,
                IsTransfer = t.TransferPairId != null,
                IsOutgoingTransfer = t.IsOutgoingTransfer,
                AffectsBalance = t.AffectsBalance
            })
            .FirstOrDefaultAsync();
    }

    public async Task<CashTransactionResponse> CreateAsync(CreateCashTransactionRequest request)
    {
        var account = await _context.Accounts
            .AsNoTracking()
            .FirstOrDefaultAsync(a => a.Id == request.AccountId);

        if (account is null)
            throw new Exception("Account not found.");

        var category = await _context.Categories
            .FirstOrDefaultAsync(c => c.Id == request.CategoryId);

        if (category is null)
            throw new Exception("Category not found.");

        var transaction = new CashTransaction
        {
            Date = request.Date,
            Amount = request.Amount,
            Currency = NormalizeCurrency(request.Currency) ?? account.Currency,
            Description = request.Description,
            AccountId = request.AccountId,
            CategoryId = request.CategoryId,
            AffectsBalance = request.AffectsBalance
        };

        _context.CashTransactions.Add(transaction);

        await _context.SaveChangesAsync();

        return await GetByIdAsync(transaction.Id)
            ?? throw new Exception("Unable to retrieve created transaction.");
    }

    public async Task<CashTransactionResponse?> UpdateAsync(
        Guid id,
        UpdateCashTransactionRequest request)
    {
        var transaction = await _context.CashTransactions.FindAsync(id);

        if (transaction is null)
            return null;

        var accountExists = await _context.Accounts.AnyAsync(a => a.Id == request.AccountId);

        if (!accountExists)
            throw new Exception("Account not found.");

        var categoryExists = await _context.Categories.AnyAsync(c => c.Id == request.CategoryId);

        if (!categoryExists)
            throw new Exception("Category not found.");

        transaction.Date = request.Date;
        transaction.Amount = request.Amount;
        transaction.Currency = NormalizeCurrency(request.Currency) ?? transaction.Currency;
        transaction.Description = request.Description;
        transaction.AffectsBalance = request.AffectsBalance;

        if (transaction.TransferPairId is Guid pairId)
        {
            var pair = await _context.CashTransactions
                .Where(t => t.TransferPairId == pairId && t.Id != transaction.Id)
                .ToListAsync();

            foreach (var leg in pair)
            {
                leg.Date = request.Date;
                leg.Amount = request.Amount;
                leg.Description = request.Description;
                leg.Currency = transaction.Currency;
            }
        }
        else
        {
            transaction.AccountId = request.AccountId;
            transaction.CategoryId = request.CategoryId;
        }

        await _context.SaveChangesAsync();

        return await GetByIdAsync(transaction.Id);
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var transaction = await _context.CashTransactions.FindAsync(id);

        if (transaction is null)
            return false;

        if (transaction.TransferPairId is Guid pairId)
        {
            var legs = await _context.CashTransactions
                .Where(t => t.TransferPairId == pairId)
                .ToListAsync();

            _context.CashTransactions.RemoveRange(legs);
        }
        else
        {
            _context.CashTransactions.Remove(transaction);
        }

        await _context.SaveChangesAsync();

        return true;
    }

    private static string? NormalizeCurrency(string currency)
        => string.IsNullOrWhiteSpace(currency) ? null : currency.Trim().ToUpperInvariant();
}