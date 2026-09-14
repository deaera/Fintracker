using System.ComponentModel.DataAnnotations;

namespace FinTrack.Api.DTOs.CashTransactions;

public class UpdateCashTransactionRequest
{
    public DateOnly Date { get; set; }

    [Range(0.01, double.MaxValue)]
    public decimal Amount { get; set; }

    /// <summary>Currency of the amount. When empty, the previous currency is kept.</summary>
    [MaxLength(8)]
    public string Currency { get; set; } = string.Empty;

    [MaxLength(300)]
    public string Description { get; set; } = string.Empty;

    public Guid AccountId { get; set; }

    public Guid CategoryId { get; set; }

    /// <summary>When false, the transaction is recorded but doesn't change the account balance.</summary>
    public bool AffectsBalance { get; set; } = true;

    /// <summary>For the credit card payment category: the credit card account receiving this payment.</summary>
    public Guid? CardPaymentAccountId { get; set; }

    /// <summary>When true, this card payment also counts as one installment of the card's plan.</summary>
    public bool IsInstallmentPayment { get; set; }

    /// <summary>
    /// For card payments: when true the card's outstanding/available/remaining are updated.
    /// Defaults to true; untick to record a past payment without changing the card's values.
    /// </summary>
    public bool AffectsCard { get; set; } = true;
}