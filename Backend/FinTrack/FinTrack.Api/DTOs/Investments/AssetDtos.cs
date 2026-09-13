using FinTrack.Api.Utils.Enums;

namespace FinTrack.Api.DTOs.Investments;

public class AssetResponse
{
    public Guid Id { get; set; }

    public string Ticker { get; set; } = string.Empty;

    public string Name { get; set; } = string.Empty;

    public AssetType Type { get; set; }

    public string Currency { get; set; } = string.Empty;

    public decimal? ManualPrice { get; set; }

    public string? StooqSymbol { get; set; }
}

public class CreateAssetRequest
{
    public string Ticker { get; set; } = string.Empty;

    public string Name { get; set; } = string.Empty;

    public AssetType Type { get; set; }

    public string Currency { get; set; } = "EUR";

    public decimal? ManualPrice { get; set; }

    public string? StooqSymbol { get; set; }
}

public class UpdateAssetRequest
{
    public string Name { get; set; } = string.Empty;

    public AssetType Type { get; set; }

    public string Currency { get; set; } = "EUR";

    public decimal? ManualPrice { get; set; }

    public string? StooqSymbol { get; set; }
}

public class AddPriceRequest
{
    public DateOnly Date { get; set; }

    public decimal Price { get; set; }
}

public class PriceHistoryRow
{
    public Guid Id { get; set; }

    public DateOnly Date { get; set; }

    public decimal Price { get; set; }

    public bool IsManual { get; set; }
}