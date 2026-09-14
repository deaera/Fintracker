import { Box, Stack, Typography } from "@mui/material";
import { Cell, Pie, PieChart, ResponsiveContainer, Tooltip } from "recharts";
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

  const chartData = data.map((d) => ({ ...d, amount: convert(d.amount) }));
  const sorted = [...chartData].sort((a, b) => b.amount - a.amount);
  const total = chartData.reduce((sum, d) => sum + d.amount, 0);

  return (
    <Box>
      <Box sx={{ position: "relative", width: "100%", height: 240 }}>
        <ResponsiveContainer width="100%" height="100%">
          <PieChart margin={{ top: 4, right: 4, bottom: 4, left: 4 }}>
            <Pie
              data={chartData}
              dataKey="amount"
              nameKey="category"
              innerRadius="62%"
              outerRadius="86%"
              paddingAngle={2}
              cornerRadius={4}
              minAngle={2}
              stroke="none"
            >
              {chartData.map((entry) => (
                <Cell key={entry.category} fill={entry.color} />
              ))}
            </Pie>
            <Tooltip
              cursor={false}
              content={({ active, payload }) => {
                if (!active || !payload?.length) return null;
                const item = payload[0];
                const value = Number(item.value);
                const pct = total > 0 ? (value / total) * 100 : 0;
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
                      {item.name}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      {formatCurrency(value, currency)}{" "}
                      <Box component="span" sx={{ color: "text.disabled" }}>
                        · {pct.toFixed(1)}%
                      </Box>
                    </Typography>
                  </Box>
                );
              }}
            />
          </PieChart>
        </ResponsiveContainer>
        <Box
          sx={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            textAlign: "center",
            pointerEvents: "none",
            maxWidth: "70%",
          }}
        >
          <Typography
            variant="h6"
            noWrap
            sx={{ fontWeight: 800, lineHeight: 1.2, fontSize: 20 }}
          >
            {formatCurrency(total, currency)}
          </Typography>
          <Typography variant="caption" color="text.secondary">
            Total spent
          </Typography>
        </Box>
      </Box>

      <Stack spacing={0.75} sx={{ mt: 1.5, maxHeight: 150, overflowY: "auto", pr: 0.5 }}>
        {sorted.map((d) => {
          const pct = total > 0 ? (d.amount / total) * 100 : 0;
          return (
            <Box key={d.category} sx={{ display: "flex", alignItems: "center", gap: 1 }}>
              <Box
                sx={{
                  width: 10,
                  height: 10,
                  borderRadius: "50%",
                  flexShrink: 0,
                  bgcolor: d.color,
                }}
              />
              <Typography
                variant="caption"
                sx={{
                  flex: 1,
                  minWidth: 0,
                  whiteSpace: "nowrap",
                  overflow: "hidden",
                  textOverflow: "ellipsis",
                }}
              >
                {d.category}
              </Typography>
              <Typography variant="caption" color="text.secondary" sx={{ flexShrink: 0 }}>
                {formatCurrency(d.amount, currency)} · {pct.toFixed(1)}%
              </Typography>
            </Box>
          );
        })}
      </Stack>
    </Box>
  );
}