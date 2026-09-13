import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react";

type ThemeMode = "light" | "dark";

interface Settings {
  currency: string;
  themeMode: ThemeMode;
}

interface SettingsContextValue extends Settings {
  setCurrency: (currency: string) => void;
  setThemeMode: (mode: ThemeMode) => void;
}

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
    // ignore
  }
  return { currency: "EUR", themeMode: "light" };
}

export const SettingsContext = createContext<SettingsContextValue>({
  currency: "EUR",
  themeMode: "light",
  setCurrency: () => {},
  setThemeMode: () => {},
});

export function SettingsProvider({ children }: { children: React.ReactNode }) {
  const [settings, setSettings] = useState<Settings>(loadSettings);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
  }, [settings]);

  const setCurrency = useCallback((currency: string) => {
    setSettings((prev) => ({ ...prev, currency }));
  }, []);

  const setThemeMode = useCallback((themeMode: ThemeMode) => {
    setSettings((prev) => ({ ...prev, themeMode }));
  }, []);

  const value = useMemo(
    () => ({ ...settings, setCurrency, setThemeMode }),
    [settings, setCurrency, setThemeMode],
  );

  return <SettingsContext.Provider value={value}>{children}</SettingsContext.Provider>;
}

export function useSettings() {
  return useContext(SettingsContext);
}