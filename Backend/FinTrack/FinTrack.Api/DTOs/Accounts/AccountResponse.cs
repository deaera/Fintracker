using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Accounts;

public class AccountResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public AccountType Type { get; set; }

    public string Currency { get; set; } = "EUR";

    public decimal InitialBalance { get; set; }

    /// <summary>Date the manual balance is accurate as of.</summary>
    public DateOnly BalanceDate { get; set; }

    /// <summary>Current balance in the account's currency — initial balance adjusted by transactions after <see cref="BalanceDate"/>.</summary>
    public decimal Balance { get; set; }

    /// <summary>Maximum amount that can be borrowed (credit cards only).</summary>
    public decimal? CreditLimit { get; set; }

    /// <summary>Remaining credit available to spend (credit cards only).</summary>
    public decimal? AvailableCredit { get; set; }

    /// <summary>Remaining debt to pay back = spent − returned (credit cards only).</summary>
    public decimal? OutstandingBalance { get; set; }

    /// <summary>Cumulative amount charged = limit − available (credit cards only).</summary>
    public decimal? TotalSpent { get; set; }

    /// <summary>Cumulative amount paid back = spent − outstanding (credit cards only).</summary>
    public decimal? TotalReturned { get; set; }

    /// <summary>Fixed monthly payment for an installment plan (credit cards only).</summary>
    public decimal? MonthlyPayment { get; set; }

    /// <summary>Total number of installments (credit cards only).</summary>
    public int? InstallmentMonths { get; set; }

    /// <summary>Installments still left to pay (credit cards only).</summary>
    public int? RemainingPayments { get; set; }

    /// <summary>When the installment plan started (credit cards only).</summary>
    public DateOnly? InstallmentStartDate { get; set; }

    /// <summary>Monthly interest rate in percent (credit cards only).</summary>
    public decimal? MonthlyInterestRate { get; set; }

    /// <summary>Recurring card fees, e.g. annual fee (credit cards only).</summary>
    public decimal? AnnualFee { get; set; }
}