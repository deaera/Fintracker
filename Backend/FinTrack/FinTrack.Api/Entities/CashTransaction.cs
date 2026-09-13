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
}