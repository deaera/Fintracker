import api from "../api/api";
import type { CashTransaction, CreateTransactionInput } from "../types";

export async function getTransactions(): Promise<CashTransaction[]> {
  const { data } = await api.get<CashTransaction[]>("/cash-transactions");
  return data;
}

export async function createTransaction(input: CreateTransactionInput): Promise<CashTransaction> {
  const { data } = await api.post<CashTransaction>("/cash-transactions", input);
  return data;
}

export async function updateTransaction(id: string, input: CreateTransactionInput): Promise<CashTransaction> {
  const { data } = await api.put<CashTransaction>(`/cash-transactions/${id}`, input);
  return data;
}

export async function deleteTransaction(id: string): Promise<void> {
  await api.delete(`/cash-transactions/${id}`);
}