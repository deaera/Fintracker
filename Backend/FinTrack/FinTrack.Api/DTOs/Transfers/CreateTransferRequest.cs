using System.ComponentModel.DataAnnotations;

namespace FinTrack.Api.DTOs.Transfers;

public class CreateTransferRequest
{
    public DateOnly Date { get; set; }

    [Range(0.01, double.MaxValue)]
    public decimal Amount { get; set; }

    [MaxLength(300)]
    public string Description { get; set; } = string.Empty;

    public Guid FromAccountId { get; set; }

    public Guid ToAccountId { get; set; }
}