using System.ComponentModel.DataAnnotations;
using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Accounts;

public class CreateAccountRequest
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    public AccountType Type { get; set; }

    public string Currency { get; set; } = "EUR";

    public decimal InitialBalance { get; set; }
}