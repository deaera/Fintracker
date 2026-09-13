using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Accounts;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class AccountService
{
    private readonly FinanceDbContext _context;
    private readonly BalanceService _balanceService;

    public AccountService(FinanceDbContext context, BalanceService balanceService)
    {
        _context = context;
        _balanceService = balanceService;
    }

    public async Task<List<AccountResponse>> GetAllAsync()
    {
        var accounts = await _context.Accounts.AsNoTracking().ToListAsync();

        var response = new List<AccountResponse>(accounts.Count);

        foreach (var account in accounts)
        {
            response.Add(new AccountResponse
            {
                Id = account.Id,
                Name = account.Name,
                Type = account.Type,
                Currency = account.Currency,
                InitialBalance = account.InitialBalance,
                BalanceDate = account.BalanceDate,
                Balance = await _balanceService.GetAccountBalanceAsync(account.Id)
            });
        }

        return response;
    }

    public async Task<AccountResponse> CreateAsync(CreateAccountRequest request)
    {
        var account = new Account
        {
            Name = request.Name,
            Type = request.Type,
            Currency = request.Currency,
            InitialBalance = request.InitialBalance,
            BalanceDate = request.BalanceDate ?? DateOnly.FromDateTime(DateTime.Today)
        };

        _context.Accounts.Add(account);

        await _context.SaveChangesAsync();

        return new AccountResponse
        {
            Id = account.Id,
            Name = account.Name,
            Type = account.Type,
            Currency = account.Currency,
            InitialBalance = account.InitialBalance,
            BalanceDate = account.BalanceDate,
            Balance = account.InitialBalance
        };
    }

    public async Task<AccountResponse?> UpdateAsync(Guid id, UpdateAccountRequest request)
    {
        var account = await _context.Accounts.FindAsync(id);

        if (account is null)
            return null;

        account.Name = request.Name;
        account.Type = request.Type;
        account.Currency = request.Currency;
        account.InitialBalance = request.InitialBalance;
        account.BalanceDate = request.BalanceDate;

        await _context.SaveChangesAsync();

        return new AccountResponse
        {
            Id = account.Id,
            Name = account.Name,
            Type = account.Type,
            Currency = account.Currency,
            InitialBalance = account.InitialBalance,
            BalanceDate = account.BalanceDate,
            Balance = await _balanceService.GetAccountBalanceAsync(account.Id)
        };
    }
}