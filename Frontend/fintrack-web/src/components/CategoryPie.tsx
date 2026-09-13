import { Box, Typography } from "@mui/material";
import { Cell, Legend, Pie, PieChart, ResponsiveContainer, Tooltip } from "recharts";
import type { CategorySummary } from "../types";
import { formatCurrency } from "../utils/format";

interface Props {
  data: CategorySummary[];
  currency: string;
}

export default function CategoryPie({ data, currency }: Props) {
  if (data.length === 0) {
    return (
      <Box sx={{ py: 6, textAlign: "center", color: "text.secondary" }}>
        <Typography variant="body2">No expenses in this period</Typography>
      </Box>
    );
  }

  return (
    <ResponsiveContainer width="100%" height={280}>
      <PieChart>
        <Pie
          data={data}
          dataKey="amount"
          nameKey="category"
          innerRadius={55}
          outerRadius={95}
          paddingAngle={2}
          strokeWidth={1}
        >
          {data.map((entry) => (
            <Cell key={entry.category} fill={entry.color} />
          ))}
        </Pie>
        <Tooltip
          formatter={(value) => formatCurrency(Number(value), currency)}
        />
        <Legend />
      </PieChart>
    </ResponsiveContainer>
  );
}