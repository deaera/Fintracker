import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import toast from "react-hot-toast";
import {
  Box,
  Card,
  CardContent,
  Chip,
  CircularProgress,
  Divider,
  Grid,
  List,
  ListItem,
  ListItemText,
  Stack,
  Typography,
} from "@mui/material";
import ArrowDownwardIcon from "@mui/icons-material/ArrowDownward";
import ArrowUpwardIcon from "@mui/icons-material/ArrowUpward";
import AccountBalanceWalletIcon from "@mui/icons-material/AccountBalanceWallet";
import PayrollIcon from "@mui/icons-material/Payments";
import ReceiptLongIcon from "@mui/icons-material/ReceiptLong";
import SavingsIcon from "@mui/icons-material/Savings";
import CategoryPie from "../components/CategoryPie";
import MonthlyTrendChart from "../components/MonthlyTrendChart";
import PeriodSelector from "../components/PeriodSelector";
import { useSettings } from "../context/SettingsContext";
import { getDashboard } from "../services/dashboardService";
import type { CategorySummary, Dashboard, Period } from "../types";
import { CategoryType } from "../types";
import { formatCurrency, formatDate } from "../utils/format";

interface StatCardProps {
  title: string;
  value: string;
  icon: React.ReactNode;
  color?: string;
  sub?: string;
}

function StatCard({ title, value, icon, color, sub }: StatCardProps) {
  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Stack spacing={1.5}>
          <Box sx={{ display: "flex", alignItems: "center", gap: 1, color: "text.secondary" }}>
            {icon}
            <Typography variant="body2">{title}</Typography>
          </Box>
          <Typography
            variant="h5"
            sx={{ fontWeight: 700, color: color ?? "text.primary" }}
          >
            {value}
          </Typography>
          {sub && (
            <Typography variant="body2" color="text.secondary">
              {sub}
            </Typography>
          )}
        </Stack>
      </CardContent>
    </Card>
  );
}

export default function DashboardPage() {
  const { currency } = useSettings();
  const [period, setPeriod] = useState<Period>({ month: null, year: null });
  const [data, setData] = useState<Dashboard | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    setLoading(true);
    getDashboard(period)
      .then((d) => {
        if (active) {
          setData(d);
          setLoading(false);
        }
      })
      .catch(() => {
        if (active) setLoading(false);
        toast.error("Could not load dashboard data.");
      });
    return () => {
      active = false;
    };
  }, [period]);

  if (loading || !data) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        <CircularProgress />
      </Box>
    );
  }

  const expensesPie: CategorySummary[] = data.expensesByCategory;
  const periodLabel =
    period.year == null
      ? "All time"
      : period.month == null
        ? `${period.year}`
        : new Date(2026, period.month - 1, 1).toLocaleString("en", {
            month: "long",
            year: "numeric",
          });

  return (
    <Stack spacing={3}>
      <Box
        sx={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          flexWrap: "wrap",
          gap: 2,
        }}
      >
        <Stack>
          <Typography variant="h5" sx={{ fontWeight: 700 }}>
            {periodLabel}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Income, spending and savings overview
          </Typography>
        </Stack>
        <PeriodSelector period={period} onChange={setPeriod} />
      </Box>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard
            title="Total balance"
            value={formatCurrency(data.totalBalance, currency)}
            icon={<AccountBalanceWalletIcon />}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard
            title="Income"
            value={formatCurrency(data.income, currency)}
            color="success.main"
            icon={<PayrollIcon />}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard
            title="Expenses"
            value={formatCurrency(data.expenses, currency)}
            icon={<ReceiptLongIcon />}
            sub={`${expensesPie.length} categories`}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard
            title="Savings"
            value={formatCurrency(data.savings, currency)}
            icon={<SavingsIcon />}
            sub={`${data.savingsRate.toFixed(1)}% savings rate`}
          />
        </Grid>
      </Grid>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 6 }}>
          <Card>
            <CardContent>
              <Typography variant="h6" sx={{ mb: 1 }}>
                Spending by category
              </Typography>
              <CategoryPie data={expensesPie} currency={currency} />
            </CardContent>
          </Card>
        </Grid>
        <Grid size={{ xs: 12, md: 6 }}>
          <Card>
            <CardContent>
              <Typography variant="h6" sx={{ mb: 1 }}>
                Monthly trend
              </Typography>
              <MonthlyTrendChart data={data.monthlyTrend} currency={currency} />
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Card>
        <CardContent>
          <Box sx={{ display: "flex", justifyContent: "space-between", mb: 1 }}>
            <Typography variant="h6">Recent transactions</Typography>
            <Typography
              component={Link}
              to="/transactions"
              variant="body2"
              color="primary"
              sx={{ textDecoration: "none" }}
            >
              View all
            </Typography>
          </Box>
          <List dense disablePadding>
            {data.recentTransactions.map((t, index) => (
              <Box key={t.id}>
                {index > 0 && <Divider component="li" />}
                <ListItem
                  sx={{ px: 0 }}
                  secondaryAction={
                    <Typography
                      variant="body2"
                      sx={{
                        fontWeight: 600,
                        color:
                          t.categoryType === CategoryType.Income
                            ? "success.main"
                            : "error.main",
                      }}
                    >
                      {t.categoryType === CategoryType.Income ? "+" : "−"}
                      {formatCurrency(t.amount, currency)}
                    </Typography>
                  }
                >
                  <ListItemText
                    primary={t.description || t.category}
                    secondary={`${formatDate(t.date)} · ${t.category} · ${t.account}`}
                  />
                </ListItem>
              </Box>
            ))}
          </List>
        </CardContent>
      </Card>
    </Stack>
  );
}