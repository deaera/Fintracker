using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Accounts;

public class AccountResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public AccountType Type { get; set; }

    public string Currency { get; set; } = "EUR";

    public decimal InitialBalance { get; set; }

    /// <summary>Date the manual balance is accurate as of.</summary>
    public DateOnly BalanceDate { get; set; }

    /// <summary>Current balance in the account's currency — initial balance adjusted by transactions after <see cref="BalanceDate"/>.</summary>
    public decimal Balance { get; set; }
}