import api from "../api/api";
import type { Account, CreateAccountInput } from "../types";

export async function getAccounts(): Promise<Account[]> {
  const { data } = await api.get<Account[]>("/accounts");
  return data;
}

export async function createAccount(input: CreateAccountInput): Promise<Account> {
  const { data } = await api.post<Account>("/accounts", input);
  return data;
}