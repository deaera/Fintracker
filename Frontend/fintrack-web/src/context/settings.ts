import { createContext, useContext } from "react";

export type ThemeMode = "light" | "dark";

export interface Settings {
  currency: string;
  themeMode: ThemeMode;
}

export interface SettingsContextValue extends Settings {
  setCurrency: (currency: string) => void;
  setThemeMode: (mode: ThemeMode) => void;
}

export const SettingsContext = createContext<SettingsContextValue>({
  currency: "EUR",
  themeMode: "light",
  setCurrency: () => {},
  setThemeMode: () => {},
});

// eslint-disable-next-line react-refresh/only-export-components
export function useSettings(): SettingsContextValue {
  return useContext(SettingsContext);
}