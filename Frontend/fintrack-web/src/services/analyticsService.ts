import api from "../api/api";
import type { Analytics, Period } from "../types";

export async function getAnalytics(period?: Period): Promise<Analytics> {
  const params: Record<string, number> = {};
  if (period?.month != null) params.month = period.month;
  if (period?.year != null) params.year = period.year;
  const { data } = await api.get<Analytics>("/analytics", { params });
  return data;
}