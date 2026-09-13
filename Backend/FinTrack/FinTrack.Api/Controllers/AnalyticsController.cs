using FinTrack.Api.DTOs.Analytics;
using FinTrack.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace FinTrack.Api.Controllers;

[ApiController]
[Route("api/analytics")]
public class AnalyticsController : ControllerBase
{
    private readonly AnalyticsService _service;

    public AnalyticsController(AnalyticsService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<AnalyticsResponse>> Get(
        [FromQuery] int? month,
        [FromQuery] int? year)
    {
        return Ok(await _service.GetAnalyticsAsync(month, year));
    }
}