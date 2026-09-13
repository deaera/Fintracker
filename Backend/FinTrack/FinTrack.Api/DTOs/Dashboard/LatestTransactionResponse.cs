using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Dashboard;

public class LatestTransactionResponse
{
    public Guid Id { get; set; }

    public DateOnly Date { get; set; }

    public string Description { get; set; } = string.Empty;

    public decimal Amount { get; set; }

    public string Category { get; set; } = string.Empty;

    public CategoryType CategoryType { get; set; }

    public string Account { get; set; } = string.Empty;
}