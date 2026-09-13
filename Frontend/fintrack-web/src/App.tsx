import { useMemo } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster } from "react-hot-toast";
import { createTheme, CssBaseline, ThemeProvider } from "@mui/material";
import Layout from "./components/Layout";
import { SettingsProvider } from "./context/SettingsProvider";
import { useSettings } from "./context/settings";
import AnalyticsPage from "./pages/AnalyticsPage";
import DashboardPage from "./pages/DashboardPage";
import SettingsPage from "./pages/SettingsPage";
import TransactionsPage from "./pages/TransactionsPage";

function AppContent() {
  const { themeMode } = useSettings();

  const theme = useMemo(
    () =>
      createTheme({
        palette: {
          mode: themeMode,
          primary: { main: "#4f46e5" },
          background:
            themeMode === "dark"
              ? { default: "#0f172a", paper: "#1e293b" }
              : { default: "#f8fafc", paper: "#ffffff" },
        },
        shape: { borderRadius: 10 },
        components: {
          MuiCard: {
            defaultProps: { elevation: 0 },
            styleOverrides: {
              root: {
                border: "1px solid",
                borderColor:
                  themeMode === "dark" ? "rgba(148,163,184,0.2)" : "rgba(15,23,42,0.08)",
              },
            },
          },
        },
      }),
    [themeMode],
  );

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <BrowserRouter>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<DashboardPage />} />
            <Route path="/transactions" element={<TransactionsPage />} />
            <Route path="/analytics" element={<AnalyticsPage />} />
            <Route path="/settings" element={<SettingsPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
      <Toaster position="bottom-right" />
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