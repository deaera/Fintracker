using FinTrack.Api.Data;
using FinTrack.Api.DTOs.CashTransactions;
using FinTrack.Api.DTOs.Transfers;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class TransferService
{
    private const string TransferCategoryName = "Transfer";

    private readonly FinanceDbContext _context;
    private readonly CashTransactionService _transactions;

    public TransferService(FinanceDbContext context, CashTransactionService transactions)
    {
        _context = context;
        _transactions = transactions;
    }

    /// <summary>
    /// Creates two linked transactions (out from account, in to account) that are
    /// neutral for income, expenses and savings so a transfer never looks like spending.
    /// </summary>
    public async Task<TransferResponse> CreateAsync(CreateTransferRequest request)
    {
        if (request.FromAccountId == request.ToAccountId)
            throw new Exception("Choose two different accounts for a transfer.");

        var fromAccount = await _context.Accounts
            .AsNoTracking()
            .FirstOrDefaultAsync(a => a.Id == request.FromAccountId);

        if (fromAccount is null)
            throw new Exception("Source account not found.");

        var toExists = await _context.Accounts.AnyAsync(a => a.Id == request.ToAccountId);

        if (!toExists)
            throw new Exception("Destination account not found.");

        var category = await _context.Categories
            .FirstOrDefaultAsync(c => c.Name == TransferCategoryName &&
                                      c.Type == CategoryType.Transfer);

        if (category is null)
        {
            category = new Category
            {
                Name = TransferCategoryName,
                Type = CategoryType.Transfer,
                Icon = "↔️",
                Color = "#64748B"
            };

            _context.Categories.Add(category);
            await _context.SaveChangesAsync();
        }

        var pairId = Guid.NewGuid();
        var date = request.Date;
        var currency = NormalizeCurrency(request.Currency) ?? fromAccount.Currency;

        var description = string.IsNullOrWhiteSpace(request.Description)
            ? "Transfer"
            : request.Description.Trim();

        var outgoing = new CashTransaction
        {
            AccountId = request.FromAccountId,
            CategoryId = category.Id,
            Date = date,
            Amount = request.Amount,
            Currency = currency,
            Description = description,
            TransferPairId = pairId,
            IsOutgoingTransfer = true
        };

        var incoming = new CashTransaction
        {
            AccountId = request.ToAccountId,
            CategoryId = category.Id,
            Date = date,
            Amount = request.Amount,
            Currency = currency,
            Description = description,
            TransferPairId = pairId,
            IsOutgoingTransfer = false
        };

        _context.CashTransactions.AddRange(outgoing, incoming);
        await _context.SaveChangesAsync();

        return new TransferResponse
        {
            PairId = pairId,
            Transactions =
            [
                await _transactions.GetByIdAsync(outgoing.Id) ?? new CashTransactionResponse(),
                await _transactions.GetByIdAsync(incoming.Id) ?? new CashTransactionResponse()
            ]
        };
    }

    private static string? NormalizeCurrency(string currency)
        => string.IsNullOrWhiteSpace(currency) ? null : currency.Trim().ToUpperInvariant();
}