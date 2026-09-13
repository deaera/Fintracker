namespace FinTrack.Api.DTOs.Investments;

public class InvestmentAccountResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Institution { get; set; } = string.Empty;

    public string Currency { get; set; } = string.Empty;

    public decimal OpeningBalance { get; set; }

    public decimal CashBalance { get; set; }
}

public class CreateInvestmentAccountRequest
{
    public string Name { get; set; } = string.Empty;

    public string Institution { get; set; } = string.Empty;

    public string Currency { get; set; } = "EUR";

    public decimal OpeningBalance { get; set; }
}

public class UpdateInvestmentAccountRequest
{
    public string Name { get; set; } = string.Empty;

    public string Institution { get; set; } = string.Empty;

    public string Currency { get; set; } = "EUR";

    public decimal OpeningBalance { get; set; }
}