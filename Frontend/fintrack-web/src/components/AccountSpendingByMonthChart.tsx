import { useMemo, useState } from "react";
import {
  Box,
  FormControl,
  InputLabel,
  MenuItem,
  Select,
  Stack,
  Typography,
} from "@mui/material";
import {
  Bar,
  CartesianGrid,
  ComposedChart,
  Line,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import type { AccountCategoryMonthly, AccountMonthlySpending, Period } from "../types";
import { CategoryType } from "../types";
import { formatCurrency, monthLabel } from "../utils/format";
import { useSettings } from "../context/settings";

interface Props {
  data: AccountMonthlySpending[];
  categoryData: AccountCategoryMonthly[];
  currency: string;
  period: Period;
  onPeriodChange?: (period: Period) => void;
}

type ViewType = "expense" | "income" | "net";
type GroupBy = "account" | "category";

const MONTHS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

function formatCompact(value: number): string {
  const abs = Math.abs(value);
  if (abs >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (abs >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return `${Math.round(value)}`;
}

function LegendItem({ color, label }: { color: string; label: string }) {
  return (
    <Box sx={{ display: "flex", alignItems: "center", gap: 0.75 }}>
      <Box
        sx={{
          width: 10,
          height: 10,
          borderRadius: "50%",
          bgcolor: color,
          flexShrink: 0,
        }}
      />
      <Typography variant="caption">{label}</Typography>
    </Box>
  );
}

function getYears(data: { year: number }[]): number[] {
  const set = new Set<number>();
  data.forEach((d) => set.add(d.year));
  return Array.from(set).sort();
}

export default function AccountSpendingByMonthChart({
  data,
  categoryData,
  currency,
  period,
  onPeriodChange,
}: Props) {
  const { convert } = useSettings();
  const [accountId, setAccountId] = useState<string>("all");
  const [view, setView] = useState<ViewType>("expense");
  const [groupBy, setGroupBy] = useState<GroupBy>("account");
  const [categoryFilter, setCategoryFilter] = useState<string>("all");

  const accounts = useMemo(() => {
    const map = new Map<string, string>();
    data.forEach((d) => {
      if (!map.has(d.accountId)) map.set(d.accountId, d.accountName);
    });
    return Array.from(map.entries()).map(([id, name]) => ({ id, name }));
  }, [data]);

  const years = useMemo(() => getYears(data), [data]);
  const activeYear = period.year ?? years[0] ?? new Date().getFullYear();
  const monthFilter = period.month;

  const viewType =
    view === "income" ? CategoryType.Income : view === "expense" ? CategoryType.Expense : null;

  const categories = useMemo(() => {
    const map = new Map<string, { name: string; color: string }>();
    categoryData
      .filter((c) => c.accountId === (accountId === "all" ? c.accountId : accountId))
      .filter((c) => (viewType == null ? true : c.categoryType === viewType))
      .forEach((c) => {
        if (!map.has(c.categoryName)) map.set(c.categoryName, { name: c.categoryName, color: c.categoryColor });
      });
    return Array.from(map.values()).sort((a, b) => a.name.localeCompare(b.name));
  }, [categoryData, accountId, viewType]);

  const chartPoints = useMemo(() => {
    const baseMonths = monthFilter != null ? [monthFilter] : MONTHS;

    if (groupBy === "category") {
      const included = categories.filter(
        (c) => categoryFilter === "all" || c.name === categoryFilter,
      );

      return baseMonths.map((m) => {
        const rows = categoryData.filter(
          (c) =>
            c.year === activeYear &&
            c.month === m &&
            (accountId === "all" || c.accountId === accountId) &&
            (viewType == null || c.categoryType === viewType),
        );
        const point: Record<string, number | string> = { label: monthLabel(activeYear, m) };
        included.forEach((c) => {
          point[c.name] = rows
            .filter((r) => r.categoryName === c.name)
            .reduce((sum, r) => sum + convert(r.amount), 0);
        });
        return point;
      });
    }

    return baseMonths.map((m) => {
      const monthData = data.filter(
        (d) =>
          d.year === activeYear &&
          d.month === m &&
          (accountId === "all" || d.accountId === accountId),
      );
      const incomeSum = monthData.reduce((sum, d) => sum + convert(d.income), 0);
      const expenseSum = monthData.reduce((sum, d) => sum + convert(d.expenses), 0);
      return {
        label: monthLabel(activeYear, m),
        Income: incomeSum,
        Expenses: expenseSum,
        Net: incomeSum - expenseSum,
      };
    });
  }, [data, categoryData, categories, groupBy, categoryFilter, activeYear, monthFilter, accountId, viewType, convert]);

  const hasData = data.length > 0 || categoryData.length > 0;

  if (!hasData) {
    return (
      <Box sx={{ py: 6, textAlign: "center", color: "text.secondary" }}>
        <Typography variant="body2">No account spending data</Typography>
      </Box>
    );
  }

  return (
    <Box>
      <Stack
        direction={{ xs: "column", sm: "row" }}
        spacing={2}
        sx={{ mb: 2, alignItems: { sm: "center" }, justifyContent: "space-between", flexWrap: "wrap" }}
      >
        <Stack direction={{ xs: "column", sm: "row" }} spacing={2} sx={{ alignItems: "center", flexWrap: "wrap" }}>
          <FormControl size="small" sx={{ minWidth: 150 }}>
            <InputLabel>Account</InputLabel>
            <Select value={accountId} label="Account" onChange={(e) => setAccountId(e.target.value)}>
              <MenuItem value="all">All accounts</MenuItem>
              {accounts.map((a) => (
                <MenuItem key={a.id} value={a.id}>
                  {a.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <FormControl size="small" sx={{ minWidth: 120 }}>
            <InputLabel>Group by</InputLabel>
            <Select
              value={groupBy}
              label="Group by"
              onChange={(e) => {
                const value = e.target.value as GroupBy;
                setGroupBy(value);
                if (value === "category" && view === "net") setView("expense");
              }}
            >
              <MenuItem value="account">Account</MenuItem>
              <MenuItem value="category">Expense type</MenuItem>
            </Select>
          </FormControl>

          <FormControl size="small" sx={{ minWidth: 120 }}>
            <InputLabel>Type</InputLabel>
            <Select value={view} label="Type" onChange={(e) => setView(e.target.value as ViewType)}>
              <MenuItem value="expense">Expenses</MenuItem>
              <MenuItem value="income">Income</MenuItem>
              {groupBy === "account" && <MenuItem value="net">Net</MenuItem>}
            </Select>
          </FormControl>

          {groupBy === "category" && (
            <FormControl size="small" sx={{ minWidth: 150 }}>
              <InputLabel>Category</InputLabel>
              <Select
                value={categoryFilter}
                label="Category"
                onChange={(e) => setCategoryFilter(e.target.value)}
              >
                <MenuItem value="all">All categories</MenuItem>
                {categories.map((c) => (
                  <MenuItem key={c.name} value={c.name}>
                    {c.name}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          )}

          {onPeriodChange && (
            <Stack direction="row" spacing={1} sx={{ alignItems: "center", flexWrap: "wrap" }}>
              <FormControl size="small" sx={{ minWidth: 90 }}>
                <InputLabel>Year</InputLabel>
                <Select
                  value={activeYear}
                  label="Year"
                  onChange={(e) => onPeriodChange({ month: monthFilter, year: Number(e.target.value) })}
                >
                  {years.map((y) => (
                    <MenuItem key={y} value={y}>
                      {y}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
              <FormControl size="small" sx={{ minWidth: 110 }}>
                <InputLabel>Month</InputLabel>
                <Select
                  value={monthFilter ?? "all"}
                  label="Month"
                  onChange={(e) => {
                    const value = e.target.value;
                    onPeriodChange({ month: value === "all" ? null : Number(value), year: activeYear });
                  }}
                >
                  <MenuItem value="all">All months</MenuItem>
                  {MONTHS.map((m) => (
                    <MenuItem key={m} value={m}>
                      {monthLabel(activeYear, m)}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Stack>
          )}
        </Stack>

        <Stack direction="row" spacing={2} sx={{ flexWrap: "wrap" }}>
          {groupBy === "account" ? (
            <>
              {view !== "income" && <LegendItem color="#EF5350" label="Expenses" />}
              {view !== "expense" && <LegendItem color="#4CAF50" label="Income" />}
              {view === "net" && <LegendItem color="#26A69A" label="Net" />}
            </>
          ) : (
            categories
              .filter((c) => categoryFilter === "all" || c.name === categoryFilter)
              .map((c) => <LegendItem key={c.name} color={c.color} label={c.name} />)
          )}
        </Stack>
      </Stack>

      <ResponsiveContainer width="100%" height={280}>
        <ComposedChart data={chartPoints} margin={{ top: 5, right: 10, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" strokeOpacity={0.3} vertical={false} />
          <XAxis
            dataKey="label"
            tick={{ fontSize: 12 }}
            interval="preserveStartEnd"
            minTickGap={16}
            axisLine={false}
            tickLine={false}
          />
          <YAxis
            tick={{ fontSize: 12 }}
            width={52}
            tickFormatter={formatCompact}
            axisLine={false}
            tickLine={false}
          />
          <Tooltip
            cursor={{ fill: "rgba(0,0,0,0.04)" }}
            content={({ active, payload }) => {
              if (!active || !payload?.length) return null;
              const point = payload[0].payload as Record<string, number | string>;
              const rows =
                groupBy === "category"
                  ? categories
                      .filter((c) => categoryFilter === "all" || c.name === categoryFilter)
                      .map((c) => ({ label: c.name, color: c.color, value: Number(point[c.name] ?? 0) }))
                      .filter((r) => r.value !== 0)
                  : [
                      { label: "Income", color: "#4CAF50", value: Number(point.Income ?? 0) },
                      { label: "Expenses", color: "#EF5350", value: Number(point.Expenses ?? 0) },
                      ...(view === "net"
                        ? [{ label: "Net", color: "#26A69A", value: Number(point.Net ?? 0) }]
                        : []),
                    ].filter((r) => view === "net" || r.label.toLowerCase().startsWith(view === "income" ? "inc" : "exp"));

              return (
                <Box
                  sx={{
                    bgcolor: "background.paper",
                    border: "1px solid",
                    borderColor: "divider",
                    borderRadius: 2,
                    px: 1.5,
                    py: 1,
                    boxShadow: 3,
                    maxHeight: 260,
                    overflowY: "auto",
                  }}
                >
                  <Typography variant="body2" sx={{ fontWeight: 700 }}>
                    {point.label}
                  </Typography>
                  {rows.map((r) => (
                    <Box key={r.label} sx={{ display: "flex", justifyContent: "space-between", gap: 2 }}>
                      <Typography variant="caption" sx={{ color: r.color }}>
                        {r.label}
                      </Typography>
                      <Typography variant="caption" sx={{ fontWeight: 600 }}>
                        {formatCurrency(r.value, currency)}
                      </Typography>
                    </Box>
                  ))}
                  {rows.length === 0 && (
                    <Typography variant="caption" color="text.secondary">
                      No data
                    </Typography>
                  )}
                </Box>
              );
            }}
          />

          {groupBy === "account" ? (
            <>
              {(view === "expense" || view === "net") && (
                <Bar dataKey="Expenses" fill="#EF5350" radius={[3, 3, 0, 0]} maxBarSize={16} />
              )}
              {(view === "income" || view === "net") && (
                <Bar dataKey="Income" fill="#4CAF50" radius={[3, 3, 0, 0]} maxBarSize={16} />
              )}
              {view === "net" && (
                <Line
                  dataKey="Net"
                  type="monotone"
                  stroke="#26A69A"
                  strokeWidth={2.5}
                  dot={{ r: 3, fill: "#26A69A", strokeWidth: 0 }}
                  activeDot={{ r: 5 }}
                />
              )}
            </>
          ) : (
            categories
              .filter((c) => categoryFilter === "all" || c.name === categoryFilter)
              .map((c) => (
                <Bar
                  key={c.name}
                  dataKey={c.name}
                  name={c.name}
                  stackId="categories"
                  fill={c.color}
                  maxBarSize={28}
                />
              ))
          )}
        </ComposedChart>
      </ResponsiveContainer>
    </Box>
  );
}