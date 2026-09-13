import api from "../api/api";
import type { CurrencyRates } from "../types";

export async function getCurrencyRates(): Promise<CurrencyRates> {
  const { data } = await api.get<CurrencyRates>("/currency/rates");
  return data;
}