import { useState } from "react";
import {
  Box,
  Card,
  CardContent,
  CircularProgress,
  Grid,
  MenuItem,
  Stack,
  TextField,
  Typography,
} from "@mui/material";
import {
  Area,
  AreaChart,
  Bar,
  CartesianGrid,
  Cell,
  ComposedChart,
  Legend,
  Line,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { ToggleButton, ToggleButtonGroup } from "@mui/material";
import { useSettings } from "../../context/settings";
import { useApiData } from "../../hooks/useApiData";
import {
  getInvestmentAllocation,
  getInvestmentBenchmark,
  getInvestmentContributions,
  getInvestmentOverview,
  getInvestmentPerformance,
} from "../../services/investmentService";
import {
  formatCurrency,
  formatDate,
  monthLabel,
} from "../../utils/format";

const RANGES = ["1M", "3M", "YTD", "1Y", "ALL"];
const ALLOCATION_BY = ["type", "broker", "currency", "holding"];

interface StatCardProps {
  title: string;
  value: string;
  color?: string;
  sub?: string;
}

function StatCard({ title, value, color, sub }: StatCardProps) {
  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Stack spacing={1}>
          <Typography variant="body2" color="text.secondary">
            {title}
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 700, color: color ?? "text.primary" }}>
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

export default function OverviewTab() {
  const { convert, currency } = useSettings();
  const [range, setRange] = useState("1M");
  const [allocationBy, setAllocationBy] = useState("type");
  const [symbol, setSymbol] = useState("EQQQ.DE");

  const overview = useApiData(getInvestmentOverview, "invest-overview");
  const performance = useApiData(() => getInvestmentPerformance(range), `perf:${range}`);
  const allocation = useApiData(
    () => getInvestmentAllocation(allocationBy),
    `alloc:${allocationBy}`,
  );
  const contributions = useApiData(getInvestmentContributions, "invest-contrib");
  const benchmark = useApiData(
    () => getInvestmentBenchmark(range, symbol),
    `bench:${range}:${symbol}`,
  );

  if (overview.loading || !overview.data) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        {overview.error ? (
          <Typography color="text.secondary">Could not load portfolio overview.</Typography>
        ) : (
          <CircularProgress />
        )}
      </Box>
    );
  }

  const data = overview.data;
  const perfData = (performance.data?.dates ?? []).map((date, i) => ({
    date: formatDate(date),
    value: performance.data ? Number(performance.data.values[i]) : 0,
  }));
  const allocData = allocation.data ?? [];
  const contribData = (contributions.data ?? []).map((c) => ({
    label: monthLabel(c.year, c.month),
    Contributed: convert(c.contributed),
    Cumulative: convert(c.cumulative),
  }));
  const benchData = (benchmark.data?.dates ?? []).map((date, i) => ({
    date: formatDate(date),
    Portfolio: benchmark.data ? Number(benchmark.data.portfolio[i]) : 0,
    Benchmark: benchmark.data ? Number(benchmark.data.benchmark[i]) : 0,
  }));

  const profitPct =
    data.totalInvested > 0 ? ((data.profitLoss / data.totalInvested) * 100).toFixed(1) : "0.0";

  return (
    <Stack spacing={3}>
      <Grid container spacing={2}>
        <Grid size={{ xs: 12, sm: 6, md: 2 }}>
          <StatCard
            title="Portfolio value"
            value={formatCurrency(convert(data.totalValue), currency)}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 2 }}>
          <StatCard
            title="Invested"
            value={formatCurrency(convert(data.totalInvested), currency)}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 2 }}>
          <StatCard
            title="P&L"
            value={`${data.profitLoss >= 0 ? "+" : "−"}${formatCurrency(
              Math.abs(convert(data.profitLoss)),
              currency,
            )}`}
            color={data.profitLoss >= 0 ? "success.main" : "error.main"}
            sub={`${data.profitLoss >= 0 ? "+" : ""}${profitPct}%`}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 2 }}>
          <StatCard
            title="Realized gains"
            value={`${data.realizedGain >= 0 ? "+" : ""}${formatCurrency(
              convert(data.realizedGain),
              currency,
            )}`}
            color={data.realizedGain >= 0 ? "success.main" : "error.main"}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 2 }}>
          <StatCard
            title="Unrealized gains"
            value={`${data.unrealizedGain >= 0 ? "+" : ""}${formatCurrency(
              convert(data.unrealizedGain),
              currency,
            )}`}
            color={data.unrealizedGain >= 0 ? "success.main" : "error.main"}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 2 }}>
          <StatCard
            title="Cash"
            value={formatCurrency(convert(data.cashBalance), currency)}
            sub={`${data.holdingsCount} holdings · ${data.accountCount} broker`}
          />
        </Grid>
      </Grid>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 7 }}>
          <Card>
            <CardContent>
              <Box sx={{ display: "flex", alignItems: "center", justifyContent: "space-between", mb: 1 }}>
                <Typography variant="h6">Portfolio value</Typography>
                <ToggleButtonGroup
                  size="small"
                  exclusive
                  value={range}
                  onChange={(_, value) => value && setRange(value)}
                >
                  {RANGES.map((r) => (
                    <ToggleButton key={r} value={r}>
                      {r}
                    </ToggleButton>
                  ))}
                </ToggleButtonGroup>
              </Box>
              {performance.loading ? (
                <Box sx={{ display: "flex", justifyContent: "center", py: 8 }}>
                  <CircularProgress />
                </Box>
              ) : (
                <ResponsiveContainer width="100%" height={280}>
                  <AreaChart data={perfData} margin={{ top: 5, right: 10, left: 5, bottom: 5 }}>
                    <defs>
                      <linearGradient id="perfFill" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stopColor="#4F46E5" stopOpacity={0.35} />
                        <stop offset="100%" stopColor="#4F46E5" stopOpacity={0.02} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" strokeOpacity={0.3} />
                    <XAxis dataKey="date" tick={{ fontSize: 11 }} minTickGap={30} />
                    <YAxis tick={{ fontSize: 11 }} width={65} />
                    <Tooltip formatter={(value) => formatCurrency(Number(value), currency)} />
                    <Area
                      type="monotone"
                      dataKey="value"
                      name="Value"
                      stroke="#4F46E5"
                      strokeWidth={2}
                      fill="url(#perfFill)"
                    />
                  </AreaChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 5 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Box sx={{ display: "flex", alignItems: "center", justifyContent: "space-between", mb: 1 }}>
                <Typography variant="h6">Allocation</Typography>
                <TextField
                  select
                  size="small"
                  value={allocationBy}
                  onChange={(e) => setAllocationBy(e.target.value)}
                  sx={{ width: 130 }}
                >
                  {ALLOCATION_BY.map((b) => (
                    <MenuItem key={b} value={b}>
                      {b.charAt(0).toUpperCase() + b.slice(1)}
                    </MenuItem>
                  ))}
                </TextField>
              </Box>
              <ResponsiveContainer width="100%" height={280}>
                <PieChart>
                  <Pie
                    data={allocData.map((a) => ({ ...a, amount: convert(a.value) }))}
                    dataKey="amount"
                    nameKey="label"
                    innerRadius={55}
                    outerRadius={90}
                    paddingAngle={2}
                    strokeWidth={1}
                  >
                    {allocData.map((a) => (
                      <Cell key={a.label} fill={a.color} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value) => formatCurrency(Number(value), currency)} />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 6 }}>
          <Card>
            <CardContent>
              <Typography variant="h6" sx={{ mb: 1 }}>
                Contributions
              </Typography>
              <ResponsiveContainer width="100%" height={260}>
                <ComposedChart data={contribData} margin={{ top: 5, right: 10, left: 5, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" strokeOpacity={0.3} />
                  <XAxis dataKey="label" tick={{ fontSize: 11 }} />
                  <YAxis tick={{ fontSize: 11 }} width={60} />
                  <Tooltip formatter={(value) => formatCurrency(Number(value), currency)} />
                  <Legend />
                  <Bar dataKey="Contributed" fill="#26A69A" radius={[3, 3, 0, 0]} />
                  <Line
                    type="monotone"
                    dataKey="Cumulative"
                    stroke="#4F46E5"
                    strokeWidth={2}
                    dot={false}
                  />
                </ComposedChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 6 }}>
          <Card>
            <CardContent>
              <Box sx={{ display: "flex", alignItems: "center", justifyContent: "space-between", mb: 1 }}>
                <Typography variant="h6">Benchmark</Typography>
                <TextField
                  size="small"
                  label="Symbol"
                  value={symbol}
                  onChange={(e) => setSymbol(e.target.value.toUpperCase())}
                  sx={{ width: 130 }}
                />
              </Box>
              {benchmark.loading ? (
                <Box sx={{ display: "flex", justifyContent: "center", py: 8 }}>
                  <CircularProgress />
                </Box>
              ) : benchData.length === 0 ? (
                <Box sx={{ py: 8, textAlign: "center", color: "text.secondary" }}>
                  <Typography variant="body2">No benchmark data for {symbol || "this symbol"}</Typography>
                </Box>
              ) : (
                <ResponsiveContainer width="100%" height={260}>
                  <ComposedChart data={benchData} margin={{ top: 5, right: 10, left: 5, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" strokeOpacity={0.3} />
                    <XAxis dataKey="date" tick={{ fontSize: 11 }} minTickGap={30} />
                    <YAxis tick={{ fontSize: 11 }} width={50} domain={["auto", "auto"]} />
                    <Tooltip formatter={(value) => Number(value).toFixed(1)} />
                    <Legend />
                    <Line
                      type="monotone"
                      dataKey="Portfolio"
                      stroke="#4F46E5"
                      strokeWidth={2}
                      dot={false}
                    />
                    <Line
                      type="monotone"
                      dataKey="Benchmark"
                      stroke="#78909C"
                      strokeWidth={2}
                      dot={false}
                    />
                  </ComposedChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Stack>
  );
}