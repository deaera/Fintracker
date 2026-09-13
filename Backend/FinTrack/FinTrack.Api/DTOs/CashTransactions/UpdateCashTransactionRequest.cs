using System.ComponentModel.DataAnnotations;

namespace FinTrack.Api.DTOs.CashTransactions;

public class UpdateCashTransactionRequest
{
    public DateOnly Date { get; set; }

    [Range(0.01, double.MaxValue)]
    public decimal Amount { get; set; }

    [MaxLength(300)]
    public string Description { get; set; } = string.Empty;

    public Guid AccountId { get; set; }

    public Guid CategoryId { get; set; }
}