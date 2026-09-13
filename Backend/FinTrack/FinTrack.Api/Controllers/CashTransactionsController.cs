using FinTrack.Api.DTOs.CashTransactions;
using FinTrack.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace FinTrack.Api.Controllers;

[ApiController]
[Route("api/cash-transactions")]
public class CashTransactionsController : ControllerBase
{
    private readonly CashTransactionService _service;

    public CashTransactionsController(CashTransactionService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<CashTransactionResponse>>> GetAll(
        [FromQuery] int? month,
        [FromQuery] int? year)
    {
        var transactions = await _service.GetAllAsync(month, year);

        return Ok(transactions);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<CashTransactionResponse>> GetById(Guid id)
    {
        var transaction = await _service.GetByIdAsync(id);

        if (transaction is null)
            return NotFound();

        return Ok(transaction);
    }

    [HttpPost]
    public async Task<ActionResult<CashTransactionResponse>> Create(
        CreateCashTransactionRequest request)
    {
        var transaction = await _service.CreateAsync(request);

        return CreatedAtAction(
            nameof(GetById),
            new { id = transaction.Id },
            transaction);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<CashTransactionResponse>> Update(
        Guid id,
        UpdateCashTransactionRequest request)
    {
        var transaction = await _service.UpdateAsync(id, request);

        if (transaction is null)
            return NotFound();

        return Ok(transaction);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _service.DeleteAsync(id);

        if (!deleted)
            return NotFound();

        return NoContent();
    }
}