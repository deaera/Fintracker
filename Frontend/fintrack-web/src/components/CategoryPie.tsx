import { Box, Typography } from "@mui/material";
import { Cell, Legend, Pie, PieChart, ResponsiveContainer, Tooltip } from "recharts";
import type { CategorySummary } from "../types";
import { formatCurrency } from "../utils/format";
import { useSettings } from "../context/settings";

interface Props {
  data: CategorySummary[];
  currency: string;
}

export default function CategoryPie({ data, currency }: Props) {
  const { convert } = useSettings();

  if (data.length === 0) {
    return (
      <Box sx={{ py: 6, textAlign: "center", color: "text.secondary" }}>
        <Typography variant="body2">No expenses in this period</Typography>
      </Box>
    );
  }

  const total = data.reduce((sum, d) => sum + convert(d.amount), 0);

  return (
    <Box sx={{ position: "relative", width: "100%", height: 280 }}>
      <ResponsiveContainer width="100%" height={280}>
        <PieChart>
          <Pie
            data={data.map((d) => ({ ...d, amount: convert(d.amount) }))}
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
          <Tooltip formatter={(value) => formatCurrency(Number(value), currency)} />
          <Legend />
        </PieChart>
      </ResponsiveContainer>
      <Box
        sx={{
          position: "absolute",
          top: "47%",
          left: "50%",
          transform: "translate(-50%, -55%)",
          textAlign: "center",
          pointerEvents: "none",
        }}
      >
        <Typography variant="h6" sx={{ fontWeight: 800, lineHeight: 1.2 }}>
          {formatCurrency(total, currency)}
        </Typography>
        <Typography variant="caption" color="text.secondary">
          Total spend
        </Typography>
      </Box>
    </Box>
  );
}