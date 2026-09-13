using System.ComponentModel.DataAnnotations;
using FinTrack.Api.Utils.Enums;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Entities;

public class InvestmentTransaction
{
    public Guid Id { get; set; }

    public Guid InvestmentAccountId { get; set; }

    public InvestmentAccount InvestmentAccount { get; set; } = null!;

    public Guid? AssetId { get; set; }

    public Asset? Asset { get; set; }

    public InvestmentTransactionType Type { get; set; }

    public DateOnly Date { get; set; }

    [Precision(18, 4)]
    public decimal Quantity { get; set; }

    [Precision(18, 4)]
    public decimal Price { get; set; }

    [Precision(18, 2)]
    public decimal Amount { get; set; }

    [Precision(18, 2)]
    public decimal Fee { get; set; }

    [MaxLength(300)]
    public string Note { get; set; } = string.Empty;
}