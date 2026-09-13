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
}