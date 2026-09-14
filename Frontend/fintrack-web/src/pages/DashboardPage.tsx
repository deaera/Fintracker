import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import {
  Box,
  Card,
  CardContent,
  Divider,
  Grid,
  LinearProgress,
  List,
  ListItem,
  ListItemText,
  Stack,
  Typography,
} from "@mui/material";
import { alpha, useTheme } from "@mui/material/styles";
import AccountBalanceWalletIcon from "@mui/icons-material/AccountBalanceWallet";
import PayrollIcon from "@mui/icons-material/Payments";
import ReceiptLongIcon from "@mui/icons-material/ReceiptLong";
import SavingsIcon from "@mui/icons-material/Savings";
import TrendingUpIcon from "@mui/icons-material/TrendingUp";
import AccountBalanceIcon from "@mui/icons-material/AccountBalance";
import ArrowForwardIosIcon from "@mui/icons-material/ArrowForwardIos";
import CategoryPie from "../components/CategoryPie";
import MonthlyTrendChart from "../components/MonthlyTrendChart";
import PeriodSelector from "../components/PeriodSelector";
import LoadingSkeleton from "../components/LoadingSkeleton";
import { useSettings, DISPLAY_CURRENCIES } from "../context/settings";
import { useApiData } from "../hooks/useApiData";
import { getDashboard } from "../services/dashboardService";
import type { CategorySummary, Period } from "../types";
import { CategoryType } from "../types";
import { formatCurrency, formatDate } from "../utils/format";

interface StatCardProps {
  title: string;
  value: string;
  icon: React.ReactNode;
  color?: string;
  sub?: string;
  to?: string;
}

function StatCard({ title, value, icon, color, sub, to }: StatCardProps) {
  const theme = useTheme();
  const navigate = useNavigate();
  const accent =
    color === "success.main"
      ? theme.palette.success.main
      : color === "primary.main"
        ? theme.palette.primary.main
        : color === "error.main"
          ? theme.palette.error.main
          : theme.palette.action.active;

  return (
    <Card
      sx={{
        height: "100%",
        cursor: to ? "pointer" : "default",
        transition: "transform 140ms ease, box-shadow 140ms ease",
        ...(to
          ? {
              "&:hover": {
                transform: "translateY(-3px)",
                boxShadow: theme.shadows[5],
                borderColor: "primary.main",
              },
            }
          : {}),
      }}
      onClick={to ? () => navigate(to) : undefined}
    >
      <CardContent sx={{ p: 2.5, height: "100%" }}>
        <Stack spacing={1.5}>
          <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
            <Box
              sx={{
                width: 40,
                height: 40,
                borderRadius: 2,
                display: "grid",
                placeItems: "center",
                bgcolor: alpha(accent, 0.12),
                color: accent,
              }}
            >
              {icon}
            </Box>
            {to && (
              <ArrowForwardIosIcon sx={{ fontSize: 14, color: "text.disabled", mt: 0.5 }} />
            )}
          </Box>
          <Box>
            <Typography variant="body2" color="text.secondary" sx={{ fontWeight: 600 }}>
              {title}
            </Typography>
            <Typography
              variant="h5"
              sx={{
                fontWeight: 800,
                color: color ?? "text.primary",
                mt: 0.25,
                overflowWrap: "anywhere",
                whiteSpace: "normal",
              }}
            >
              {value}
            </Typography>
          </Box>
          {sub && (
            <Typography
              variant="caption"
              color="text.secondary"
              sx={{ overflowWrap: "anywhere" }}
            >
              {sub}
            </Typography>
          )}
        </Stack>
      </CardContent>
    </Card>
  );
}

export default function DashboardPage() {
  const { currency, convert, convertFrom, convertTo } = useSettings();
  const [period, setPeriod] = useState<Period>(() => {
    const now = new Date();
    return { year: now.getFullYear(), month: now.getMonth() + 1 };
  });
  const { data, loading, error } = useApiData(
    () => getDashboard(period),
    `${period.year ?? "alltime"}:${period.month ?? "all"}`,
  );

  if (loading || !data) {
    return error ? (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        <Typography color="text.secondary">Could not load dashboard data.</Typography>
      </Box>
    ) : (
      <LoadingSkeleton />
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
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard
            title="Total balance"
            value={formatCurrency(convert(data.totalBalance), currency)}
            icon={<AccountBalanceWalletIcon />}
            sub={DISPLAY_CURRENCIES.filter((c) => c !== currency)
              .map((c) => formatCurrency(convertTo(data.totalBalance, c), c))
              .join("  ·  ")}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard
            title="Investments"
            value={formatCurrency(convert(data.investmentValue), currency)}
            icon={<TrendingUpIcon />}
            sub={`${data.investmentValue > 0 ? "Portfolio value" : "No holdings yet"}`}
            to="/investments"
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard
            title="Net worth"
            value={formatCurrency(convert(data.netWorth), currency)}
            color="primary.main"
            icon={<AccountBalanceIcon />}
            sub={
              data.creditDebt > 0
                ? `Cash + investments − ${formatCurrency(convert(data.creditDebt), currency)} debt`
                : "Cash + investments"
            }
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard
            title="Income"
            value={formatCurrency(convert(data.income), currency)}
            color="success.main"
            icon={<PayrollIcon />}
            to="/transactions"
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard
            title="Expenses"
            value={formatCurrency(convert(data.expenses), currency)}
            icon={<ReceiptLongIcon />}
            sub={`${expensesPie.length} categories`}
            to="/transactions"
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard
            title="Savings"
            value={formatCurrency(convert(data.savings), currency)}
            icon={<SavingsIcon />}
            sub={`${data.savingsRate.toFixed(1)}% savings rate`}
            to="/transactions"
          />
        </Grid>
      </Grid>

      <Card>
        <CardContent>
          <Typography variant="h6" sx={{ mb: 2 }}>
            Credit cards
          </Typography>
          {data.creditCards.length === 0 ? (
            <Typography variant="body2" color="text.secondary">
              No credit cards yet — add one from Settings.
            </Typography>
          ) : (
            <Grid container spacing={2}>
              {data.creditCards.map((card) => {
                const usedPct =
                  card.creditLimit > 0
                    ? Math.min(100, (card.outstandingBalance / card.creditLimit) * 100)
                    : 0;
                return (
                  <Grid key={card.id} size={{ xs: 12, md: 6 }}>
                    <Box
                      sx={{
                        border: "1px solid",
                        borderColor: "divider",
                        borderRadius: 2,
                        p: 2,
                        display: "flex",
                        flexDirection: "column",
                        gap: 1,
                      }}
                    >
                      <Box
                        sx={{
                          display: "flex",
                          justifyContent: "space-between",
                          alignItems: "center",
                        }}
                      >
                        <Typography variant="body2" sx={{ fontWeight: 700 }}>
                          {card.name}
                        </Typography>
                        <Typography
                          variant="caption"
                          sx={{ color: "text.secondary", fontWeight: 600 }}
                        >
                          avail {formatCurrency(card.availableCredit, card.currency)}
                        </Typography>
                      </Box>
                      <LinearProgress
                        variant="determinate"
                        value={usedPct}
                        color={usedPct > 80 ? "error" : usedPct > 50 ? "warning" : "primary"}
                        sx={{ borderRadius: 1, height: 6 }}
                      />
                      <Box
                        sx={{
                          display: "flex",
                          justifyContent: "space-between",
                          flexWrap: "wrap",
                          rowGap: 0.5,
                        }}
                      >
                        <Typography variant="caption" color="text.secondary">
                          Used {formatCurrency(card.outstandingBalance, card.currency)} of{" "}
                          {formatCurrency(card.creditLimit, card.currency)}
                        </Typography>
                        <Typography variant="caption" color="error" sx={{ fontWeight: 600 }}>
                          −{formatCurrency(convert(card.debtInEur), currency)} net worth
                        </Typography>
                      </Box>
                      <Box sx={{ display: "flex", flexDirection: "column", gap: 0.25 }}>
                        <Typography variant="caption" color="text.secondary">
                          Payment:{" "}
                          <Box component="span" sx={{ fontWeight: 600, color: "text.primary" }}>
                            {card.monthlyPayment != null
                              ? `${formatCurrency(card.monthlyPayment, card.currency)}/mo`
                              : "—"}
                          </Box>
                          {card.remainingPayments != null &&
                            card.installmentMonths != null &&
                            ` · ${card.remainingPayments} of ${card.installmentMonths} installments left`}
                        </Typography>
                        {(card.monthlyInterestRate != null || card.annualFee != null) && (
                          <Typography variant="caption" color="text.secondary">
                            {card.monthlyInterestRate != null &&
                              `${card.monthlyInterestRate}% interest/mo`}
                            {card.monthlyInterestRate != null && card.annualFee != null && " · "}
                            {card.annualFee != null &&
                              `${formatCurrency(card.annualFee, card.currency)} annual fee`}
                          </Typography>
                        )}
                      </Box>
                    </Box>
                  </Grid>
                );
              })}
            </Grid>
          )}
        </CardContent>
      </Card>

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
                            : t.categoryType === CategoryType.Transfer
                              ? "text.secondary"
                              : "error.main",
                      }}
                    >
                      {t.categoryType === CategoryType.Income
                        ? "+"
                        : t.categoryType === CategoryType.Transfer
                          ? "⇄ "
                          : "−"}
                      {formatCurrency(convert(convertFrom(t.amount, t.currency)), currency)}
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