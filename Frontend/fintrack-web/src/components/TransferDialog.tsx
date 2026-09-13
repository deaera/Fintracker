import { useState } from "react";
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  MenuItem,
  TextField,
  Typography,
} from "@mui/material";
import type { Account, CreateTransferInput } from "../types";

const CURRENCIES = ["RON", "EUR", "USD", "GBP"];

interface Props {
  open: boolean;
  onClose: () => void;
  accounts: Account[];
  onSubmit: (input: CreateTransferInput) => Promise<void>;
}

function toDateInputValue(date: string): string {
  return date.slice(0, 10);
}

export default function TransferDialog({ open, onClose, accounts, onSubmit }: Props) {
  const [fromAccountId, setFromAccountId] = useState(accounts[0]?.id ?? "");
  const [toAccountId, setToAccountId] = useState(accounts[1]?.id ?? accounts[0]?.id ?? "");
  const [amount, setAmount] = useState("");
  const [date, setDate] = useState(toDateInputValue(new Date().toISOString()));
  const [description, setDescription] = useState("");
  const [currency, setCurrency] = useState(
    accounts.find((a) => a.id === accounts[0]?.id)?.currency ?? "EUR",
  );
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  const currencyOf = (id: string) => accounts.find((a) => a.id === id)?.currency ?? "EUR";

  const handleFromChange = (id: string) => {
    if (currency === currencyOf(fromAccountId)) {
      setCurrency(currencyOf(id));
    }
    setFromAccountId(id);
  };

  const handleSubmit = async () => {
    const amountValue = Number(amount);

    if (!fromAccountId || !toAccountId) {
      setError("Please choose both accounts.");
      return;
    }

    if (fromAccountId === toAccountId) {
      setError("Choose two different accounts.");
      return;
    }

    if (!amountValue || amountValue <= 0) {
      setError("Amount must be greater than zero.");
      return;
    }

    if (!date) {
      setError("Please choose a date.");
      return;
    }

    setSubmitting(true);
    setError("");
    try {
      await onSubmit({
        fromAccountId,
        toAccountId,
        amount: amountValue,
        currency,
        date,
        description: description.trim(),
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
      <DialogTitle>Transfer between accounts</DialogTitle>
      <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 2 }}>
        <TextField
          select
          label="From"
          value={fromAccountId}
          onChange={(e) => handleFromChange(e.target.value)}
          fullWidth
          autoFocus
        >
          {accounts.map((a) => (
            <MenuItem key={a.id} value={a.id}>
              {a.name}
            </MenuItem>
          ))}
        </TextField>

        <TextField
          select
          label="To"
          value={toAccountId}
          onChange={(e) => setToAccountId(e.target.value)}
          fullWidth
        >
          {accounts.map((a) => (
            <MenuItem key={a.id} value={a.id}>
              {a.name}
            </MenuItem>
          ))}
        </TextField>

        <TextField
          label="Amount"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          type="number"
          slotProps={{ htmlInput: { min: 0.01, step: 0.01 } }}
          fullWidth
        />

        <TextField
          select
          label="Currency"
          value={currency}
          onChange={(e) => setCurrency(e.target.value)}
          fullWidth
          helperText="Transferred amount is recorded in this currency."
        >
          {CURRENCIES.map((c) => (
            <MenuItem key={c} value={c}>
              {c}
            </MenuItem>
          ))}
        </TextField>

        <TextField
          label="Date"
          value={date}
          onChange={(e) => setDate(e.target.value)}
          type="date"
          fullWidth
          slotProps={{ inputLabel: { shrink: true } }}
        />

        <TextField
          label="Description (optional)"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          fullWidth
          placeholder="Transfer"
        />

        {error && (
          <Typography variant="body2" color="error">
            {error}
          </Typography>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={handleSubmit} disabled={submitting}>
          Transfer
        </Button>
      </DialogActions>
    </Dialog>
  );
}