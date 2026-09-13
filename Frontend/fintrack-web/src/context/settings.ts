import { createContext, useContext } from "react";

export type ThemeMode = "light" | "dark";

export const DISPLAY_CURRENCIES = ["EUR", "RON", "USD"];

export interface Settings {
  currency: string;
  themeMode: ThemeMode;
}

export interface SettingsContextValue extends Settings {
  setCurrency: (currency: string) => void;
  setThemeMode: (mode: ThemeMode) => void;
  rate: number;
  convert: (amount: number) => number;
  convertTo: (amount: number, code: string) => number;
  convertFrom: (amount: number, code: string) => number;
  ratesSource: "live" | "fallback" | null;
  ratesUpdatedAt: string | null;
}

export const SettingsContext = createContext<SettingsContextValue>({
  currency: "EUR",
  themeMode: "light",
  setCurrency: () => {},
  setThemeMode: () => {},
  rate: 1,
  convert: (amount) => amount,
  convertTo: (amount) => amount,
  convertFrom: (amount) => amount,
  ratesSource: null,
  ratesUpdatedAt: null,
});

export function useSettings(): SettingsContextValue {
  return useContext(SettingsContext);
}