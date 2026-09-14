import { useMemo, useState } from "react";
import toast from "react-hot-toast";
import {
  Box,
  Button,
  Card,
  Chip,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";
import RefreshIcon from "@mui/icons-material/Refresh";
import AddIcon from "@mui/icons-material/Add";
import { useSettings } from "../../context/settings";
import { useApiData } from "../../hooks/useApiData";
import LoadingSkeleton from "../../components/LoadingSkeleton";
import {
  getInvestmentAccounts,
  getInvestmentAssets,
  getInvestmentHoldings,
  refreshInvestmentPrices,
} from "../../services/investmentService";
import type { InvestmentHolding } from "../../types";
import { formatCurrency } from "../../utils/format";
import InvestmentTransactionDialog from "./InvestmentTransactionDialog";

export default function HoldingsTab() {
  const { convert, currency } = useSettings();
  const holdingsState = useApiData<InvestmentHolding[]>(getInvestmentHoldings, "invest-holdings");
  const accountsState = useApiData(getInvestmentAccounts, "invest-accounts");
  const assetsState = useApiData(getInvestmentAssets, "invest-assets");
  const [refreshing, setRefreshing] = useState(false);
  const [dialogOpen, setDialogOpen] = useState(false);

  const holdings = useMemo(() => holdingsState.data ?? [], [holdingsState.data]);

  if (holdingsState.loading) {
    return <LoadingSkeleton />;
  }

  const handleRefresh = async () => {
    setRefreshing(true);
    try {
      const result = await refreshInvestmentPrices();
      toast.success(
        result.failed === 0
          ? `Prices updated (${result.updated}).`
          : `Prices updated (${result.updated}), ${result.failed} failed: ${result.errors.join(", ")}`,
      );
      await holdingsState.reload();
    } catch {
      toast.error("Could not refresh prices.");
    } finally {
      setRefreshing(false);
    }
  };

  return (
    <Stack spacing={3}>
      <Card>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>Asset</TableCell>
                <TableCell>Account</TableCell>
                <TableCell align="right">Quantity</TableCell>
                <TableCell align="right">Avg cost</TableCell>
                <TableCell align="right">Price</TableCell>
                <TableCell align="right">Value</TableCell>
                <TableCell align="right">Unrealized</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {holdings.map((h) => (
                <TableRow key={`${h.accountId}-${h.assetId}`} hover>
                  <TableCell>
                    <Typography sx={{ fontWeight: 600 }}>{h.name}</Typography>
                    <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
                      <Typography variant="body2" color="text.secondary">
                        {h.ticker}
                      </Typography>
                      <Chip
                        size="small"
                        label={h.priceSource}
                        sx={{ height: 18, fontSize: 11 }}
                        color={h.priceSource === "manual" ? "warning" : "default"}
                        variant="outlined"
                      />
                    </Box>
                  </TableCell>
                  <TableCell>{h.accountName}</TableCell>
                  <TableCell align="right">{h.quantity}</TableCell>
                  <TableCell align="right">
                    {formatCurrency(h.avgCost, h.currency)}
                  </TableCell>
                  <TableCell align="right">{formatCurrency(h.currentPrice, h.currency)}</TableCell>
                  <TableCell align="right" sx={{ fontWeight: 600 }}>
                    {formatCurrency(convert(h.currentValue), currency)}
                  </TableCell>
                  <TableCell
                    align="right"
                    sx={{
                      fontWeight: 600,
                      color: h.gain >= 0 ? "success.main" : "error.main",
                    }}
                  >
                    {h.gain >= 0 ? "+" : "−"}
                    {formatCurrency(Math.abs(convert(h.gain)), currency)}
                    <Typography variant="body2" color="text.secondary">
                      {h.gainPct >= 0 ? "+" : ""}
                      {h.gainPct.toFixed(1)}%
                    </Typography>
                  </TableCell>
                </TableRow>
              ))}
              {holdings.length === 0 && (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 4, color: "text.secondary" }}>
                    No holdings yet. Add a buy from the Transactions tab.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </TableContainer>
      </Card>

      <Stack direction="row" spacing={1}>
        <Button
          variant="outlined"
          startIcon={<RefreshIcon />}
          onClick={handleRefresh}
          disabled={refreshing}
        >
          {refreshing ? "Refreshing…" : "Refresh prices"}
        </Button>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => setDialogOpen(true)}
          disabled={holdings.length === 0 && (assetsState.data?.length ?? 0) === 0}
        >
          Add buy
        </Button>
        <Box sx={{ flexGrow: 1 }} />
        <Typography
          variant="body2"
          color="text.secondary"
          sx={{ alignSelf: "center" }}
        >
          Total: {formatCurrency(convert(holdings.reduce((sum, h) => sum + h.currentValue, 0)), currency)}
        </Typography>
      </Stack>

      <InvestmentTransactionDialog
        key={dialogOpen ? "open" : "closed"}
        open={dialogOpen}
        onClose={() => setDialogOpen(false)}
        accounts={accountsState.data ?? []}
        assets={assetsState.data ?? []}
        initialType={0}
        onSaved={async () => {
          await holdingsState.reload();
        }}
      />
    </Stack>
  );
}