using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Entities;

public class InvestmentAccount
{
    public Guid Id { get; set; }

    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [MaxLength(200)]
    public string Institution { get; set; } = string.Empty;

    [MaxLength(8)]
    public string Currency { get; set; } = "EUR";

    [Precision(18, 2)]
    public decimal OpeningBalance { get; set; }
}