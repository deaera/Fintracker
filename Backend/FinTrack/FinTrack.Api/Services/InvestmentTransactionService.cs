using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Investments;
using FinTrack.Api.Entities;
using FinTrack.Api.Utils.Enums;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class InvestmentTransactionService
{
    private readonly FinanceDbContext _context;

    public InvestmentTransactionService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<List<InvestmentTransactionResponse>> GetAllAsync(
        Guid? accountId = null,
        Guid? assetId = null,
        InvestmentTransactionType? type = null,
        DateOnly? from = null,
        DateOnly? to = null)
    {
        var query = _context.InvestmentTransactions
            .AsNoTracking()
            .Include(t => t.InvestmentAccount)
            .Include(t => t.Asset)
            .AsQueryable();

        if (accountId.HasValue)
            query = query.Where(t => t.InvestmentAccountId == accountId.Value);

        if (assetId.HasValue)
            query = query.Where(t => t.AssetId == assetId.Value);

        if (type.HasValue)
            query = query.Where(t => t.Type == type.Value);

        if (from.HasValue)
            query = query.Where(t => t.Date >= from.Value);

        if (to.HasValue)
            query = query.Where(t => t.Date <= to.Value);

        var transactions = await query
            .OrderByDescending(t => t.Date)
            .ThenByDescending(t => t.Id)
            .ToListAsync();

        return transactions.Select(ToResponse).ToList();
    }

    public async Task<InvestmentTransactionResponse> CreateAsync(CreateInvestmentTransactionRequest request)
    {
        var (quantity, price, amount) = NormalizeFields(request.Type, request.Quantity, request.Price, request.Amount);

        var transaction = new InvestmentTransaction
        {
            InvestmentAccountId = request.InvestmentAccountId,
            AssetId = request.AssetId,
            Type = request.Type,
            Date = request.Date,
            Quantity = quantity,
            Price = price,
            Amount = amount,
            Fee = request.Fee,
            Note = request.Note?.Trim() ?? string.Empty
        };

        await ValidateAsync(transaction);

        _context.InvestmentTransactions.Add(transaction);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(transaction.Id)
            ?? throw new Exception("Unable to retrieve created transaction.");
    }

    public async Task<InvestmentTransactionResponse?> UpdateAsync(Guid id, UpdateInvestmentTransactionRequest request)
    {
        var transaction = await _context.InvestmentTransactions.FindAsync(id);

        if (transaction is null)
            return null;

        var (quantity, price, amount) = NormalizeFields(request.Type, request.Quantity, request.Price, request.Amount);

        transaction.InvestmentAccountId = request.InvestmentAccountId;
        transaction.AssetId = request.AssetId;
        transaction.Type = request.Type;
        transaction.Date = request.Date;
        transaction.Quantity = quantity;
        transaction.Price = price;
        transaction.Amount = amount;
        transaction.Fee = request.Fee;
        transaction.Note = request.Note?.Trim() ?? string.Empty;

        await ValidateAsync(transaction);

        await _context.SaveChangesAsync();

        return await GetByIdAsync(transaction.Id);
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var transaction = await _context.InvestmentTransactions.FindAsync(id);

        if (transaction is null)
            return false;

        _context.InvestmentTransactions.Remove(transaction);
        await _context.SaveChangesAsync();

        return true;
    }

    private static (decimal Quantity, decimal Price, decimal Amount) NormalizeFields(
        InvestmentTransactionType type,
        decimal? quantity,
        decimal? price,
        decimal? amount)
    {
        switch (type)
        {
            case InvestmentTransactionType.Buy:
            case InvestmentTransactionType.Sell:
                var qty = quantity ?? 0;
                var priceValue = price ?? 0;

                if (qty <= 0)
                    throw new Exception("Quantity must be greater than zero for this transaction type.");

                if (priceValue < 0)
                    throw new Exception("Price cannot be negative.");

                return (qty, priceValue, decimal.Round(qty * priceValue, 2));

            default:
                var amountValue = amount ?? 0;

                if (amountValue <= 0)
                    throw new Exception("Amount must be greater than zero for this transaction type.");

                return (0, 0, amountValue);
        }
    }

    private async Task ValidateAsync(InvestmentTransaction transaction)
    {
        var accountExists = await _context.InvestmentAccounts.AnyAsync(a => a.Id == transaction.InvestmentAccountId);

        if (!accountExists)
            throw new Exception("Investment account not found.");

        if (transaction.AssetId.HasValue)
        {
            var assetExists = await _context.Assets.AnyAsync(a => a.Id == transaction.AssetId.Value);

            if (!assetExists)
                throw new Exception("Asset not found.");
        }
        else if (transaction.Type is InvestmentTransactionType.Buy
                 or InvestmentTransactionType.Sell
                 or InvestmentTransactionType.Dividend)
        {
            throw new Exception("An asset is required for this transaction type.");
        }
    }

    private async Task<InvestmentTransactionResponse?> GetByIdAsync(Guid id)
    {
        var transaction = await _context.InvestmentTransactions
            .AsNoTracking()
            .Include(t => t.InvestmentAccount)
            .Include(t => t.Asset)
            .FirstOrDefaultAsync(t => t.Id == id);

        return transaction is null ? null : ToResponse(transaction);
    }

    private static InvestmentTransactionResponse ToResponse(InvestmentTransaction t) => new()
    {
        Id = t.Id,
        InvestmentAccountId = t.InvestmentAccountId,
        AccountName = t.InvestmentAccount.Name,
        AccountCurrency = t.InvestmentAccount.Currency,
        AssetId = t.AssetId,
        Ticker = t.Asset?.Ticker ?? string.Empty,
        AssetName = t.Asset?.Name ?? string.Empty,
        AssetCurrency = t.Asset?.Currency ?? string.Empty,
        Type = t.Type,
        Date = t.Date,
        Quantity = t.Quantity,
        Price = t.Price,
        Amount = t.Amount,
        Fee = t.Fee,
        Note = t.Note
    };
}