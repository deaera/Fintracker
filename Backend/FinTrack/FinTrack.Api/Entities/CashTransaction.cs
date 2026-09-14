using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Entities;

public class CashTransaction
{
    public Guid Id { get; set; }

    public Guid AccountId { get; set; }

    public Account Account { get; set; } = null!;

    public Guid CategoryId { get; set; }

    public Category Category { get; set; } = null!;

    public DateOnly Date { get; set; }

    [Precision(18, 2)]
    public decimal Amount { get; set; }

    /// <summary>The currency the amount is recorded in.</summary>
    [MaxLength(8)]
    public string Currency { get; set; } = "EUR";

    public string Description { get; set; } = string.Empty;

    /// <summary>Links the two legs of an account transfer; null for regular transactions.</summary>
    public Guid? TransferPairId { get; set; }

    /// <summary>True for the departing leg of a transfer (only meaningful when <see cref="TransferPairId"/> is set).</summary>
    public bool IsOutgoingTransfer { get; set; }

    /// <summary>
    /// When false, the transaction is recorded but doesn't change the account balance.
    /// Transfers always affect the balance.
    /// </summary>
    public bool AffectsBalance { get; set; } = true;

    /// <summary>
    /// For credit card payment transactions (category marked as card payment):
    /// the credit card account that receives this payment.
    /// </summary>
    public Guid? CardPaymentAccountId { get; set; }

    /// <summary>
    /// For credit card payments: true when this payment also counts as one installment
    /// of the card's installment plan, reducing the number of remaining payments.
    /// </summary>
    public bool IsInstallmentPayment { get; set; }

    /// <summary>
    /// For credit card payments: when true the card's outstanding/available/remaining
    /// are updated on save. Untick to record a past payment without touching the card's
    /// current values.
    /// </summary>
    public bool AffectsCard { get; set; } = true;
}