import { useMemo, useState } from "react";
import toast from "react-hot-toast";
import {
  Box,
  Button,
  Card,
  Chip,
  CircularProgress,
  IconButton,
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
import AddIcon from "@mui/icons-material/Add";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import { useSettings } from "../../context/settings";
import { useApiData } from "../../hooks/useApiData";
import {
  deleteInvestmentTransaction,
  getInvestmentAccounts,
  getInvestmentAssets,
  getInvestmentTransactions,
} from "../../services/investmentService";
import type { InvestmentTransaction, InvestmentTransactionType } from "../../types";
import { InvestmentTransactionType as TxType } from "../../types";
import { INVESTMENT_TYPE_LABELS } from "../../utils/investmentLabels";
import { formatCurrency, formatDate } from "../../utils/format";
import InvestmentTransactionDialog from "./InvestmentTransactionDialog";

const TYPE_COLORS: Record<InvestmentTransactionType, "success" | "error" | "info" | "warning" | "default"> = {
  [TxType.Buy]: "success",
  [TxType.Sell]: "error",
  [TxType.Dividend]: "info",
  [TxType.Interest]: "info",
  [TxType.Fee]: "default",
  [TxType.TransferIn]: "success",
  [TxType.TransferOut]: "warning",
};

export default function TransactionsTab() {
  const { currency, convert } = useSettings();
  const [accountFilter, setAccountFilter] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editing, setEditing] = useState<InvestmentTransaction | null>(null);

  const transactionsState = useApiData(() => getInvestmentTransactions({
    account: accountFilter || undefined,
    type: typeFilter ? (Number(typeFilter) as InvestmentTransactionType) : undefined,
  }), `tx:${accountFilter}:${typeFilter}`);
  const accountsState = useApiData(getInvestmentAccounts, "tx-accounts");
  const assetsState = useApiData(getInvestmentAssets, "tx-assets");

  const transactions = useMemo(() => transactionsState.data ?? [], [transactionsState.data]);
  const accounts = useMemo(() => accountsState.data ?? [], [accountsState.data]);
  const assets = useMemo(() => assetsState.data ?? [], [assetsState.data]);

  if (transactionsState.loading || accountsState.loading || assetsState.loading) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        <CircularProgress />
      </Box>
    );
  }

  const handleDelete = async (id: string) => {
    if (!window.confirm("Delete this transaction?")) return;
    try {
      await deleteInvestmentTransaction(id);
      toast.success("Transaction deleted");
      await transactionsState.reload();
    } catch {
      toast.error("Could not delete transaction.");
    }
  };

  return (
    <Stack spacing={3}>
      <Stack direction={{ xs: "column", md: "row" }} spacing={2} sx={{ justifyContent: "space-between" }}>
        <Stack direction={{ xs: "column", md: "row" }} spacing={2}>
          <TextField
            select
            size="small"
            label="Account"
            value={accountFilter}
            onChange={(e) => setAccountFilter(e.target.value)}
            sx={{ minWidth: 200 }}
          >
            <MenuItem value="">All accounts</MenuItem>
            {accounts.map((a) => (
              <MenuItem key={a.id} value={a.id}>
                {a.name}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            select
            size="small"
            label="Type"
            value={typeFilter}
            onChange={(e) => setTypeFilter(e.target.value)}
            sx={{ minWidth: 160 }}
          >
            <MenuItem value="">All types</MenuItem>
            {Object.entries(INVESTMENT_TYPE_LABELS).map(([value, label]) => (
              <MenuItem key={value} value={value}>
                {label}
              </MenuItem>
            ))}
          </TextField>
        </Stack>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => {
            setEditing(null);
            setDialogOpen(true);
          }}
        >
          Add transaction
        </Button>
      </Stack>

      <Card>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>Date</TableCell>
                <TableCell>Type</TableCell>
                <TableCell>Asset</TableCell>
                <TableCell align="right">Qty × Price</TableCell>
                <TableCell align="right">Amount</TableCell>
                <TableCell>Note</TableCell>
                <TableCell align="right">Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {transactions.map((t) => (
                <TableRow key={t.id} hover>
                  <TableCell>{formatDate(t.date)}</TableCell>
                  <TableCell>
                    <Chip
                      size="small"
                      label={INVESTMENT_TYPE_LABELS[t.type]}
                      color={TYPE_COLORS[t.type]}
                      variant="outlined"
                    />
                  </TableCell>
                  <TableCell>
                    {t.ticker ? (
                      <Stack>
                        <Typography sx={{ fontWeight: 600 }}>{t.ticker}</Typography>
                        <Typography variant="body2" color="text.secondary">
                          {t.accountName}
                        </Typography>
                      </Stack>
                    ) : (
                      t.accountName
                    )}
                  </TableCell>
                  <TableCell align="right">
                    {t.quantity > 0 || t.price > 0 ? `${t.quantity} × ${t.price}` : "—"}
                  </TableCell>
                  <TableCell align="right" sx={{ fontWeight: 600 }}>
                    {t.type === TxType.TransferOut || t.type === TxType.Fee || t.type === TxType.Sell
                      ? "−"
                      : "+"}
                    {formatCurrency(convert(t.amount), currency)}
                  </TableCell>
                  <TableCell>{t.note || "—"}</TableCell>
                  <TableCell align="right">
                    <IconButton
                      size="small"
                      onClick={() => {
                        setEditing(t);
                        setDialogOpen(true);
                      }}
                    >
                      <EditIcon fontSize="small" />
                    </IconButton>
                    <IconButton
                      size="small"
                      color="error"
                      onClick={() => handleDelete(t.id)}
                    >
                      <DeleteIcon fontSize="small" />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))}
              {transactions.length === 0 && (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 4, color: "text.secondary" }}>
                    No transactions yet.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </TableContainer>
      </Card>

      <InvestmentTransactionDialog
        key={dialogOpen ? (editing?.id ?? "new") : "closed"}
        open={dialogOpen}
        onClose={() => setDialogOpen(false)}
        accounts={accounts}
        assets={assets}
        transaction={editing}
        onSaved={async () => {
          await transactionsState.reload();
        }}
      />
    </Stack>
  );
}