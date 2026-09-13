using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Entities;

public class Account
{
    public Guid Id { get; set; }

    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    public AccountType Type { get; set; }

    [Precision(18, 2)]
    public decimal InitialBalance { get; set; }
    
    public string Currency { get; set; } = "EUR";

    public ICollection<CashTransaction> CashTransactions { get; set; }
        = [];
}