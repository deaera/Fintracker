using FinTrack.Api.Utils.Enums;

namespace FinTrack.Api.DTOs.Investments;

public class InvestmentTransactionResponse
{
    public Guid Id { get; set; }

    public Guid InvestmentAccountId { get; set; }

    public string AccountName { get; set; } = string.Empty;

    public string AccountCurrency { get; set; } = string.Empty;

    public Guid? AssetId { get; set; }

    public string Ticker { get; set; } = string.Empty;

    public string AssetName { get; set; } = string.Empty;

    public string AssetCurrency { get; set; } = string.Empty;

    public InvestmentTransactionType Type { get; set; }

    public DateOnly Date { get; set; }

    public decimal Quantity { get; set; }

    public decimal Price { get; set; }

    public decimal Amount { get; set; }

    public decimal Fee { get; set; }

    public string Note { get; set; } = string.Empty;
}

public class CreateInvestmentTransactionRequest
{
    public Guid InvestmentAccountId { get; set; }

    public Guid? AssetId { get; set; }

    public InvestmentTransactionType Type { get; set; }

    public DateOnly Date { get; set; }

    public decimal? Quantity { get; set; }

    public decimal? Price { get; set; }

    public decimal? Amount { get; set; }

    public decimal Fee { get; set; }

    public string Note { get; set; } = string.Empty;
}

public class UpdateInvestmentTransactionRequest
{
    public Guid InvestmentAccountId { get; set; }

    public Guid? AssetId { get; set; }

    public InvestmentTransactionType Type { get; set; }

    public DateOnly Date { get; set; }

    public decimal? Quantity { get; set; }

    public decimal? Price { get; set; }

    public decimal? Amount { get; set; }

    public decimal Fee { get; set; }

    public string Note { get; set; } = string.Empty;
}