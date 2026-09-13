import { useCallback, useEffect, useMemo, useState } from "react";
import { SettingsContext, type Settings } from "./settings";

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

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
  }, [settings]);

  const setCurrency = useCallback((currency: string) => {
    setSettings((prev) => ({ ...prev, currency }));
  }, []);

  const setThemeMode = useCallback((themeMode: Settings["themeMode"]) => {
    setSettings((prev) => ({ ...prev, themeMode }));
  }, []);

  const value = useMemo(
    () => ({ ...settings, setCurrency, setThemeMode }),
    [settings, setCurrency, setThemeMode],
  );

  return <SettingsContext.Provider value={value}>{children}</SettingsContext.Provider>;
}