using System.Text;
using FinTrack.Api.DTOs.Investments;
using FinTrack.Api.Services;
using FinTrack.Api.Utils.Enums;
using Microsoft.AspNetCore.Mvc;

namespace FinTrack.Api.Controllers;

[ApiController]
[Route("api/investments")]
public class InvestmentsController : ControllerBase
{
    private readonly AssetService _assets;
    private readonly InvestmentAccountService _accounts;
    private readonly InvestmentTransactionService _transactions;
    private readonly InvestmentPortfolioService _portfolio;

    public InvestmentsController(
        AssetService assets,
        InvestmentAccountService accounts,
        InvestmentTransactionService transactions,
        InvestmentPortfolioService portfolio)
    {
        _assets = assets;
        _accounts = accounts;
        _transactions = transactions;
        _portfolio = portfolio;
    }

    [HttpGet("overview")]
    public async Task<ActionResult<OverviewResponse>> GetOverview() => Ok(await _portfolio.GetOverviewAsync());

    [HttpGet("holdings")]
    public async Task<ActionResult<List<HoldingResponse>>> GetHoldings() => Ok(await _portfolio.GetHoldingsAsync());

    [HttpGet("performance")]
    public async Task<ActionResult<PerformanceResponse>> GetPerformance([FromQuery] string range = "ALL")
        => Ok(await _portfolio.GetPerformanceAsync(range));

    [HttpGet("allocation")]
    public async Task<ActionResult<List<AllocationEntry>>> GetAllocation([FromQuery] string by = "type")
        => Ok(await _portfolio.GetAllocationAsync(by));

    [HttpGet("contributions")]
    public async Task<ActionResult<List<ContributionEntry>>> GetContributions()
        => Ok(await _portfolio.GetContributionsAsync());

    [HttpGet("dividends")]
    public async Task<ActionResult<DividendResponse>> GetDividends([FromQuery] int? year)
        => Ok(await _portfolio.GetDividendsAsync(year));

    [HttpGet("benchmark")]
    public async Task<ActionResult<BenchmarkResponse>> GetBenchmark(
        [FromQuery] string range = "1Y",
        [FromQuery] string symbol = "EQQQ.DE")
    {
        var portfolio = await _portfolio.GetPerformanceAsync(range);
        return Ok(await _portfolio.GetBenchmarkAsync(range, symbol, portfolio));
    }

    [HttpPost("prices/refresh")]
    public async Task<ActionResult<PriceRefreshResponse>> RefreshPrices()
        => Ok(await _portfolio.RefreshPricesAsync());

    [HttpGet("export/{kind}")]
    public async Task<IActionResult> Export(string kind)
    {
        string compressed;

        switch (kind.ToLowerInvariant())
        {
            case "sales":
                compressed = BuildSalesCsv(await _portfolio.GetSalesAsync());
                break;
            case "dividends":
                compressed = BuildDividendsCsv(await _transactions.GetAllAsync());
                break;
            case "gains":
                compressed = BuildGainsCsv(
                    await _portfolio.GetSalesAsync(),
                    await _transactions.GetAllAsync());
                break;
            default:
                compressed = BuildTransactionCsv(await _transactions.GetAllAsync());
                break;
        }

        return File(
            Encoding.UTF8.GetBytes(compressed),
            "text/csv",
            $"investments-{kind}-{DateTime.Today:yyyy-MM-dd}.csv");
    }

    // ---- Accounts ----

    [HttpGet("accounts")]
    public async Task<ActionResult<List<InvestmentAccountResponse>>> GetAccounts()
        => Ok(await _accounts.GetAllAsync());

    [HttpPost("accounts")]
    public async Task<ActionResult<InvestmentAccountResponse>> CreateAccount(CreateInvestmentAccountRequest request)
    {
        var account = await _accounts.CreateAsync(request);
        return CreatedAtAction(nameof(GetAccounts), new { id = account.Id }, account);
    }

    [HttpPut("accounts/{id:guid}")]
    public async Task<ActionResult<InvestmentAccountResponse>> UpdateAccount(
        Guid id,
        UpdateInvestmentAccountRequest request)
    {
        var account = await _accounts.UpdateAsync(id, request);

        if (account is null)
            return NotFound();

        return Ok(account);
    }

    [HttpDelete("accounts/{id:guid}")]
    public async Task<IActionResult> DeleteAccount(Guid id)
    {
        var deleted = await _accounts.DeleteAsync(id);

        if (!deleted)
            return NotFound();

        return NoContent();
    }

    // ---- Assets ----

    [HttpGet("assets")]
    public async Task<ActionResult<List<AssetResponse>>> GetAssets() => Ok(await _assets.GetAllAsync());

    [HttpPost("assets")]
    public async Task<ActionResult<AssetResponse>> CreateAsset(CreateAssetRequest request)
    {
        var asset = await _assets.CreateAsync(request);
        return CreatedAtAction(nameof(GetAssets), new { id = asset.Id }, asset);
    }

    [HttpPut("assets/{id:guid}")]
    public async Task<ActionResult<AssetResponse>> UpdateAsset(Guid id, UpdateAssetRequest request)
    {
        var asset = await _assets.UpdateAsync(id, request);

        if (asset is null)
            return NotFound();

        return Ok(asset);
    }

    [HttpDelete("assets/{id:guid}")]
    public async Task<IActionResult> DeleteAsset(Guid id)
    {
        var deleted = await _assets.DeleteAsync(id);

        if (!deleted)
            return NotFound();

        return NoContent();
    }

    [HttpGet("assets/{id:guid}/prices")]
    public async Task<ActionResult<List<PriceHistoryRow>>> GetAssetPrices(Guid id)
        => Ok(await _assets.GetPricesAsync(id));

    [HttpPost("assets/{id:guid}/prices")]
    public async Task<ActionResult<PriceHistoryRow>> AddManualPrice(Guid id, AddPriceRequest request)
    {
        var price = await _assets.AddManualPriceAsync(id, request);
        return CreatedAtAction(nameof(GetAssetPrices), new { id }, price);
    }

    // ---- Transactions ----

    [HttpGet("transactions")]
    public async Task<ActionResult<List<InvestmentTransactionResponse>>> GetTransactions(
        [FromQuery] Guid? account,
        [FromQuery] Guid? asset,
        [FromQuery] InvestmentTransactionType? type,
        [FromQuery] DateOnly? from,
        [FromQuery] DateOnly? to)
        => Ok(await _transactions.GetAllAsync(account, asset, type, from, to));

    [HttpPost("transactions")]
    public async Task<ActionResult<InvestmentTransactionResponse>> CreateTransaction(
        CreateInvestmentTransactionRequest request)
    {
        var transaction = await _transactions.CreateAsync(request);
        return CreatedAtAction(nameof(GetTransactions), new { id = transaction.Id }, transaction);
    }

    [HttpPut("transactions/{id:guid}")]
    public async Task<ActionResult<InvestmentTransactionResponse>> UpdateTransaction(
        Guid id,
        UpdateInvestmentTransactionRequest request)
    {
        var transaction = await _transactions.UpdateAsync(id, request);

        if (transaction is null)
            return NotFound();

        return Ok(transaction);
    }

    [HttpDelete("transactions/{id:guid}")]
    public async Task<IActionResult> DeleteTransaction(Guid id)
    {
        var deleted = await _transactions.DeleteAsync(id);

        if (!deleted)
            return NotFound();

        return NoContent();
    }

    private static string BuildSalesCsv(List<SaleGainResponse> sales)
    {
        var sb = new StringBuilder();
        sb.AppendLine("Date,Ticker,Asset,Account,Quantity,Price,SellAmount,Fee,CostBasis,RealizedGain");
        foreach (var s in sales)
            sb.AppendLine(string.Join(",", Iso(s.Date), s.Ticker, Csv(s.AssetName), Csv(s.AccountName), Num(s.Quantity), Num(s.Price), Num(s.Amount), Num(s.Fee), Num(s.AllocatedCost), Num(s.RealizedGain)));
        return sb.ToString();
    }

    private static string BuildGainsCsv(List<SaleGainResponse> sales, List<InvestmentTransactionResponse> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("Date,Ticker,Asset,Account,Category,Amount,Gain/Income");

        foreach (var s in sales)
            sb.AppendLine(string.Join(",", Iso(s.Date), s.Ticker, Csv(s.AssetName), Csv(s.AccountName), "Realized gain", Num(s.Amount - s.Fee), Num(s.RealizedGain)));

        foreach (var r in rows.Where(r => r.Type is InvestmentTransactionType.Dividend or InvestmentTransactionType.Interest))
            sb.AppendLine(string.Join(",", Iso(r.Date), r.Ticker, Csv(r.AssetName), Csv(r.AccountName), r.Type == InvestmentTransactionType.Dividend ? "Dividend income" : "Interest income", Num(r.Amount), Num(r.Amount)));

        return sb.ToString();
    }

    private static string BuildDividendsCsv(List<InvestmentTransactionResponse> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("Date,Ticker,Asset,Account,Amount,Currency,Note");
        foreach (var r in rows.Where(r => r.Type == InvestmentTransactionType.Dividend))
            sb.AppendLine(string.Join(",", Iso(r.Date), r.Ticker, Csv(r.AssetName), Csv(r.AccountName), Num(r.Amount), r.AssetCurrency, Csv(r.Note)));
        return sb.ToString();
    }

    private static string BuildTransactionCsv(List<InvestmentTransactionResponse> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("Date,Account,Asset,Type,Quantity,Price,Amount,Fee,Note");
        foreach (var r in rows)
            sb.AppendLine(string.Join(",", Iso(r.Date), Csv(r.AccountName), r.Ticker, r.Type, Num(r.Quantity), Num(r.Price), Num(r.Amount), Num(r.Fee), Csv(r.Note)));
        return sb.ToString();
    }

    private static string Iso(DateOnly date) => date.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture);

    private static string Num(decimal value) => value.ToString("0.00####", System.Globalization.CultureInfo.InvariantCulture);

    private static string Csv(string value)
        => value.Contains(',') || value.Contains('"') ? $"\"{value.Replace("\"", "\"\"")}\"" : value;
}