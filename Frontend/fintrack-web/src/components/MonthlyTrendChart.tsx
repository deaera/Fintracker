import { Box, Divider, Stack, Typography } from "@mui/material";
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
import type { MonthlyTrend } from "../types";
import { formatCurrency, monthLabel } from "../utils/format";
import { useSettings } from "../context/settings";

interface Props {
  data: MonthlyTrend[];
  currency: string;
}

const COLORS = {
  income: "#4CAF50",
  expenses: "#EF5350",
  savings: "#26A69A",
} as const;

function formatCompact(value: number): string {
  const abs = Math.abs(value);
  if (abs >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (abs >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return `${Math.round(value)}`;
}

interface LegendItemProps {
  color: string;
  label: string;
}

function LegendItem({ color, label }: LegendItemProps) {
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

export default function MonthlyTrendChart({ data, currency }: Props) {
  const { convert } = useSettings();

  const chartData = data.map((m) => ({
    label: monthLabel(m.year, m.month),
    Income: convert(m.income),
    Expenses: convert(m.expenses),
    Savings: convert(m.savings),
  }));

  if (chartData.length === 0) {
    return (
      <Box sx={{ py: 6, textAlign: "center", color: "text.secondary" }}>
        <Typography variant="body2">No data available</Typography>
      </Box>
    );
  }

  return (
    <Box>
      <Stack direction="row" spacing={2} sx={{ mb: 1 }}>
        <LegendItem color={COLORS.income} label="Income" />
        <LegendItem color={COLORS.expenses} label="Expenses" />
        <LegendItem color={COLORS.savings} label="Savings" />
      </Stack>

      <ResponsiveContainer width="100%" height={260}>
        <ComposedChart data={chartData} margin={{ top: 5, right: 10, left: 0, bottom: 0 }}>
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
              const point = payload[0].payload as {
                label: string;
                Income: number;
                Expenses: number;
                Savings: number;
              };
              const income = Number(point.Income ?? 0);
              const expenses = Number(point.Expenses ?? 0);
              const savings = Number(point.Savings ?? 0);
              const rate = income > 0 ? (savings / income) * 100 : 0;
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
                  }}
                >
                  <Typography variant="body2" sx={{ fontWeight: 700 }}>
                    {point.label}
                  </Typography>
                  <Box sx={{ display: "flex", justifyContent: "space-between", gap: 2 }}>
                    <Typography variant="caption" sx={{ color: COLORS.income }}>
                      Income
                    </Typography>
                    <Typography variant="caption" sx={{ fontWeight: 600 }}>
                      {formatCurrency(income, currency)}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", justifyContent: "space-between", gap: 2 }}>
                    <Typography variant="caption" sx={{ color: COLORS.expenses }}>
                      Expenses
                    </Typography>
                    <Typography variant="caption" sx={{ fontWeight: 600 }}>
                      −{formatCurrency(expenses, currency)}
                    </Typography>
                  </Box>
                  <Divider sx={{ my: 0.75 }} />
                  <Box sx={{ display: "flex", justifyContent: "space-between", gap: 2 }}>
                    <Typography variant="caption" sx={{ color: COLORS.savings }}>
                      Savings
                    </Typography>
                    <Typography variant="caption" sx={{ fontWeight: 700 }}>
                      {formatCurrency(savings, currency)} · {rate.toFixed(1)}%
                    </Typography>
                  </Box>
                </Box>
              );
            }}
          />
          <Bar dataKey="Income" fill={COLORS.income} radius={[3, 3, 0, 0]} maxBarSize={16} />
          <Bar dataKey="Expenses" fill={COLORS.expenses} radius={[3, 3, 0, 0]} maxBarSize={16} />
          <Line
            dataKey="Savings"
            type="monotone"
            stroke={COLORS.savings}
            strokeWidth={2.5}
            dot={{ r: 3, fill: COLORS.savings, strokeWidth: 0 }}
            activeDot={{ r: 5 }}
          />
        </ComposedChart>
      </ResponsiveContainer>
    </Box>
  );
}