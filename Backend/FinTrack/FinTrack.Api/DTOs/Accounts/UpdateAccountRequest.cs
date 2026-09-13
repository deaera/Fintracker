using System.ComponentModel.DataAnnotations;
using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Accounts;

public class UpdateAccountRequest
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    public AccountType Type { get; set; }

    public string Currency { get; set; } = "EUR";

    public decimal InitialBalance { get; set; }

    /// <summary>Date the manual balance is accurate as of. Transactions before it stay recorded but don't affect the balance.</summary>
    public DateOnly BalanceDate { get; set; }
}