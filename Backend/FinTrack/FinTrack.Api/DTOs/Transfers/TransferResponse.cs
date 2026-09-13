using FinTrack.Api.DTOs.CashTransactions;

namespace FinTrack.Api.DTOs.Transfers;

public class TransferResponse
{
    public Guid PairId { get; set; }

    public List<CashTransactionResponse> Transactions { get; set; } = [];
}