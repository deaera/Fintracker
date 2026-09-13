using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Accounts;

public class AccountResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public AccountType Type { get; set; }

    public string Currency { get; set; } = "EUR";

    public decimal InitialBalance { get; set; }
}