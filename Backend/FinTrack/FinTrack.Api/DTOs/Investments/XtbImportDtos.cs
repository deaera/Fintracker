using FinTrack.Api.Utils.Enums;

namespace FinTrack.Api.DTOs.Investments;

public class XtbImportRow
{
    public string RawType { get; set; } = string.Empty;

    public InvestmentTransactionType? Type { get; set; }

    public bool Supported { get; set; }

    public string Reason { get; set; } = string.Empty;

    public string Ticker { get; set; } = string.Empty;

    public string Name { get; set; } = string.Empty;

    public string AssetClass { get; set; } = string.Empty;

    public DateOnly Date { get; set; }

    public decimal Quantity { get; set; }

    public decimal Price { get; set; }

    public decimal Amount { get; set; }

    public string Note { get; set; } = string.Empty;
}

public class XtbReconciliationRow
{
    public string Ticker { get; set; } = string.Empty;

    public decimal ExpectedQuantity { get; set; }

    public decimal ImportedQuantity { get; set; }

    public bool Match { get; set; }
}

public class XtbClosedRow
{
    public string Ticker { get; set; } = string.Empty;

    public int Trades { get; set; }

    public decimal BrokerProfit { get; set; }

    public decimal ComputedProfit { get; set; }
}

public class XtbImportParseRequest
{
    public string CashRows { get; set; } = string.Empty;

    public string? OpenPositions { get; set; }

    public string AccountCurrency { get; set; } = "EUR";
}

public class XtbImportParseResponse
{
    public string AccountCurrency { get; set; } = "EUR";

    public string SourceFile { get; set; } = string.Empty;

    public List<string> ParsedSheets { get; set; } = [];

    public string CashRows { get; set; } = string.Empty;

    public List<XtbImportRow> Rows { get; set; } = [];

    public List<XtbReconciliationRow>? Reconciliation { get; set; }

    public List<XtbClosedRow>? ClosedPositions { get; set; }

    public int TotalCount { get; set; }

    public int SupportedCount { get; set; }

    public int SkippedCount { get; set; }

    public int NewAssets { get; set; }

    public decimal FinalCash { get; set; }
}

public class XtbImportCommitRequest
{
    public string AccountName { get; set; } = "XTB";

    public string AccountCurrency { get; set; } = "EUR";

    public string CashRows { get; set; } = string.Empty;
}

public class XtbImportCommitResponse
{
    public Guid AccountId { get; set; }

    public int Imported { get; set; }

    public int Deleted { get; set; }

    public int Skipped { get; set; }

    public List<string> CreatedAssets { get; set; } = [];

    public decimal FinalCash { get; set; }
}