using System.ComponentModel.DataAnnotations;

namespace FinTrack.Api.DTOs.CashTransactions;

public class CreateCashTransactionRequest
{
    public DateOnly Date { get; set; }

    [Range(0.01, double.MaxValue)]
    public decimal Amount { get; set; }

    /// <summary>Currency of the amount. When empty, the selected account's currency is used.</summary>
    [MaxLength(8)]
    public string Currency { get; set; } = string.Empty;

    [MaxLength(300)]
    public string Description { get; set; } = string.Empty;

    public Guid AccountId { get; set; }

    public Guid CategoryId { get; set; }

    /// <summary>When false, the transaction is recorded but doesn't change the account balance.</summary>
    public bool AffectsBalance { get; set; } = true;
}