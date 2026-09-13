import { Box, Typography } from "@mui/material";
import {
  Bar,
  CartesianGrid,
  ComposedChart,
  Legend,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import type { MonthlyTrend } from "../types";
import { formatCurrency, monthLabel } from "../utils/format";

interface Props {
  data: MonthlyTrend[];
  currency: string;
}

export default function MonthlyTrendChart({ data, currency }: Props) {
  const chartData = data.map((m) => ({
    label: monthLabel(m.year, m.month),
    Income: m.income,
    Expenses: m.expenses,
    Savings: m.savings,
  }));

  if (chartData.length === 0) {
    return (
      <Box sx={{ py: 6, textAlign: "center", color: "text.secondary" }}>
        <Typography variant="body2">No data available</Typography>
      </Box>
    );
  }

  return (
    <ResponsiveContainer width="100%" height={280}>
      <ComposedChart data={chartData} margin={{ top: 5, right: 10, left: 5, bottom: 5 }}>
        <CartesianGrid strokeDasharray="3 3" strokeOpacity={0.3} />
        <XAxis dataKey="label" tick={{ fontSize: 12 }} />
        <YAxis tick={{ fontSize: 12 }} width={60} />
        <Tooltip formatter={(value) => formatCurrency(Number(value), currency)} />
        <Legend />
        <Bar dataKey="Income" fill="#4CAF50" radius={[3, 3, 0, 0]} />
        <Bar dataKey="Expenses" fill="#EF5350" radius={[3, 3, 0, 0]} />
        <Bar dataKey="Savings" fill="#26A69A" radius={[3, 3, 0, 0]} />
      </ComposedChart>
    </ResponsiveContainer>
  );
}