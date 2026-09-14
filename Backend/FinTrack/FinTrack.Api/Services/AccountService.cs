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
                CreditLimit = account.CreditLimit,
                AvailableCredit = account.AvailableCredit,
                OutstandingBalance = account.OutstandingBalance,
                TotalSpent = account.TotalSpent,
                TotalReturned = account.TotalReturned,
                MonthlyPayment = account.MonthlyPayment,
                InstallmentMonths = account.InstallmentMonths,
                RemainingPayments = account.RemainingPayments,
                InstallmentStartDate = account.InstallmentStartDate,
                MonthlyInterestRate = account.MonthlyInterestRate,
                AnnualFee = account.AnnualFee,
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
            InitialBalance = request.Type == AccountType.CreditCard ? 0 : request.InitialBalance,
            BalanceDate = request.BalanceDate ?? DateOnly.FromDateTime(DateTime.Today),
            CreditLimit = request.CreditLimit,
            AvailableCredit = request.AvailableCredit,
            OutstandingBalance = request.OutstandingBalance,
            TotalSpent = DerivedSpent(request.CreditLimit, request.AvailableCredit),
            TotalReturned = DerivedReturned(request.CreditLimit, request.AvailableCredit, request.OutstandingBalance),
            MonthlyPayment = request.MonthlyPayment,
            InstallmentMonths = request.InstallmentMonths,
            RemainingPayments = request.Type == AccountType.CreditCard ? request.InstallmentMonths : null,
            InstallmentStartDate = request.InstallmentStartDate,
            MonthlyInterestRate = request.MonthlyInterestRate,
            AnnualFee = request.AnnualFee
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
            CreditLimit = account.CreditLimit,
            AvailableCredit = account.AvailableCredit,
            OutstandingBalance = account.OutstandingBalance,
            TotalSpent = account.TotalSpent,
            TotalReturned = account.TotalReturned,
            MonthlyPayment = account.MonthlyPayment,
            InstallmentMonths = account.InstallmentMonths,
            RemainingPayments = account.RemainingPayments,
            InstallmentStartDate = account.InstallmentStartDate,
            MonthlyInterestRate = account.MonthlyInterestRate,
            AnnualFee = account.AnnualFee,
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
        account.InitialBalance = request.Type == AccountType.CreditCard ? 0 : request.InitialBalance;
        account.BalanceDate = request.BalanceDate;
        account.CreditLimit = request.CreditLimit;
        account.AvailableCredit = request.AvailableCredit;
        account.OutstandingBalance = request.OutstandingBalance;
        account.TotalSpent = DerivedSpent(request.CreditLimit, request.AvailableCredit);
        account.TotalReturned = DerivedReturned(request.CreditLimit, request.AvailableCredit, request.OutstandingBalance);
        account.MonthlyPayment = request.MonthlyPayment;
        account.InstallmentMonths = request.InstallmentMonths;
        account.InstallmentStartDate = request.InstallmentStartDate;
        account.MonthlyInterestRate = request.MonthlyInterestRate;
        account.AnnualFee = request.AnnualFee;

        await _context.SaveChangesAsync();

        return new AccountResponse
        {
            Id = account.Id,
            Name = account.Name,
            Type = account.Type,
            Currency = account.Currency,
            InitialBalance = account.InitialBalance,
            BalanceDate = account.BalanceDate,
            CreditLimit = account.CreditLimit,
            AvailableCredit = account.AvailableCredit,
            OutstandingBalance = account.OutstandingBalance,
            TotalSpent = account.TotalSpent,
            TotalReturned = account.TotalReturned,
            MonthlyPayment = account.MonthlyPayment,
            InstallmentMonths = account.InstallmentMonths,
            RemainingPayments = account.RemainingPayments,
            InstallmentStartDate = account.InstallmentStartDate,
            MonthlyInterestRate = account.MonthlyInterestRate,
            AnnualFee = account.AnnualFee,
            Balance = await _balanceService.GetAccountBalanceAsync(account.Id)
        };
    }

    private static decimal? DerivedSpent(decimal? limit, decimal? available)
        => limit is null && available is null
            ? null
            : Math.Max(0, (limit ?? 0) - (available ?? 0));

    private static decimal? DerivedReturned(decimal? limit, decimal? available, decimal? outstanding)
        => DerivedSpent(limit, available) is decimal spent
            && outstanding is not null
            ? Math.Max(0, spent - outstanding.Value)
            : null;
}
