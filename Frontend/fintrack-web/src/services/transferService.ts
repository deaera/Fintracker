import api from "../api/api";
import type { CashTransaction, CreateTransferInput } from "../types";

export interface TransferResponse {
  pairId: string;
  transactions: CashTransaction[];
}

export async function createTransfer(input: CreateTransferInput): Promise<TransferResponse> {
  const { data } = await api.post<TransferResponse>("/transfers", input);
  return data;
}