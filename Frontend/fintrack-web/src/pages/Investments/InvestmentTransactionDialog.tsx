import { useMemo, useState } from "react";
import toast from "react-hot-toast";
import dayjs from "dayjs";
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  MenuItem,
  Stack,
  TextField,
  Typography,
} from "@mui/material";
import {
  createInvestmentTransaction,
  updateInvestmentTransaction,
} from "../../services/investmentService";
import type {
  InvestmentAccount,
  InvestmentAsset,
  InvestmentTransaction,
  InvestmentTransactionType,
} from "../../types";
import { InvestmentTransactionType as TxType } from "../../types";
import { INVESTMENT_TYPE_LABELS } from "../../utils/investmentLabels";
import { formatCurrency } from "../../utils/format";

interface Props {
  open: boolean;
  onClose: () => void;
  accounts: InvestmentAccount[];
  assets: InvestmentAsset[];
  transaction?: InvestmentTransaction | null;
  initialType?: InvestmentTransactionType;
  onSaved: () => void;
}

export default function InvestmentTransactionDialog({
  open,
  onClose,
  accounts,
  assets,
  transaction,
  initialType,
  onSaved,
}: Props) {
  const [type, setType] = useState<InvestmentTransactionType>(
    transaction?.type ?? initialType ?? TxType.Buy,
  );
  const [accountId, setAccountId] = useState(
    transaction?.investmentAccountId ?? accounts[0]?.id ?? "",
  );
  const [assetId, setAssetId] = useState(transaction?.assetId ?? assets[0]?.id ?? "");
  const [date, setDate] = useState(
    transaction?.date ?? dayjs().format("YYYY-MM-DD"),
  );
  const [quantity, setQuantity] = useState(
    transaction && transaction.quantity > 0 ? String(transaction.quantity) : "",
  );
  const [price, setPrice] = useState(
    transaction && transaction.price > 0 ? String(transaction.price) : "",
  );
  const [amount, setAmount] = useState(
    transaction && transaction.amount > 0 ? String(transaction.amount) : "",
  );
  const [fee, setFee] = useState(
    transaction && transaction.fee > 0 ? String(transaction.fee) : "",
  );
  const [note, setNote] = useState(transaction?.note ?? "");
  const [saving, setSaving] = useState(false);

  const isDeal = useMemo(
    () => type === TxType.Buy || type === TxType.Sell,
    [type],
  );
  const needsAsset =
    type === TxType.Buy || type === TxType.Sell || type === TxType.Dividend;

  const computedAmount = isDeal
    ? (Number(quantity) || 0) * (Number(price) || 0)
    : Number(amount) || 0;
  const asset = assets.find((a) => a.id === assetId);

  const handleSubmit = async () => {
    const errors: string[] = [];
    if (!accountId) errors.push("account");
    if (isDeal) {
      if (!assetId) errors.push("asset");
      if (!(Number(quantity) > 0)) errors.push("quantity");
      if (!(Number(price) > 0)) errors.push("price");
    }
    if (!isDeal && !(Number(amount) > 0)) errors.push("amount");
    if (errors.length > 0) {
      toast.error(`Please fix: ${errors.join(", ")}.`);
      return;
    }

    setSaving(true);
    try {
      const input = {
        investmentAccountId: accountId,
        assetId: isDeal || needsAsset ? (assetId || null) : null,
        type,
        date,
        quantity: isDeal ? Number(quantity) : 0,
        price: isDeal ? Number(price) : 0,
        amount: isDeal ? computedAmount : Number(amount),
        fee: Number(fee) || 0,
        note,
      };
      if (transaction) {
        await updateInvestmentTransaction(transaction.id, input);
        toast.success("Transaction updated");
      } else {
        await createInvestmentTransaction(input);
        toast.success("Transaction added");
      }
      onSaved();
      onClose();
    } catch {
      toast.error("Could not save transaction.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
      <DialogTitle>{transaction ? "Edit transaction" : "Add transaction"}</DialogTitle>
      <DialogContent>
        <Stack spacing={2} sx={{ pt: 1 }}>
          <TextField
            select
            size="small"
            label="Type"
            value={type}
            onChange={(e) => setType(Number(e.target.value) as InvestmentTransactionType)}
          >
            {Object.entries(INVESTMENT_TYPE_LABELS).map(([value, label]) => (
              <MenuItem key={value} value={Number(value)}>
                {label}
              </MenuItem>
            ))}
          </TextField>

          <TextField
            select
            size="small"
            label="Account"
            value={accountId}
            onChange={(e) => setAccountId(e.target.value)}
          >
            {accounts.map((a) => (
              <MenuItem key={a.id} value={a.id}>
                {a.name} · {a.currency}
              </MenuItem>
            ))}
          </TextField>

          {needsAsset && (
            <TextField
              select
              size="small"
              label="Asset"
              value={assetId}
              onChange={(e) => setAssetId(e.target.value)}
            >
              <MenuItem value="">None</MenuItem>
              {assets.map((a) => (
                <MenuItem key={a.id} value={a.id}>
                  {a.ticker} — {a.name}
                </MenuItem>
              ))}
            </TextField>
          )}

          <TextField
            size="small"
            type="date"
            label="Date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
            slotProps={{ inputLabel: { shrink: true } }}
          />

          {isDeal && (
            <Stack direction={{ xs: "column", md: "row" }} spacing={2}>
              <TextField
                size="small"
                label="Quantity"
                type="number"
                value={quantity}
                onChange={(e) => setQuantity(e.target.value)}
                fullWidth
              />
              <TextField
                size="small"
                label="Price"
                type="number"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                fullWidth
              />
            </Stack>
          )}

          <TextField
            size="small"
            label={isDeal ? "Amount (auto)" : "Amount"}
            type="number"
            value={isDeal ? (computedAmount || "") : amount}
            onChange={(e) => setAmount(e.target.value)}
            disabled={isDeal}
            slotProps={{
              htmlInput: { step: "any" },
            }}
          />

          <TextField
            size="small"
            label="Fee"
            type="number"
            value={fee}
            onChange={(e) => setFee(e.target.value)}
            slotProps={{ htmlInput: { step: "any" } }}
          />

          <TextField
            size="small"
            label="Note"
            value={note}
            onChange={(e) => setNote(e.target.value)}
          />

          {asset && (
            <Typography variant="body2" color="text.secondary">
              {formatCurrency(computedAmount || 0, asset.currency)} in {asset.currency}
            </Typography>
          )}
        </Stack>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={handleSubmit} disabled={saving}>
          {saving ? "Saving…" : transaction ? "Update" : "Add"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}