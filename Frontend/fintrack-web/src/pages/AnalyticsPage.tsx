import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import {
  Box,
  Card,
  CardContent,
  CircularProgress,
  Grid,
  LinearProgress,
  Stack,
  Typography,
} from "@mui/material";
import { Bar, BarChart, CartesianGrid, Cell, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import MonthlyTrendChart from "../components/MonthlyTrendChart";
import PeriodSelector from "../components/PeriodSelector";
import { useSettings } from "../context/SettingsContext";
import { getAnalytics } from "../services/analyticsService";
import type { Analytics, Period } from "../types";
import { formatCurrency, monthLabel, monthName } from "../utils/format";

function StatCard({ title, value, sub, color }: { title: string; value: string; sub?: string; color?: string }) {
  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Typography variant="body2" color="text.secondary">
          {title}
        </Typography>
        <Typography variant="h5" sx={{ fontWeight: 700, mt: 0.5, color: color ?? "text.primary" }}>
          {value}
        </Typography>
        {sub && (
          <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
            {sub}
          </Typography>
        )}
      </CardContent>
    </Card>
  );
}

export default function AnalyticsPage() {
  const { currency } = useSettings();
  const [period, setPeriod] = useState<Period>({ month: null, year: null });
  const [data, setData] = useState<Analytics | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    setLoading(true);
    getAnalytics(period)
      .then((d) => {
        if (active) {
          setData(d);
          setLoading(false);
        }
      })
      .catch(() => {
        if (active) setLoading(false);
        toast.error("Could not load analytics data.");
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

  const topCategories = data.expenseBreakdown.slice(0, 5);

  const breakdownData = data.expenseBreakdown.map((c) => ({
    name: c.category,
    amount: c.amount,
    percentage: c.percentage,
    color: c.color,
  }));

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
        <Box>
          <Typography variant="h5" sx={{ fontWeight: 700 }}>
            Analytics
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Category breakdowns and spending averages
          </Typography>
        </Box>
        <PeriodSelector period={period} onChange={setPeriod} />
      </Box>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard title="Total income" value={formatCurrency(data.totalIncome, currency)} color="success.main" />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard title="Total expenses" value={formatCurrency(data.totalExpenses, currency)} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4 }}>
          <StatCard
            title="Net savings"
            value={formatCurrency(data.savings, currency)}
            sub={`${data.savingsRate.toFixed(1)}% savings rate`}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 6 }}>
          <StatCard
            title="Average monthly spending"
            value={formatCurrency(data.averageMonthlySpending, currency)}
            sub={data.monthCount > 0 ? `across ${data.monthCount} month${data.monthCount > 1 ? "s" : ""} with activity` : "no data yet"}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 6 }}>
          <StatCard
            title="Best month"
            value={
              data.bestMonth
                ? monthLabel(data.bestMonth.year, data.bestMonth.month)
                : "—"
            }
            sub={
              data.bestMonth
                ? `${monthName(data.bestMonth.month)} saved ${formatCurrency(data.bestMonth.savings, currency)}`
                : undefined
            }
          />
        </Grid>
      </Grid>

      <Card>
        <CardContent>
          <Typography variant="h6" sx={{ mb: 1 }}>
            Income vs expenses by month
          </Typography>
          <MonthlyTrendChart data={data.monthly} currency={currency} />
        </CardContent>
      </Card>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 6 }}>
          <Card>
            <CardContent>
              <Typography variant="h6" sx={{ mb: 1 }}>
                Spending by category
              </Typography>
              <ResponsiveContainer width="100%" height={Math.max(240, breakdownData.length * 36)}>
                <BarChart
                  data={breakdownData}
                  layout="vertical"
                  margin={{ top: 5, right: 40, left: 30, bottom: 5 }}
                >
                  <CartesianGrid strokeDasharray="3 3" strokeOpacity={0.3} horizontal={false} />
                  <XAxis type="number" tick={{ fontSize: 12 }} />
                  <YAxis
                    type="category"
                    dataKey="name"
                    tick={{ fontSize: 12 }}
                    width={90}
                  />
                  <Tooltip
                    formatter={(value) => formatCurrency(Number(value), currency)}
                  />
                  <Bar dataKey="amount" name="Amount" radius={[0, 4, 4, 0]}>
                    {breakdownData.map((entry) => (
                      <Cell key={entry.name} fill={entry.color} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 6 }}>
          <Stack spacing={2}>
            <Card>
              <CardContent>
                <Typography variant="h6" sx={{ mb: 1.5 }}>
                  Highest spend categories
                </Typography>
                <Stack spacing={2}>
                  {topCategories.map((c) => (
                    <Box key={c.category}>
                      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 0.5 }}>
                        <Typography variant="body2">
                          {c.category}
                        </Typography>
                        <Typography variant="body2" sx={{ fontWeight: 600 }}>
                          {formatCurrency(c.amount, currency)}{" "}
                          <Box component="span" color="text.secondary">
                            · {c.percentage.toFixed(1)}%
                          </Box>
                        </Typography>
                      </Box>
                      <LinearProgress
                        variant="determinate"
                        value={c.percentage}
                        sx={{
                          height: 8,
                          borderRadius: 2,
                          [`& .MuiLinearProgress-bar`]: { bgcolor: c.color },
                        }}
                      />
                    </Box>
                  ))}
                  {topCategories.length === 0 && (
                    <Typography variant="body2" color="text.secondary">
                      No expense data in this period.
                    </Typography>
                  )}
                </Stack>
              </CardContent>
            </Card>

            <Card>
              <CardContent>
                <Typography variant="h6" sx={{ mb: 1.5 }}>
                  Income sources
                </Typography>
                <Stack spacing={1.5}>
                  {data.incomeBreakdown.map((c) => (
                    <Box
                      key={c.category}
                      sx={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}
                    >
                      <Typography variant="body2">{c.category}</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 600, color: "success.main" }}>
                        {formatCurrency(c.amount, currency)}{" "}
                        <Box component="span" color="text.secondary" sx={{ fontWeight: 400 }}>
                          ({c.percentage.toFixed(1)}%)
                        </Box>
                      </Typography>
                    </Box>
                  ))}
                  {data.incomeBreakdown.length === 0 && (
                    <Typography variant="body2" color="text.secondary">
                      No income data in this period.
                    </Typography>
                  )}
                </Stack>
              </CardContent>
            </Card>
          </Stack>
        </Grid>
      </Grid>
    </Stack>
  );
}