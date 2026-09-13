using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Entities;

public class PriceHistory
{
    public Guid Id { get; set; }

    public Guid AssetId { get; set; }

    public Asset Asset { get; set; } = null!;

    public DateOnly Date { get; set; }

    [Precision(18, 4)]
    public decimal Price { get; set; }

    public bool IsManual { get; set; }
}