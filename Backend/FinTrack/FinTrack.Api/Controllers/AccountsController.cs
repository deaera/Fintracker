using FinTrack.Api.DTOs.Accounts;
using FinTrack.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace FinTrack.Api.Controllers;

[ApiController]
[Route("api/accounts")]
public class AccountsController : ControllerBase
{
    private readonly AccountService _service;

    public AccountsController(AccountService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<AccountResponse>>> Get()
    {
        return Ok(await _service.GetAllAsync());
    }

    [HttpPost]
    public async Task<ActionResult<AccountResponse>> Create(CreateAccountRequest request)
    {
        var account = await _service.CreateAsync(request);

        return CreatedAtAction(nameof(Get), new { id = account.Id }, account);
    }
}