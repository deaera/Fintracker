using FinTrack.Api.DTOs.Currency;
using FinTrack.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace FinTrack.Api.Controllers;

[ApiController]
[Route("api/currency")]
public class CurrencyController : ControllerBase
{
    private readonly CurrencyService _service;

    public CurrencyController(CurrencyService service)
    {
        _service = service;
    }

    [HttpGet("rates")]
    public async Task<ActionResult<CurrencyRatesResponse>> GetRates()
    {
        return Ok(await _service.GetRatesAsync());
    }
}