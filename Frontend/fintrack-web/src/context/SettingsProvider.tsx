import { useCallback, useEffect, useMemo, useState } from "react";
import { SettingsContext, type Settings } from "./settings";
import { useApiData } from "../hooks/useApiData";
import { getCurrencyRates } from "../services/currencyService";
import type { CurrencyRates } from "../types";

const STORAGE_KEY = "fintrack.settings";

function loadSettings(): Settings {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      return {
        currency: parsed.currency ?? "EUR",
        themeMode: parsed.themeMode ?? "light",
      };
    }
  } catch {
    // ignore malformed storage
  }
  return { currency: "EUR", themeMode: "light" };
}

export function SettingsProvider({ children }: { children: React.ReactNode }) {
  const [settings, setSettings] = useState<Settings>(loadSettings);

  const { data: rates } = useApiData<CurrencyRates>(getCurrencyRates, "settings-rates");

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
  }, [settings]);

  const setCurrency = useCallback((currency: string) => {
    setSettings((prev) => ({ ...prev, currency }));
  }, []);

  const setThemeMode = useCallback((themeMode: Settings["themeMode"]) => {
    setSettings((prev) => ({ ...prev, themeMode }));
  }, []);

  const eurRate = rates?.rates["EUR"] ?? 1;
  const displayRate = rates?.rates[settings.currency] ?? 1;
  const rate = displayRate / eurRate;

  const convert = useCallback((amount: number) => amount * rate, [rate]);

  const convertTo = useCallback(
    (amount: number, code: string) => {
      const r = rates?.rates[code];
      return typeof r === "number" && r > 0 ? amount * r : amount;
    },
    [rates],
  );

  const value = useMemo(
    () => ({
      ...settings,
      setCurrency,
      setThemeMode,
      rate,
      convert,
      convertTo,
      ratesSource: rates?.source ?? null,
      ratesUpdatedAt: rates?.updatedAt ?? null,
    }),
    [settings, setCurrency, setThemeMode, rate, convert, convertTo, rates],
  );

  return <SettingsContext.Provider value={value}>{children}</SettingsContext.Provider>;
}