import { useState } from "react";
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  ListSubheader,
  MenuItem,
  TextField,
  Typography,
} from "@mui/material";
import type { Account, CashTransaction, Category, CreateTransactionInput } from "../types";
import { CategoryType } from "../types";

const CURRENCIES = ["RON", "EUR", "USD", "GBP"];

interface Props {
  open: boolean;
  onClose: () => void;
  accounts: Account[];
  categories: Category[];
  initial: CashTransaction | null;
  onSubmit: (input: CreateTransactionInput) => Promise<void>;
}

function toDateInputValue(date: string): string {
  return date.slice(0, 10);
}

export default function TransactionFormDialog({
  open,
  onClose,
  accounts,
  categories,
  initial,
  onSubmit,
}: Props) {
  const firstExpenseCategory = categories.find((c) => c.type === CategoryType.Expense);

  const [description, setDescription] = useState(initial?.description ?? "");
  const [amount, setAmount] = useState(initial ? String(initial.amount) : "");
  const [date, setDate] = useState(
    toDateInputValue(initial?.date ?? new Date().toISOString().slice(0, 10)),
  );
  const [categoryId, setCategoryId] = useState(
    initial?.categoryId ?? firstExpenseCategory?.id ?? categories[0]?.id ?? "",
  );
  const [accountId, setAccountId] = useState(initial?.accountId ?? accounts[0]?.id ?? "");
  const initialCurrency =
    initial?.currency ??
    accounts.find((a) => a.id === (initial?.accountId ?? accounts[0]?.id))?.currency ??
    "EUR";
  const [currency, setCurrency] = useState(initialCurrency);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  const incomeCategories = categories.filter((c) => c.type === CategoryType.Income);
  const expenseCategories = categories.filter((c) => c.type === CategoryType.Expense);

  const currencyOf = (id: string) => accounts.find((a) => a.id === id)?.currency ?? "EUR";

  const handleAccountChange = (id: string) => {
    if (currency === currencyOf(accountId)) {
      setCurrency(currencyOf(id));
    }
    setAccountId(id);
  };

  const handleSubmit = async () => {
    const amountValue = Number(amount);
    if (!description.trim()) {
      setError("Description is required.");
      return;
    }
    if (!amountValue || amountValue <= 0) {
      setError("Amount must be greater than zero.");
      return;
    }
    if (!categoryId || !accountId) {
      setError("Please select a category and an account.");
      return;
    }

    setSubmitting(true);
    setError("");
    try {
      await onSubmit({
        description: description.trim(),
        amount: amountValue,
        currency,
        date,
        categoryId,
        accountId,
      });
      onClose();
    } catch {
      setError("Something went wrong. Check that the backend is running.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
      <DialogTitle>{initial ? "Edit transaction" : "Add transaction"}</DialogTitle>
      <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 2 }}>
        <TextField
          label="Description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          fullWidth
          autoFocus
        />

        <TextField
          label="Amount"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          type="number"
          slotProps={{ htmlInput: { min: 0.01, step: 0.01 } }}
          fullWidth
        />

        <TextField
          label="Date"
          value={date}
          onChange={(e) => setDate(e.target.value)}
          type="date"
          fullWidth
          slotProps={{ inputLabel: { shrink: true } }}
        />

        <TextField
          select
          label="Category"
          value={categoryId}
          onChange={(e) => setCategoryId(e.target.value)}
          fullWidth
        >
          {incomeCategories.length > 0 && <ListSubheader>Income</ListSubheader>}
          {incomeCategories.map((c) => (
            <MenuItem key={c.id} value={c.id}>
              {c.icon} {c.name}
            </MenuItem>
          ))}
          {expenseCategories.length > 0 && <ListSubheader>Expenses</ListSubheader>}
          {expenseCategories.map((c) => (
            <MenuItem key={c.id} value={c.id}>
              {c.icon} {c.name}
            </MenuItem>
          ))}
        </TextField>

        <TextField
          select
          label="Account"
          value={accountId}
          onChange={(e) => handleAccountChange(e.target.value)}
          fullWidth
        >
          {accounts.map((a) => (
            <MenuItem key={a.id} value={a.id}>
              {a.name}
            </MenuItem>
          ))}
        </TextField>

        <TextField
          select
          label="Currency"
          value={currency}
          onChange={(e) => setCurrency(e.target.value)}
          fullWidth
          helperText="The amount is recorded in this currency."
        >
          {CURRENCIES.map((c) => (
            <MenuItem key={c} value={c}>
              {c}
            </MenuItem>
          ))}
        </TextField>

        {error && (
          <Typography variant="body2" color="error">
            {error}
          </Typography>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={handleSubmit} disabled={submitting}>
          Save
        </Button>
      </DialogActions>
    </Dialog>
  );
}