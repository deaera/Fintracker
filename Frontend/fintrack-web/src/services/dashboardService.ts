import api from "../api/api";
import type { Dashboard, Period } from "../types";

export async function getDashboard(period?: Period): Promise<Dashboard> {
  const params: Record<string, number> = {};
  if (period?.month != null) params.month = period.month;
  if (period?.year != null) params.year = period.year;
  const { data } = await api.get<Dashboard>("/dashboard", { params });
  return data;
}