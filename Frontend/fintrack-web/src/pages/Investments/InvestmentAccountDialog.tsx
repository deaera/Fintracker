import { useState } from "react";
import toast from "react-hot-toast";
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  MenuItem,
  Stack,
  TextField,
} from "@mui/material";
import {
  createInvestmentAccount,
  updateInvestmentAccount,
} from "../../services/investmentService";
import type { InvestmentAccount } from "../../types";

const CURRENCIES = ["EUR", "USD", "RON", "GBP", "CHF", "PLN", "HUF"];

interface Props {
  open: boolean;
  onClose: () => void;
  account?: InvestmentAccount | null;
  onSaved: () => void;
}

export default function InvestmentAccountDialog({ open, onClose, account, onSaved }: Props) {
  const [name, setName] = useState(account?.name ?? "");
  const [institution, setInstitution] = useState(account?.institution ?? "");
  const [accountCurrency, setAccountCurrency] = useState(account?.currency ?? "EUR");
  const [openingBalance, setOpeningBalance] = useState(
    account ? String(account.openingBalance) : "",
  );
  const [saving, setSaving] = useState(false);

  const handleSubmit = async () => {
    if (!name.trim()) {
      toast.error("Please enter an account name.");
      return;
    }
    setSaving(true);
    try {
      const input = {
        name: name.trim(),
        institution: institution.trim(),
        currency: accountCurrency,
        openingBalance: Number(openingBalance) || 0,
      };
      if (account) {
        await updateInvestmentAccount(account.id, input);
        toast.success("Account updated");
      } else {
        await createInvestmentAccount(input);
        toast.success("Account added");
      }
      onSaved();
      onClose();
    } catch {
      toast.error("Could not save account.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
      <DialogTitle>{account ? "Edit account" : "Add account"}</DialogTitle>
      <DialogContent>
        <Stack spacing={2} sx={{ pt: 1 }}>
          <TextField
            size="small"
            label="Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
          <TextField
            size="small"
            label="Institution"
            value={institution}
            onChange={(e) => setInstitution(e.target.value)}
          />
          <TextField
            select
            size="small"
            label="Currency"
            value={accountCurrency}
            onChange={(e) => setAccountCurrency(e.target.value)}
          >
            {CURRENCIES.map((c) => (
              <MenuItem key={c} value={c}>
                {c}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            size="small"
            label="Opening balance"
            type="number"
            value={openingBalance}
            onChange={(e) => setOpeningBalance(e.target.value)}
            slotProps={{ htmlInput: { step: "any" } }}
          />
        </Stack>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={handleSubmit} disabled={saving}>
          {saving ? "Saving…" : account ? "Update" : "Add"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}