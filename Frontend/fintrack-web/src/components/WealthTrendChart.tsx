import { Box, Divider, Stack, Typography } from "@mui/material";
import {
  Area,
  AreaChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import type { WealthPoint } from "../types";
import { formatCurrency, monthLabel } from "../utils/format";
import { useSettings } from "../context/settings";

interface Props {
  data: WealthPoint[];
  currency: string;
}

const COLORS = {
  netWorth: "#4F46E5",
  totalBalance: "#26A69A",
  investments: "#FFB300",
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

function toEur(data: WealthPoint[], convert: (v: number) => number) {
  return data.map((p) => ({
    label: monthLabel(p.year, p.month),
    "Net worth": convert(p.netWorth),
    "Total balance": convert(p.totalBalance),
    Investments: convert(p.investmentValue),
  }));
}

export default function WealthTrendChart({ data, currency }: Props) {
  const { convert } = useSettings();

  const chartData = toEur(data, convert);

  if (chartData.length === 0) {
    return (
      <Box sx={{ py: 6, textAlign: "center", color: "text.secondary" }}>
        <Typography variant="body2">No data available</Typography>
      </Box>
    );
  }

  return (
    <Box>
      <Stack direction="row" spacing={2} sx={{ mb: 1, flexWrap: "wrap" }}>
        <LegendItem color={COLORS.netWorth} label="Net worth" />
        <LegendItem color={COLORS.totalBalance} label="Total balance" />
        <LegendItem color={COLORS.investments} label="Investments" />
      </Stack>

      <ResponsiveContainer width="100%" height={260}>
        <AreaChart data={chartData} margin={{ top: 5, right: 10, left: 0, bottom: 0 }}>
          <defs>
            {Object.entries(COLORS).map(([key, color]) => (
              <linearGradient key={key} id={`grad-${key}`} x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor={color} stopOpacity={0.28} />
                <stop offset="95%" stopColor={color} stopOpacity={0.02} />
              </linearGradient>
            ))}
          </defs>
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
            cursor={{ stroke: "rgba(0,0,0,0.18)" }}
            content={({ active, payload }) => {
              if (!active || !payload?.length) return null;
              const point = payload[0].payload as {
                label: string;
                "Net worth": number;
                "Total balance": number;
                Investments: number;
              };
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
                    <Typography variant="caption" sx={{ color: COLORS.netWorth }}>
                      Net worth
                    </Typography>
                    <Typography variant="caption" sx={{ fontWeight: 700 }}>
                      {formatCurrency(Number(point["Net worth"] ?? 0), currency)}
                    </Typography>
                  </Box>
                  <Divider sx={{ my: 0.75 }} />
                  <Box sx={{ display: "flex", justifyContent: "space-between", gap: 2 }}>
                    <Typography variant="caption" sx={{ color: COLORS.totalBalance }}>
                      Total balance
                    </Typography>
                    <Typography variant="caption" sx={{ fontWeight: 600 }}>
                      {formatCurrency(Number(point["Total balance"] ?? 0), currency)}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", justifyContent: "space-between", gap: 2 }}>
                    <Typography variant="caption" sx={{ color: COLORS.investments }}>
                      Investments
                    </Typography>
                    <Typography variant="caption" sx={{ fontWeight: 600 }}>
                      {formatCurrency(Number(point.Investments ?? 0), currency)}
                    </Typography>
                  </Box>
                </Box>
              );
            }}
          />
          <Area
            type="monotone"
            dataKey="Net worth"
            stroke={COLORS.netWorth}
            strokeWidth={2.5}
            fill="url(#grad-netWorth)"
            dot={{ r: 2.5, fill: COLORS.netWorth, strokeWidth: 0 }}
            activeDot={{ r: 5 }}
          />
          <Area
            type="monotone"
            dataKey="Total balance"
            stroke={COLORS.totalBalance}
            strokeWidth={2}
            fill="url(#grad-totalBalance)"
            dot={{ r: 2.5, fill: COLORS.totalBalance, strokeWidth: 0 }}
            activeDot={{ r: 5 }}
          />
          <Area
            type="monotone"
            dataKey="Investments"
            stroke={COLORS.investments}
            strokeWidth={2}
            fill="url(#grad-investments)"
            dot={{ r: 2.5, fill: COLORS.investments, strokeWidth: 0 }}
            activeDot={{ r: 5 }}
          />
        </AreaChart>
      </ResponsiveContainer>
    </Box>
  );
}