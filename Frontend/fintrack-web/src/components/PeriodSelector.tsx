import { Box, FormControl, InputLabel, MenuItem, Select } from "@mui/material";
import type { Period } from "../types";

interface Props {
  period: Period;
  onChange: (period: Period) => void;
}

const YEAR_OPTIONS = 2;

export default function PeriodSelector({ period, onChange }: Props) {
  const currentYear = new Date().getFullYear();
  const years = Array.from({ length: YEAR_OPTIONS + 1 }, (_, i) => currentYear - i);

  return (
    <Box sx={{ display: "flex", gap: 2, alignItems: "center", flexWrap: "wrap" }}>
      <FormControl size="small" sx={{ minWidth: 140 }}>
        <InputLabel>Year</InputLabel>
        <Select
          label="Year"
          value={String(period.year ?? "")}
          onChange={(e) => {
            const value = e.target.value;
            onChange({
              year: value === "" ? null : Number(value),
              month: null,
            });
          }}
        >
          <MenuItem value="">All time</MenuItem>
          {years.map((y) => (
            <MenuItem key={y} value={String(y)}>
              {y}
            </MenuItem>
          ))}
        </Select>
      </FormControl>

      <FormControl size="small" sx={{ minWidth: 140 }}>
        <InputLabel>Month</InputLabel>
        <Select
          label="Month"
          value={String(period.month ?? "")}
          disabled={period.year == null}
          onChange={(e) => {
            const value = e.target.value;
            onChange({
              ...period,
              month: value === "" ? null : Number(value),
            });
          }}
        >
          <MenuItem value="">Whole year</MenuItem>
          {Array.from({ length: 12 }, (_, i) => i + 1).map((m) => (
            <MenuItem key={m} value={String(m)}>
              {new Date(2026, m - 1, 1).toLocaleString("en", { month: "long" })}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
    </Box>
  );
}