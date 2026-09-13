using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using FinTrack.Api.Utils.Enums;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Entities;

public class Asset
{
    public Guid Id { get; set; }

    [MaxLength(12)]
    public string Ticker { get; set; } = string.Empty;

    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    public AssetType Type { get; set; }

    [MaxLength(8)]
    public string Currency { get; set; } = "EUR";

    [Precision(18, 4)]
    [Column(TypeName = "decimal(18,4)")]
    public decimal? ManualPrice { get; set; }

    [MaxLength(20)]
    public string? StooqSymbol { get; set; }
}