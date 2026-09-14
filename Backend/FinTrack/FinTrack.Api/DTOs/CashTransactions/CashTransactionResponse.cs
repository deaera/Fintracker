using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.CashTransactions;

public class CashTransactionResponse
{
    public Guid Id { get; set; }

    public DateOnly Date { get; set; }

    public decimal Amount { get; set; }

    public string Currency { get; set; } = "EUR";

    public string Description { get; set; } = string.Empty;

    public Guid AccountId { get; set; }

    public string AccountName { get; set; } = string.Empty;

    public Guid CategoryId { get; set; }

    public string CategoryName { get; set; } = string.Empty;

    public CategoryType CategoryType { get; set; }

    public bool IsTransfer { get; set; }

    public bool IsOutgoingTransfer { get; set; }

    public bool AffectsBalance { get; set; }
}