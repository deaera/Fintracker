using FinTrack.Api.Data;
using FinTrack.Api.DTOs.CashTransactions;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class CashTransactionService
{
    private readonly FinanceDbContext _context;
    private readonly CurrencyService _currency;

    public CashTransactionService(FinanceDbContext context, CurrencyService currency)
    {
        _context = context;
        _currency = currency;
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
                AffectsBalance = t.AffectsBalance,
                CardPaymentAccountId = t.CardPaymentAccountId,
                IsInstallmentPayment = t.IsInstallmentPayment,
                AffectsCard = t.AffectsCard
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
                AffectsBalance = t.AffectsBalance,
                CardPaymentAccountId = t.CardPaymentAccountId,
                IsInstallmentPayment = t.IsInstallmentPayment,
                AffectsCard = t.AffectsCard
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
            AffectsBalance = request.AffectsBalance,
            CardPaymentAccountId = request.CardPaymentAccountId,
            IsInstallmentPayment = request.IsInstallmentPayment,
            AffectsCard = request.AffectsCard
        };

        _context.CashTransactions.Add(transaction);

        if (category.IsCardPayment && transaction.CardPaymentAccountId is Guid cardId)
        {
            if (cardId == transaction.AccountId)
                throw new Exception("The payment account and the credit card must be different.");

            if (transaction.AffectsCard)
            {
                var card = await GetCreditCardAsync(cardId);
                await ApplyCardEffects(card, transaction);
                if (transaction.IsInstallmentPayment)
                    ShiftRemainingPayments(card, -1);
            }
        }

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

        var newCategory = await _context.Categories.FindAsync(request.CategoryId);

        if (newCategory is null)
            throw new Exception("Category not found.");

        var oldCategory = await _context.Categories.FindAsync(transaction.CategoryId);

        var oldCardId = transaction.CardPaymentAccountId;
        var oldIsInstallment = transaction.IsInstallmentPayment;
        var oldAffectsCard = transaction.AffectsCard;
        var oldAmount = transaction.Amount;
        var oldCurrency = transaction.Currency;
        var isTransfer = transaction.TransferPairId != null;

        if (!isTransfer && oldCardId is Guid oldCard &&
            oldCategory?.IsCardPayment == true && oldAffectsCard)
        {
            var card = await GetCreditCardAsync(oldCard);
            ReverseCardEffects(card, oldAmount, oldCurrency);
            if (oldIsInstallment)
                ShiftRemainingPayments(card, 1);
        }

        transaction.Date = request.Date;
        transaction.Amount = request.Amount;
        transaction.Currency = NormalizeCurrency(request.Currency) ?? transaction.Currency;
        transaction.Description = request.Description;
        transaction.AffectsBalance = request.AffectsBalance;

        if (isTransfer)
        {
            var pair = await _context.CashTransactions
                .Where(t => t.TransferPairId == transaction.TransferPairId && t.Id != transaction.Id)
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
            transaction.CardPaymentAccountId = request.CardPaymentAccountId;
            transaction.IsInstallmentPayment = request.IsInstallmentPayment;
            transaction.AffectsCard = request.AffectsCard;

            if (newCategory.IsCardPayment && request.CardPaymentAccountId is Guid newCard)
            {
                if (newCard == transaction.AccountId)
                    throw new Exception("The payment account and the credit card must be different.");

                if (transaction.AffectsCard)
                {
                    var card = await GetCreditCardAsync(newCard);
                    await ApplyCardEffects(card, transaction);
                    if (transaction.IsInstallmentPayment)
                        ShiftRemainingPayments(card, -1);
                }
            }
        }

        await _context.SaveChangesAsync();

        return await GetByIdAsync(transaction.Id);
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var transaction = await _context.CashTransactions.FindAsync(id);

        if (transaction is null)
            return false;

        if (transaction.TransferPairId is null &&
            transaction.AffectsCard &&
            transaction.CardPaymentAccountId is Guid cardId)
        {
            var category = await _context.Categories.FindAsync(transaction.CategoryId);

            if (category?.IsCardPayment == true)
            {
                var card = await GetCreditCardAsync(cardId);
                await ReverseCardEffects(card, transaction.Amount, transaction.Currency);
                if (transaction.IsInstallmentPayment)
                    ShiftRemainingPayments(card, 1);
            }
        }

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

    /// <summary>
    /// A credit card payment reduces the card's outstanding debt: the still-payable
    /// amount drops, available credit rises and the paid-back total grows.
    /// </summary>
    private async Task ApplyCardEffects(Account card, CashTransaction transaction)
    {
        var rates = (await _currency.GetRatesAsync()).Rates;
        var amountInCardCurrency = _currency.ConvertTo(
            transaction.Amount, transaction.Currency, card.Currency, rates);

        var outstanding = Math.Max(0, (card.OutstandingBalance ?? 0) - amountInCardCurrency);
        card.OutstandingBalance = outstanding;
        card.AvailableCredit = Math.Max(0, (card.CreditLimit ?? 0) - outstanding);

        if (card.TotalSpent is decimal spent)
            card.TotalReturned = Math.Max(0, spent - outstanding);
    }

    /// <summary>Reverse of <see cref="ApplyCardEffects"/>: put the debt back on the card.</summary>
    private async Task ReverseCardEffects(Account card, decimal amount, string currency)
    {
        var rates = (await _currency.GetRatesAsync()).Rates;
        var amountInCardCurrency = _currency.ConvertTo(amount, currency, card.Currency, rates);

        var outstanding = (card.OutstandingBalance ?? 0) + amountInCardCurrency;
        card.OutstandingBalance = outstanding;
        card.AvailableCredit = Math.Max(0, (card.CreditLimit ?? 0) - outstanding);

        if (card.TotalSpent is decimal spent)
            card.TotalReturned = Math.Max(0, spent - outstanding);
    }

    private void ShiftRemainingPayments(Account card, int delta)
    {
        if (card.RemainingPayments is int remaining)
            card.RemainingPayments = Math.Max(0, remaining + delta);
    }

    private async Task<Account> GetCreditCardAsync(Guid id)
    {
        var card = await _context.Accounts.FirstOrDefaultAsync(a => a.Id == id);

        if (card is null)
            throw new Exception("Credit card account not found.");

        if (card.Type != AccountType.CreditCard)
            throw new Exception("The selected account is not a credit card.");

        return card;
    }

    private static string? NormalizeCurrency(string currency)
        => string.IsNullOrWhiteSpace(currency) ? null : currency.Trim().ToUpperInvariant();
}