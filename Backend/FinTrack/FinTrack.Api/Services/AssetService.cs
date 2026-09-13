using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Investments;
using FinTrack.Api.Entities;
using FinTrack.Api.Utils.Enums;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class AssetService
{
    private readonly FinanceDbContext _context;

    public AssetService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<List<AssetResponse>> GetAllAsync()
    {
        return await _context.Assets
            .AsNoTracking()
            .OrderBy(a => a.Ticker)
            .Select(a => new AssetResponse
            {
                Id = a.Id,
                Ticker = a.Ticker,
                Name = a.Name,
                Type = a.Type,
                Currency = a.Currency,
                ManualPrice = a.ManualPrice,
                StooqSymbol = a.StooqSymbol
            })
            .ToListAsync();
    }

    public async Task<AssetResponse> CreateAsync(CreateAssetRequest request)
    {
        var ticker = request.Ticker.Trim().ToUpperInvariant();

        if (string.IsNullOrWhiteSpace(ticker))
            throw new Exception("Ticker is required.");

        if (await _context.Assets.AnyAsync(a => a.Ticker == ticker))
            throw new Exception($"Asset {ticker} already exists.");

        var asset = new Asset
        {
            Ticker = ticker,
            Name = string.IsNullOrWhiteSpace(request.Name) ? ticker : request.Name.Trim(),
            Type = request.Type,
            Currency = NormalizeCurrency(request.Currency),
            ManualPrice = request.ManualPrice,
            StooqSymbol = request.StooqSymbol
        };

        _context.Assets.Add(asset);
        await _context.SaveChangesAsync();

        return ToResponse(asset);
    }

    public async Task<AssetResponse?> UpdateAsync(Guid id, UpdateAssetRequest request)
    {
        var asset = await _context.Assets.FindAsync(id);

        if (asset is null)
            return null;

        asset.Name = string.IsNullOrWhiteSpace(request.Name) ? asset.Name : request.Name.Trim();
        asset.Type = request.Type;
        asset.Currency = NormalizeCurrency(request.Currency);
        asset.ManualPrice = request.ManualPrice;
        asset.StooqSymbol = request.StooqSymbol;

        await _context.SaveChangesAsync();

        return ToResponse(asset);
    }

    public async Task<List<PriceHistoryRow>> GetPricesAsync(Guid assetId)
    {
        return await _context.PriceHistory
            .AsNoTracking()
            .Where(p => p.AssetId == assetId)
            .OrderByDescending(p => p.Date)
            .Select(p => new PriceHistoryRow
            {
                Id = p.Id,
                Date = p.Date,
                Price = p.Price,
                IsManual = p.IsManual
            })
            .Take(500)
            .ToListAsync();
    }

    public async Task<PriceHistoryRow> AddManualPriceAsync(Guid assetId, AddPriceRequest request)
    {
        if (request.Price <= 0)
            throw new Exception("Price must be greater than zero.");

        var price = new PriceHistory
        {
            AssetId = assetId,
            Date = request.Date,
            Price = request.Price,
            IsManual = true
        };

        _context.PriceHistory.Add(price);
        await _context.SaveChangesAsync();

        return new PriceHistoryRow
        {
            Id = price.Id,
            Date = price.Date,
            Price = price.Price,
            IsManual = price.IsManual
        };
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var asset = await _context.Assets.FindAsync(id);

        if (asset is null)
            return false;

        _context.Assets.Remove(asset);
        await _context.SaveChangesAsync();

        return true;
    }

    private static string NormalizeCurrency(string currency)
        => string.IsNullOrWhiteSpace(currency) ? "EUR" : currency.Trim().ToUpperInvariant();

    private static AssetResponse ToResponse(Asset asset) => new()
    {
        Id = asset.Id,
        Ticker = asset.Ticker,
        Name = asset.Name,
        Type = asset.Type,
        Currency = asset.Currency,
        ManualPrice = asset.ManualPrice,
        StooqSymbol = asset.StooqSymbol
    };
}