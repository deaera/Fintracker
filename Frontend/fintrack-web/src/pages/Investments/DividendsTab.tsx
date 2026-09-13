import { useState } from "react";
import {
  Box,
  Button,
  Card,
  CardContent,
  CircularProgress,
  Grid,
  MenuItem,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Typography,
} from "@mui/material";
import FileDownloadIcon from "@mui/icons-material/FileDownload";
import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import dayjs from "dayjs";
import { useSettings } from "../../context/settings";
import { useApiData } from "../../hooks/useApiData";
import {
  downloadInvestmentCsv,
  getInvestmentDividends,
} from "../../services/investmentService";
import { formatCurrency, formatDate, monthName } from "../../utils/format";

const YEARS = [dayjs().year() - 2, dayjs().year() - 1, dayjs().year()];

export default function DividendsTab() {
  const { currency, convert, convertTo } = useSettings();
  const [year, setYear] = useState(dayjs().year());
  const state = useApiData(() => getInvestmentDividends(year), `div:${year}`);

  if (state.loading || !state.data) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        {state.error ? (
          <Typography color="text.secondary">Could not load dividends.</Typography>
        ) : (
          <CircularProgress />
        )}
      </Box>
    );
  }

  const data = state.data;
  const monthlyData = [...data.monthly]
    .sort((a, b) => a.month - b.month)
    .map((m) => ({
      label: monthName(m.month),
      dividends: convert(Number(m.total)),
    }));

  const downloadCsv = async (kind: "sales" | "dividends" | "gains") => {
    await downloadInvestmentCsv(kind);
  };

  return (
    <Stack spacing={3}>
      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 4 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Typography variant="body2" color="text.secondary">
                Dividends received in {year}
              </Typography>
              <Typography variant="h5" sx={{ fontWeight: 700, mt: 1 }}>
                {formatCurrency(convert(data.yearlyTotal), currency)}
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                {data.payments.length} payments
              </Typography>
              <Stack spacing={2}>
                <TextField
                  select
                  size="small"
                  label="Year"
                  value={year}
                  onChange={(e) => setYear(Number(e.target.value))}
                  sx={{ mt: 2, width: 140 }}
                >
                  {YEARS.map((y) => (
                    <MenuItem key={y} value={y}>
                      {y}
                    </MenuItem>
                  ))}
                </TextField>
                <Stack direction="row" spacing={1}>
                  <Button
                    variant="outlined"
                    size="small"
                    startIcon={<FileDownloadIcon />}
                    onClick={() => downloadCsv("dividends")}
                  >
                    Dividends CSV
                  </Button>
                  <Button
                    variant="outlined"
                    size="small"
                    startIcon={<FileDownloadIcon />}
                    onClick={() => downloadCsv("sales")}
                  >
                    Sales CSV
                  </Button>
                  <Button
                    variant="outlined"
                    size="small"
                    startIcon={<FileDownloadIcon />}
                    onClick={() => downloadCsv("gains")}
                  >
                    Gains CSV
                  </Button>
                </Stack>
              </Stack>
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 8 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Typography variant="h6" sx={{ mb: 1 }}>
                Monthly dividends
              </Typography>
              <ResponsiveContainer width="100%" height={220}>
                <BarChart data={monthlyData} margin={{ top: 5, right: 10, left: 5, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" strokeOpacity={0.3} />
                  <XAxis dataKey="label" tick={{ fontSize: 11 }} />
                  <YAxis tick={{ fontSize: 11 }} width={60} />
                  <Tooltip formatter={(value) => formatCurrency(Number(value), currency)} />
                  <Bar dataKey="dividends" fill="#43A047" radius={[3, 3, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Card>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>Date</TableCell>
                <TableCell>Asset</TableCell>
                <TableCell>Account</TableCell>
                <TableCell align="right">Amount</TableCell>
                <TableCell align="right">In {currency}</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {data.payments.map((p) => (
                <TableRow key={p.id} hover>
                  <TableCell>{formatDate(p.date)}</TableCell>
                  <TableCell sx={{ fontWeight: 600 }}>{p.ticker}</TableCell>
                  <TableCell>{p.accountName}</TableCell>
                  <TableCell align="right">{formatCurrency(p.amount, p.currency)}</TableCell>
                  <TableCell align="right" sx={{ fontWeight: 600 }}>
                    {formatCurrency(convert(p.amount), currency)}
                  </TableCell>
                </TableRow>
              ))}
              {data.payments.length === 0 && (
                <TableRow>
                  <TableCell colSpan={5} align="center" sx={{ py: 4, color: "text.secondary" }}>
                    No dividend payments in {year}.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </TableContainer>
      </Card>

      {data.upcoming.length > 0 && (
        <Card>
          <CardContent>
            <Typography variant="h6" sx={{ mb: 1 }}>
              Upcoming (estimated)
            </Typography>
            <Table size="small">
              <TableBody>
                {data.upcoming.map((p, i) => (
                  <TableRow key={`${p.ticker}-${i}`} hover>
                    <TableCell>{formatDate(p.date)}</TableCell>
                    <TableCell sx={{ fontWeight: 600 }}>{p.ticker}</TableCell>
                    <TableCell align="right">
                      {formatCurrency(convertTo(p.amount, p.currency), currency)}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}
    </Stack>
  );
}