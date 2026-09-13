using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Accounts;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class AccountService
{
    private readonly FinanceDbContext _context;

    public AccountService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<List<AccountResponse>> GetAllAsync()
    {
        return await _context.Accounts
            .Select(a => new AccountResponse
            {
                Id = a.Id,
                Name = a.Name,
                Type = a.Type,
                Currency = a.Currency,
                InitialBalance = a.InitialBalance
            })
            .ToListAsync();
    }

    public async Task<AccountResponse> CreateAsync(CreateAccountRequest request)
    {
        var account = new Account
        {
            Name = request.Name,
            Type = request.Type,
            Currency = request.Currency,
            InitialBalance = request.InitialBalance
        };

        _context.Accounts.Add(account);

        await _context.SaveChangesAsync();

        return new AccountResponse
        {
            Id = account.Id,
            Name = account.Name,
            Type = account.Type,
            Currency = account.Currency,
            InitialBalance = account.InitialBalance
        };
    }
}