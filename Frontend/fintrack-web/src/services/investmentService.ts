import api from "../api/api";
import type {
  AddPriceInput,
  AllocationEntry,
  BenchmarkResponse,
  ContributionEntry,
  CreateInvestmentAccountInput,
  CreateInvestmentAssetInput,
  CreateInvestmentTransactionInput,
  DividendResponse,
  InvestmentAccount,
  InvestmentAsset,
  InvestmentHolding,
  InvestmentOverview,
  InvestmentTransaction,
  InvestmentTransactionType,
  PerformanceResponse,
  PriceHistoryRow,
  PriceRefreshResponse,
} from "../types";

const BASE = "/investments";

export async function getInvestmentOverview(): Promise<InvestmentOverview> {
  const { data } = await api.get<InvestmentOverview>(`${BASE}/overview`);
  return data;
}

export async function getInvestmentHoldings(): Promise<InvestmentHolding[]> {
  const { data } = await api.get<InvestmentHolding[]>(`${BASE}/holdings`);
  return data;
}

export async function getInvestmentPerformance(range: string): Promise<PerformanceResponse> {
  const { data } = await api.get<PerformanceResponse>(`${BASE}/performance`, {
    params: { range },
  });
  return data;
}

export async function getInvestmentAllocation(by: string): Promise<AllocationEntry[]> {
  const { data } = await api.get<AllocationEntry[]>(`${BASE}/allocation`, {
    params: { by },
  });
  return data;
}

export async function getInvestmentContributions(): Promise<ContributionEntry[]> {
  const { data } = await api.get<ContributionEntry[]>(`${BASE}/contributions`);
  return data;
}

export async function getInvestmentDividends(year: number): Promise<DividendResponse> {
  const { data } = await api.get<DividendResponse>(`${BASE}/dividends`, {
    params: { year },
  });
  return data;
}

export async function getInvestmentBenchmark(
  range: string,
  symbol: string,
): Promise<BenchmarkResponse> {
  const { data } = await api.get<BenchmarkResponse>(`${BASE}/benchmark`, {
    params: { range, symbol },
  });
  return data;
}

export async function refreshInvestmentPrices(): Promise<PriceRefreshResponse> {
  const { data } = await api.post<PriceRefreshResponse>(`${BASE}/prices/refresh`);
  return data;
}

export interface TransactionFilters {
  account?: string;
  asset?: string;
  type?: InvestmentTransactionType;
  from?: string;
  to?: string;
}

export async function getInvestmentTransactions(
  filters: TransactionFilters = {},
): Promise<InvestmentTransaction[]> {
  const { data } = await api.get<InvestmentTransaction[]>(`${BASE}/transactions`, {
    params: filters,
  });
  return data;
}

export async function createInvestmentTransaction(
  input: CreateInvestmentTransactionInput,
): Promise<InvestmentTransaction> {
  const { data } = await api.post<InvestmentTransaction>(`${BASE}/transactions`, input);
  return data;
}

export async function updateInvestmentTransaction(
  id: string,
  input: CreateInvestmentTransactionInput,
): Promise<InvestmentTransaction> {
  const { data } = await api.put<InvestmentTransaction>(`${BASE}/transactions/${id}`, input);
  return data;
}

export async function deleteInvestmentTransaction(id: string): Promise<void> {
  await api.delete(`${BASE}/transactions/${id}`);
}

export async function getInvestmentAccounts(): Promise<InvestmentAccount[]> {
  const { data } = await api.get<InvestmentAccount[]>(`${BASE}/accounts`);
  return data;
}

export async function createInvestmentAccount(
  input: CreateInvestmentAccountInput,
): Promise<InvestmentAccount> {
  const { data } = await api.post<InvestmentAccount>(`${BASE}/accounts`, input);
  return data;
}

export async function updateInvestmentAccount(
  id: string,
  input: CreateInvestmentAccountInput,
): Promise<InvestmentAccount> {
  const { data } = await api.put<InvestmentAccount>(`${BASE}/accounts/${id}`, input);
  return data;
}

export async function deleteInvestmentAccount(id: string): Promise<void> {
  await api.delete(`${BASE}/accounts/${id}`);
}

export async function getInvestmentAssets(): Promise<InvestmentAsset[]> {
  const { data } = await api.get<InvestmentAsset[]>(`${BASE}/assets`);
  return data;
}

export async function createInvestmentAsset(
  input: CreateInvestmentAssetInput,
): Promise<InvestmentAsset> {
  const { data } = await api.post<InvestmentAsset>(`${BASE}/assets`, input);
  return data;
}

export async function updateInvestmentAsset(
  id: string,
  input: CreateInvestmentAssetInput,
): Promise<InvestmentAsset> {
  const { data } = await api.put<InvestmentAsset>(`${BASE}/assets/${id}`, input);
  return data;
}

export async function deleteInvestmentAsset(id: string): Promise<void> {
  await api.delete(`${BASE}/assets/${id}`);
}

export async function getAssetPrices(id: string): Promise<PriceHistoryRow[]> {
  const { data } = await api.get<PriceHistoryRow[]>(`${BASE}/assets/${id}/prices`);
  return data;
}

export async function addManualPrice(id: string, input: AddPriceInput): Promise<PriceHistoryRow> {
  const { data } = await api.post<PriceHistoryRow>(`${BASE}/assets/${id}/prices`, input);
  return data;
}

export async function downloadInvestmentCsv(kind: "sales" | "dividends" | "gains"): Promise<void> {
  const { data } = await api.get<Blob>(`${BASE}/export/${kind}`, { responseType: "blob" });
  const url = URL.createObjectURL(data);
  const link = document.createElement("a");
  link.href = url;
  link.download = `investments-${kind}.csv`;
  link.click();
  URL.revokeObjectURL(url);
}