using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Entities;

public class Account
{
    public Guid Id { get; set; }

    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    public AccountType Type { get; set; }

    [Precision(18, 2)]
    public decimal InitialBalance { get; set; }

    /// <summary>
    /// Manual balance is accurate as of this date. Only transactions strictly after this
    /// date update the balance; earlier ones are recorded but don't change it.
    /// </summary>
    public DateOnly BalanceDate { get; set; }

    public string Currency { get; set; } = "EUR";

    /// <summary>Maximum amount that can be borrowed on a credit card.</summary>
    [Precision(18, 2)]
    public decimal? CreditLimit { get; set; }

    /// <summary>Remaining credit available to spend (input). Derives TotalSpent.</summary>
    [Precision(18, 2)]
    public decimal? AvailableCredit { get; set; }

    /// <summary>Remaining debt to pay back (input). Derives TotalReturned.</summary>
    [Precision(18, 2)]
    public decimal? OutstandingBalance { get; set; }

    /// <summary>Cumulative amount charged to the card (derived = limit − available).</summary>
    [Precision(18, 2)]
    public decimal? TotalSpent { get; set; }

    /// <summary>Cumulative amount paid back (derived = spent − outstanding).</summary>
    [Precision(18, 2)]
    public decimal? TotalReturned { get; set; }

    /// <summary>Fixed amount paid each month for an installment plan.</summary>
    [Precision(18, 2)]
    public decimal? MonthlyPayment { get; set; }

    /// <summary>Total number of installments in the plan.</summary>
    public int? InstallmentMonths { get; set; }

    /// <summary>Installments still left to pay; decremented by installment payments (credit cards only).</summary>
    public int? RemainingPayments { get; set; }

    /// <summary>When the installment plan started (first month of the plan).</summary>
    public DateOnly? InstallmentStartDate { get; set; }

    /// <summary>Monthly interest rate in percent (0 for 0% financing).</summary>
    [Precision(8, 4)]
    public decimal? MonthlyInterestRate { get; set; }

    /// <summary>Recurring card fees (e.g. annual fee), in the account currency.</summary>
    [Precision(18, 2)]
    public decimal? AnnualFee { get; set; }

    public ICollection<CashTransaction> CashTransactions { get; set; }
        = [];
}