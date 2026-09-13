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

    public string Description { get; set; } = string.Empty;
}