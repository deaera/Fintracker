import { useMemo } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster } from "react-hot-toast";
import { createTheme, CssBaseline, ThemeProvider } from "@mui/material";
import Layout from "./components/Layout";
import { SettingsProvider } from "./context/SettingsProvider";
import { useSettings } from "./context/settings";
import AnalyticsPage from "./pages/AnalyticsPage";
import DashboardPage from "./pages/DashboardPage";
import InvestmentsPage from "./pages/Investments/InvestmentsPage";
import SettingsPage from "./pages/SettingsPage";
import TransactionsPage from "./pages/TransactionsPage";

function AppContent() {
  const { themeMode } = useSettings();
  const isDark = themeMode === "dark";

  const theme = useMemo(() => {
    const cardBorder = isDark ? "rgba(148,163,184,0.2)" : "rgba(15,23,42,0.08)";
    const dialogBorder = isDark ? "rgba(148,163,184,0.25)" : "rgba(15,23,42,0.12)";
    const inputBorder = isDark ? "rgba(148,163,184,0.35)" : "rgba(15,23,42,0.23)";
    const controlText = isDark ? "#e2e8f0" : "#334155";
    const iconColor = isDark ? "rgba(226,232,240,0.8)" : "rgba(15,23,42,0.62)";
    const chipBg = isDark ? "rgba(148,163,184,0.14)" : "rgba(15,23,42,0.07)";

    return createTheme({
      palette: {
        mode: themeMode,
        primary: { main: "#4f46e5", contrastText: "#ffffff" },
        ...(isDark
          ? {
              background: { default: "#0f172a", paper: "#1e293b" },
              text: { primary: "#e2e8f0", secondary: "#94a3b8", disabled: "#64748b" },
              divider: "rgba(148,163,184,0.24)",
              action: {
                hover: "rgba(148,163,184,0.08)",
                selected: "rgba(148,163,184,0.16)",
                disabled: "rgba(226,232,240,0.3)",
              },
            }
          : {
              background: { default: "#f8fafc", paper: "#ffffff" },
              text: { primary: "#0f172a", secondary: "#64748b", disabled: "#94a3b8" },
              divider: "rgba(15,23,42,0.12)",
              action: { hover: "rgba(15,23,42,0.05)", selected: "rgba(15,23,42,0.1)" },
            }),
      },
      shape: { borderRadius: 10 },
      components: {
        MuiCard: {
          defaultProps: { elevation: 0 },
          styleOverrides: {
            root: {
              border: "1px solid",
              borderColor: cardBorder,
              backgroundImage: "none",
            },
          },
        },
        MuiPaper: {
          styleOverrides: {
            root: {
              backgroundImage: "none",
              ...(isDark ? { border: "1px solid", borderColor: dialogBorder } : {}),
            },
          },
        },
        MuiDialog: {
          styleOverrides: {
            paper: {
              border: "1px solid",
              borderColor: dialogBorder,
              backgroundImage: "none",
              boxShadow: isDark
                ? "0 16px 48px rgba(0,0,0,0.5)"
                : "0 8px 32px rgba(15,23,42,0.12)",
            },
          },
        },
        MuiButton: {
          styleOverrides: {
            text: {
              color: controlText,
              "&:hover": isDark ? { backgroundColor: "rgba(148,163,184,0.12)" } : {},
            },
            outlined: {
              color: controlText,
              borderColor: inputBorder,
            },
            ...(!isDark
              ? {}
              : {
                  textPrimary: { color: "#4f46e5" },
                  outlinedPrimary: { color: "#818cf8", borderColor: "rgba(129,140,248,0.5)" },
                }),
          },
        },
        MuiIconButton: {
          styleOverrides: {
            root: { color: iconColor },
          },
        },
        MuiOutlinedInput: {
          styleOverrides: {
            notchedOutline: {
              borderColor: inputBorder,
            },
            root: {
              "&:hover .MuiOutlinedInput-notchedOutline": {
                borderColor: isDark ? "rgba(148,163,184,0.6)" : "rgba(15,23,42,0.4)",
              },
            },
          },
        },
        MuiInputLabel: {
          styleOverrides: {
            root: { color: isDark ? "#94a3b8" : "#64748b" },
          },
        },
        MuiToggleButton: {
          styleOverrides: {
            root: {
              color: controlText,
              borderColor: inputBorder,
              "&.Mui-selected": {
                color: isDark ? "#a5b4fc" : "#4f46e5",
                backgroundColor: isDark ? "rgba(99,102,241,0.15)" : "rgba(79,70,229,0.08)",
              },
            },
          },
        },
        MuiChip: {
          styleOverrides: {
            outlined: { color: controlText, borderColor: inputBorder },
            ...(!isDark ? {} : { filled: { backgroundColor: chipBg } }),
          },
        },
        MuiMenu: {
          styleOverrides: {
            paper: {
              backgroundImage: "none",
            },
          },
        },
      },
    });
  }, [themeMode, isDark]);

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <BrowserRouter>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<DashboardPage />} />
            <Route path="/transactions" element={<TransactionsPage />} />
            <Route path="/investments" element={<InvestmentsPage />} />
            <Route path="/analytics" element={<AnalyticsPage />} />
            <Route path="/settings" element={<SettingsPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
      <Toaster
        position="bottom-right"
        toastOptions={{
          style: {
            background: isDark ? "#1e293b" : "#ffffff",
            color: isDark ? "#e2e8f0" : "#0f172a",
            border: isDark ? "1px solid rgba(148,163,184,0.25)" : undefined,
          },
        }}
      />
    </ThemeProvider>
  );
}

export default function App() {
  return (
    <SettingsProvider>
      <AppContent />
    </SettingsProvider>
  );
}