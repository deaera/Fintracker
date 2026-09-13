import { useMemo, useState } from "react";
import toast from "react-hot-toast";
import {
  Box,
  Button,
  Card,
  Chip,
  CircularProgress,
  IconButton,
  InputAdornment,
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
import SwapHorizIcon from "@mui/icons-material/SwapHoriz";
import SearchIcon from "@mui/icons-material/Search";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import TransactionFormDialog from "../components/TransactionFormDialog";
import TransferDialog from "../components/TransferDialog";
import { useSettings } from "../context/settings";
import { useApiData } from "../hooks/useApiData";
import { getAccounts } from "../services/accountService";
import { getCategories } from "../services/categoryService";
import {
  createTransaction,
  deleteTransaction,
  getTransactions,
  updateTransaction,
} from "../services/cashTransactionService";
import { createTransfer } from "../services/transferService";
import type {
  Account,
  CashTransaction,
  Category,
  CreateTransactionInput,
  CreateTransferInput,
} from "../types";
import { CategoryType } from "../types";
import { formatCurrency, formatDate } from "../utils/format";

type TypeFilter = "all" | "income" | "expense";

export default function TransactionsPage() {
  const { currency, convert, convertFrom } = useSettings();
  const transactionsState = useApiData<CashTransaction[]>(getTransactions, "all");
  const accountsState = useApiData<Account[]>(getAccounts, "all");
  const categoriesState = useApiData<Category[]>(getCategories, "all");

  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState<TypeFilter>("all");
  const [categoryFilter, setCategoryFilter] = useState("");
  const [accountFilter, setAccountFilter] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [transferDialogOpen, setTransferDialogOpen] = useState(false);
  const [editing, setEditing] = useState<CashTransaction | null>(null);

  const transactions = useMemo(() => transactionsState.data ?? [], [transactionsState.data]);
  const accounts = useMemo(() => accountsState.data ?? [], [accountsState.data]);
  const categories = useMemo(() => categoriesState.data ?? [], [categoriesState.data]);

  const filtered = useMemo(() => {
    const query = search.trim().toLowerCase();
    return transactions
      .filter((t) => {
        if (typeFilter === "income" && t.categoryType !== CategoryType.Income) return false;
        if (typeFilter === "expense" && t.categoryType !== CategoryType.Expense) return false;
        if (categoryFilter && t.categoryId !== categoryFilter) return false;
        if (accountFilter && t.accountId !== accountFilter) return false;
        if (
          query &&
          !t.description.toLowerCase().includes(query) &&
          !t.categoryName.toLowerCase().includes(query) &&
          !t.accountName.toLowerCase().includes(query)
        ) {
          return false;
        }
        return true;
      })
      .sort((a, b) => b.date.localeCompare(a.date));
  }, [transactions, search, typeFilter, categoryFilter, accountFilter]);

  const openAdd = () => {
    setEditing(null);
    setDialogOpen(true);
  };

  const openEdit = (t: CashTransaction) => {
    setEditing(t);
    setDialogOpen(true);
  };

  const handleSubmit = async (input: CreateTransactionInput) => {
    if (editing) {
      await updateTransaction(editing.id, input);
      toast.success("Transaction updated");
    } else {
      await createTransaction(input);
      toast.success("Transaction added");
    }
    await transactionsState.reload();
  };

  const handleDelete = async (t: CashTransaction) => {
    const confirmed = window.confirm(
      t.isTransfer
        ? `Delete the transfer "${t.description || "Transfer"}"? Both sides of the transfer will be removed.`
        : `Delete "${t.description || t.categoryName}" for ${formatCurrency(convert(convertFrom(t.amount, t.currency)), currency)}?`,
    );
    if (!confirmed) return;
    try {
      await deleteTransaction(t.id);
      toast.success(t.isTransfer ? "Transfer deleted" : "Transaction deleted");
      await transactionsState.reload();
    } catch {
      toast.error("Could not delete transaction.");
    }
  };

  const handleTransfer = async (input: CreateTransferInput) => {
    await createTransfer(input);
    toast.success("Transfer added");
    await transactionsState.reload();
  };

  if (transactionsState.loading || accountsState.loading || categoriesState.loading) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        <CircularProgress />
      </Box>
    );
  }

  if (transactionsState.error || accountsState.error || categoriesState.error) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        <Typography color="text.secondary">Could not load transactions.</Typography>
      </Box>
    );
  }

  return (
    <Stack spacing={3}>
      <Box
        sx={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          flexWrap: "wrap",
          gap: 2,
        }}
      >
        <Box>
          <Typography variant="h5" sx={{ fontWeight: 700 }}>
            Transactions
          </Typography>
          <Typography variant="body2" color="text.secondary">
            {filtered.length} of {transactions.length} entries
          </Typography>
        </Box>
        <Button
          variant="outlined"
          startIcon={<SwapHorizIcon />}
          onClick={() => setTransferDialogOpen(true)}
        >
          Transfer
        </Button>
        <Button variant="contained" startIcon={<AddIcon />} onClick={openAdd}>
          Add transaction
        </Button>
      </Box>

      <Card sx={{ p: 2 }}>
        <Stack direction={{ xs: "column", md: "row" }} spacing={2}>
          <TextField
            size="small"
            placeholder="Search description, category, account…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            fullWidth
            slotProps={{
              input: {
                startAdornment: (
                  <InputAdornment position="start">
                    <SearchIcon />
                  </InputAdornment>
                ),
              },
            }}
          />
          <TextField
            select
            size="small"
            label="Type"
            value={typeFilter}
            onChange={(e) => setTypeFilter(e.target.value as TypeFilter)}
            sx={{ minWidth: 140 }}
          >
            <MenuItem value="all">All</MenuItem>
            <MenuItem value="income">Income</MenuItem>
            <MenuItem value="expense">Expenses</MenuItem>
          </TextField>
          <TextField
            select
            size="small"
            label="Category"
            value={categoryFilter}
            onChange={(e) => setCategoryFilter(e.target.value)}
            sx={{ minWidth: 170 }}
          >
            <MenuItem value="">All categories</MenuItem>
            {categories.map((c) => (
              <MenuItem key={c.id} value={c.id}>
                {c.icon} {c.name}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            select
            size="small"
            label="Account"
            value={accountFilter}
            onChange={(e) => setAccountFilter(e.target.value)}
            sx={{ minWidth: 170 }}
          >
            <MenuItem value="">All accounts</MenuItem>
            {accounts.map((a) => (
              <MenuItem key={a.id} value={a.id}>
                {a.name}
              </MenuItem>
            ))}
          </TextField>
        </Stack>
      </Card>

      <Card>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>Date</TableCell>
                <TableCell>Description</TableCell>
                <TableCell>Category</TableCell>
                <TableCell>Account</TableCell>
                <TableCell align="right">Amount</TableCell>
                <TableCell align="right">Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filtered.map((t) => {
                const income = t.categoryType === CategoryType.Income;
                const category = categories.find((c) => c.id === t.categoryId);
                const color = t.isTransfer
                  ? "text.secondary"
                  : income
                    ? "success.main"
                    : "error.main";
                return (
                  <TableRow key={t.id} hover>
                    <TableCell>{formatDate(t.date)}</TableCell>
                    <TableCell>{t.description || "—"}</TableCell>
                    <TableCell>
                      <Chip
                        size="small"
                        label={`${category?.icon ?? ""} ${t.categoryName}`}
                        sx={{
                          bgcolor: `${category?.color ?? "#78909C"}22`,
                          color: "text.primary",
                        }}
                      />
                    </TableCell>
                    <TableCell>{t.accountName}</TableCell>
                    <TableCell align="right" sx={{ fontWeight: 600, color }}>
                      {t.isTransfer
                        ? t.isOutgoingTransfer
                          ? "−"
                          : "+"
                        : income
                          ? "+"
                          : "−"}
                      {formatCurrency(convert(convertFrom(t.amount, t.currency)), currency)}
                    </TableCell>
                    <TableCell align="right">
                      {!t.isTransfer && (
                        <IconButton size="small" onClick={() => openEdit(t)}>
                          <EditIcon fontSize="small" />
                        </IconButton>
                      )}
                      <IconButton size="small" color="error" onClick={() => handleDelete(t)}>
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                );
              })}
              {filtered.length === 0 && (
                <TableRow>
                  <TableCell colSpan={6} align="center" sx={{ py: 4, color: "text.secondary" }}>
                    No transactions match your filters.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </TableContainer>
      </Card>

      <TransactionFormDialog
        key={dialogOpen ? "transaction-form-open" : "transaction-form-closed"}
        open={dialogOpen}
        onClose={() => setDialogOpen(false)}
        accounts={accounts}
        categories={categories}
        initial={editing}
        onSubmit={handleSubmit}
      />

      <TransferDialog
        open={transferDialogOpen}
        onClose={() => setTransferDialogOpen(false)}
        accounts={accounts}
        onSubmit={handleTransfer}
      />
    </Stack>
  );
}