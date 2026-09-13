using FinTrack.Api.DTOs.Dashboard;
using FinTrack.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace FinTrack.Api.Controllers;

[ApiController]
[Route("api/dashboard")]
public class DashboardController : ControllerBase
{
    private readonly DashboardService _service;

    public DashboardController(DashboardService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<DashboardResponse>> Get(
        [FromQuery] int? month,
        [FromQuery] int? year)
    {
        return Ok(await _service.GetDashboardAsync(month, year));
    }
}