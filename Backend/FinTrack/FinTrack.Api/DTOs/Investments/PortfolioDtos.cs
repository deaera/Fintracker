namespace FinTrack.Api.DTOs.Investments;

public class HoldingResponse
{
    public Guid AssetId { get; set; }

    public string Ticker { get; set; } = string.Empty;

    public string Name { get; set; } = string.Empty;

    public string AssetType { get; set; } = string.Empty;

    public string Currency { get; set; } = string.Empty;

    public Guid AccountId { get; set; }

    public string AccountName { get; set; } = string.Empty;

    public decimal Quantity { get; set; }

    public decimal AvgCost { get; set; }

    public decimal Cost { get; set; }

    public decimal CurrentPrice { get; set; }

    public string PriceSource { get; set; } = "manual";

    public decimal CurrentValueInCurrency { get; set; }

    public decimal CurrentValue { get; set; }

    public decimal Gain { get; set; }

    public decimal GainPct { get; set; }
}

public class OverviewResponse
{
    public decimal TotalValue { get; set; }

    public decimal TotalInvested { get; set; }

    public decimal ProfitLoss { get; set; }

    public decimal ReturnPct { get; set; }

    public decimal RealizedGain { get; set; }

    public decimal UnrealizedGain { get; set; }

    public decimal CashBalance { get; set; }

    public int HoldingsCount { get; set; }

    public int AccountCount { get; set; }
}

public class PerformanceResponse
{
    public string Range { get; set; } = string.Empty;

    public List<string> Dates { get; set; } = [];

    public List<decimal> Values { get; set; } = [];
}

public class AllocationEntry
{
    public string Label { get; set; } = string.Empty;

    public decimal Value { get; set; }

    public string Color { get; set; } = "#78909C";
}

public class ContributionEntry
{
    public int Year { get; set; }

    public int Month { get; set; }

    public decimal Contributed { get; set; }

    public decimal Cumulative { get; set; }
}

public class DividendRow
{
    public Guid Id { get; set; }

    public DateOnly Date { get; set; }

    public string Ticker { get; set; } = string.Empty;

    public string AssetName { get; set; } = string.Empty;

    public string AccountName { get; set; } = string.Empty;

    public decimal Amount { get; set; }

    public string Currency { get; set; } = string.Empty;
}

public class DividendMonthSummary
{
    public int Month { get; set; }

    public decimal Total { get; set; }
}

public class DividendResponse
{
    public int Year { get; set; }

    public decimal YearlyTotal { get; set; }

    public List<DividendRow> Payments { get; set; } = [];

    public List<DividendMonthSummary> Monthly { get; set; } = [];

    public List<DividendRow> Upcoming { get; set; } = [];
}

public class BenchmarkResponse
{
    public string Symbol { get; set; } = string.Empty;

    public List<string> Dates { get; set; } = [];

    public List<decimal> Portfolio { get; set; } = [];

    public List<decimal> Benchmark { get; set; } = [];
}

public class PriceRefreshResponse
{
    public int Updated { get; set; }

    public int Failed { get; set; }

    public List<string> Errors { get; set; } = [];
}

public class SaleGainResponse
{
    public DateOnly Date { get; set; }

    public string Ticker { get; set; } = string.Empty;

    public string AssetName { get; set; } = string.Empty;

    public string AccountName { get; set; } = string.Empty;

    public decimal Quantity { get; set; }

    public decimal Price { get; set; }

    public decimal Amount { get; set; }

    public decimal Fee { get; set; }

    public decimal AllocatedCost { get; set; }

    public decimal RealizedGain { get; set; }
}