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
                Description = t.Description,

                AccountId = t.AccountId,
                AccountName = t.Account.Name,

                CategoryId = t.CategoryId,
                CategoryName = t.Category.Name,
                CategoryType = t.Category.Type
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
                Description = t.Description,

                AccountId = t.AccountId,
                AccountName = t.Account.Name,

                CategoryId = t.CategoryId,
                CategoryName = t.Category.Name,
                CategoryType = t.Category.Type
            })
            .FirstOrDefaultAsync();
    }

    public async Task<CashTransactionResponse> CreateAsync(CreateCashTransactionRequest request)
    {
        var accountExists = await _context.Accounts.AnyAsync(a => a.Id == request.AccountId);

        if (!accountExists)
            throw new Exception("Account not found.");

        var category = await _context.Categories
            .FirstOrDefaultAsync(c => c.Id == request.CategoryId);

        if (category is null)
            throw new Exception("Category not found.");

        var transaction = new CashTransaction
        {
            Date = request.Date,
            Amount = request.Amount,
            Description = request.Description,
            AccountId = request.AccountId,
            CategoryId = request.CategoryId
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
        transaction.Description = request.Description;
        transaction.AccountId = request.AccountId;
        transaction.CategoryId = request.CategoryId;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(transaction.Id);
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var transaction = await _context.CashTransactions.FindAsync(id);

        if (transaction is null)
            return false;

        _context.CashTransactions.Remove(transaction);

        await _context.SaveChangesAsync();

        return true;
    }
}