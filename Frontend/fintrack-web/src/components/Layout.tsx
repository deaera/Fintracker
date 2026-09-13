import { useState } from "react";
import { Outlet, useLocation, useNavigate } from "react-router-dom";
import {
  AppBar,
  Box,
  Drawer,
  IconButton,
  List,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  MenuItem,
  Select,
  Toolbar,
  Typography,
  useMediaQuery,
  useTheme,
} from "@mui/material";
import MenuIcon from "@mui/icons-material/Menu";
import PaymentsIcon from "@mui/icons-material/Payments";
import DashboardIcon from "@mui/icons-material/Dashboard";
import ReceiptLongIcon from "@mui/icons-material/ReceiptLong";
import InsightsIcon from "@mui/icons-material/Insights";
import SettingsIcon from "@mui/icons-material/Settings";
import TrendingUpIcon from "@mui/icons-material/TrendingUp";
import { DISPLAY_CURRENCIES, useSettings } from "../context/settings";
import { alpha } from "@mui/material/styles";

const DRAWER_WIDTH = 240;

const NAV_ITEMS = [
  { label: "Dashboard", path: "/", icon: <DashboardIcon /> },
  { label: "Transactions", path: "/transactions", icon: <ReceiptLongIcon /> },
  { label: "Investments", path: "/investments", icon: <TrendingUpIcon /> },
  { label: "Analytics", path: "/analytics", icon: <InsightsIcon /> },
  { label: "Settings", path: "/settings", icon: <SettingsIcon /> },
];

const CURRENCY_LABELS: Record<string, string> = {
  EUR: "€ EUR",
  USD: "$ USD",
  RON: "lei RON",
};

function pageTitle(pathname: string): string {
  return NAV_ITEMS.find((n) => n.path === pathname)?.label ?? "FinTrack";
}

export default function Layout() {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down("md"));
  const [drawerOpen, setDrawerOpen] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();
  const { currency, setCurrency } = useSettings();

  const drawerContent = (belowAppBar: boolean) => (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        height: "100%",
        pt: belowAppBar ? 0 : 2.5,
      }}
    >
      {belowAppBar && <Toolbar />}
      <Box sx={{ px: 3, pb: 2.5, display: "flex", alignItems: "center", gap: 1.25 }}>
        <Box
          sx={{
            width: 38,
            height: 38,
            borderRadius: 2.5,
            display: "grid",
            placeItems: "center",
            bgcolor: "primary.main",
            color: "primary.contrastText",
            boxShadow: "0 6px 16px rgba(79,70,229,0.35)",
          }}
        >
          <PaymentsIcon fontSize="small" />
        </Box>
        <Box>
          <Typography variant="subtitle1" sx={{ fontWeight: 800, lineHeight: 1.2 }}>
            FinTrack
          </Typography>
          <Typography variant="caption" color="text.secondary">
            Personal finance manager
          </Typography>
        </Box>
      </Box>
      <List
        sx={{ px: 1.5, pt: 1, display: "flex", flexDirection: "column", gap: 0.5 }}
      >
        {NAV_ITEMS.map((item) => {
          const selected = location.pathname === item.path;
          return (
            <ListItemButton
              key={item.path}
              selected={selected}
              onClick={() => {
                navigate(item.path);
                if (isMobile) setDrawerOpen(false);
              }}
              sx={{
                borderRadius: 2,
                mb: 0.25,
                ...(selected
                  ? {
                      bgcolor: alpha(theme.palette.primary.main, 0.14),
                      "&:hover": { bgcolor: alpha(theme.palette.primary.main, 0.2) },
                    }
                  : {}),
              }}
            >
              <ListItemIcon
                sx={{
                  minWidth: 40,
                  color: selected ? "primary.main" : "text.secondary",
                }}
              >
                {item.icon}
              </ListItemIcon>
              <ListItemText
                primary={item.label}
                slotProps={{
                  primary: {
                    sx: {
                      fontWeight: selected ? 700 : 500,
                      color: selected ? "primary.main" : "text.primary",
                    },
                  },
                }}
              />
            </ListItemButton>
          );
        })}
      </List>
    </Box>
  );

  return (
    <Box sx={{ display: "flex", minHeight: "100vh" }}>
      <AppBar
        position="fixed"
        sx={{
          zIndex: theme.zIndex.drawer + 1,
          bgcolor: "background.paper",
          color: "text.primary",
          borderBottom: "1px solid",
          borderColor: "divider",
          boxShadow: "none",
          ...(isMobile
            ? { left: 0, width: "100%" }
            : { left: DRAWER_WIDTH, width: `calc(100% - ${DRAWER_WIDTH}px)` }),
        }}
      >
        <Toolbar>
          {isMobile && (
            <IconButton
              edge="start"
              onClick={() => setDrawerOpen(true)}
              sx={{ mr: 1 }}
            >
              <MenuIcon />
            </IconButton>
          )}
          <Typography variant="h6" sx={{ fontWeight: 700 }}>
            {pageTitle(location.pathname)}
          </Typography>
          <Box sx={{ flexGrow: 1 }} />
          <Select
            size="small"
            value={currency}
            onChange={(e) => setCurrency(e.target.value)}
            sx={{ minWidth: 110 }}
          >
            {DISPLAY_CURRENCIES.map((c) => (
              <MenuItem key={c} value={c}>
                {CURRENCY_LABELS[c]}
              </MenuItem>
            ))}
          </Select>
        </Toolbar>
      </AppBar>

      {isMobile ? (
        <Drawer
          open={drawerOpen}
          onClose={() => setDrawerOpen(false)}
          slotProps={{ paper: { sx: { width: DRAWER_WIDTH } } }}
        >
          {drawerContent(true)}
        </Drawer>
      ) : (
        <Drawer
          variant="permanent"
          slotProps={{
            paper: {
              sx: {
                width: DRAWER_WIDTH,
                borderRight: "1px solid",
                borderColor: "divider",
              },
            },
          }}
        >
          {drawerContent(false)}
        </Drawer>
      )}

      <Box
        component="main"
        sx={{
          flexGrow: 1,
          mt: "64px",
          p: 3,
          ml: isMobile ? 0 : `${DRAWER_WIDTH}px`,
          minHeight: "calc(100vh - 64px)",
          bgcolor: (t) => t.palette.background.default,
        }}
      >
        <Outlet />
      </Box>
    </Box>
  );
}