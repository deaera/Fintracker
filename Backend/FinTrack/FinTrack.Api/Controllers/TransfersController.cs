using FinTrack.Api.DTOs.Transfers;
using FinTrack.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace FinTrack.Api.Controllers;

[ApiController]
[Route("api/transfers")]
public class TransfersController : ControllerBase
{
    private readonly TransferService _service;

    public TransfersController(TransferService service)
    {
        _service = service;
    }

    [HttpPost]
    public async Task<ActionResult<TransferResponse>> Create(CreateTransferRequest request)
    {
        var transfer = await _service.CreateAsync(request);

        return Ok(transfer);
    }
}