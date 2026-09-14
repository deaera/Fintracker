import { useState } from "react";
import toast from "react-hot-toast";
import {
  Box,
  Button,
  Card,
  CardContent,
  Chip,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControl,
  FormControlLabel,
  Grid,
  IconButton,
  InputLabel,
  MenuItem,
  Select,
  Stack,
  Switch,
  TextField,
  ToggleButton,
  ToggleButtonGroup,
  Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import { useSettings } from "../context/settings";
import { useApiData } from "../hooks/useApiData";
import ConfirmDialog from "../components/ConfirmDialog";
import { getAccounts, createAccount, updateAccount } from "../services/accountService";
import { getCategories, createCategory, updateCategory, deleteCategory } from "../services/categoryService";
import type { Account, Category, CreateCategoryInput, UpdateAccountInput } from "../types";
import { AccountType, CategoryType } from "../types";
import { formatCurrency } from "../utils/format";

const CURRENCIES = ["EUR", "RON", "USD", "GBP"];

const ACCOUNT_TYPE_OPTIONS: { value: AccountType; label: string }[] = [
  { value: AccountType.Checking, label: "Checking" },
  { value: AccountType.Savings, label: "Savings" },
  { value: AccountType.CreditCard, label: "Credit Card" },
  { value: AccountType.Cash, label: "Cash" },
];

const EMOJI_ICONS = [
  "💼", "🧑‍💻", "🏦", "🎁", "🍔", "🛒", "🏠", "💡", "🚗", "🛍️",
  "🎮", "🏥", "✈️", "📺", "📦", "☕", "📱", "🎵", "💊", "🧾",
  "⛽", "📚", "💰", "🎓", "🐶", "👶", "⚽", "🎯",
  "🍽️", "🍕", "🥗", "🍣", "🍷", "🥐", "🍎", "🥦", "🥛", "🍞",
  "🚌", "🚇", "🚕", "🚲", "🛴", "🚂", "🛫", "🧳", "🗺️", "🏝️",
  "🧹", "🧺", "🧻", "🛁", "🔧", "🔨", "🛠️", "🔌", "🔋", "⚡",
  "👕", "👗", "👟", "🧥", "🕶️", "💍", "👜", "🧢",
  "💄", "💅", "💇", "🏋️", "🧘", "🏃", "⛸️", "🎾", "🏀", "🎳",
  "✏️", "📝", "🗞️", "📰", "💻", "🖥️", "🎧", "🕹️", "📷", "🎬",
  "🎉", "🎂", "🥳", "🎄", "🎃", "🎆", "🎫", "🎟️", "🎨", "🎤",
  "♥️", "🥰", "🤝", "👨‍🍼", "🐱", "🐾", "🐷", "🍼", "🚼", "🧸",
  "🦷", "👓", "🌳", "🌡️", "🔥", "❄️", "💧", "🌱", "♻️", "🧯",
  "🚬", "🚚", "🛡️", "🔒", "💳", "💸", "🪙", "🧧", "🏷️", "📈",
];

interface CategoryDialogProps {
  open: boolean;
  onClose: () => void;
  initial: Category | null;
  onSave: (input: CreateCategoryInput) => Promise<void>;
}

function CategoryDialog({ open, onClose, initial, onSave }: CategoryDialogProps) {
  const [name, setName] = useState(initial?.name ?? "");
  const [type, setType] = useState<CategoryType>(initial?.type ?? CategoryType.Expense);
  const [icon, setIcon] = useState(initial?.icon || "🛒");
  const [color, setColor] = useState(initial?.color ?? "#EF5350");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  const handleSave = async () => {
    if (!name.trim()) {
      setError("Name is required.");
      return;
    }
    setSubmitting(true);
    try {
      await onSave({ name: name.trim(), type, icon, color });
      onClose();
    } catch {
      setError("Could not save category. It may already exist.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="xs">
      <DialogTitle>{initial ? "Edit category" : "Add category"}</DialogTitle>
      <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 2 }}>
        <TextField
          label="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          fullWidth
          autoFocus
        />
        <ToggleButtonGroup
          exclusive
          fullWidth
          value={type}
          onChange={(_, v) => v !== null && setType(v)}
        >
          <ToggleButton value={CategoryType.Income}>Income</ToggleButton>
          <ToggleButton value={CategoryType.Expense}>Expense</ToggleButton>
        </ToggleButtonGroup>
        <Box>
          <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
            Icon
          </Typography>
          <Box sx={{ display: "flex", flexWrap: "wrap", gap: 0.5 }}>
            {EMOJI_ICONS.map((e) => (
              <Button
                key={e}
                size="small"
                variant={icon === e ? "contained" : "outlined"}
                onClick={() => setIcon(e)}
                sx={{ minWidth: 40, px: 1 }}
              >
                {e}
              </Button>
            ))}
          </Box>
        </Box>
        <TextField
          label="Color"
          type="color"
          value={color}
          onChange={(e) => setColor(e.target.value)}
          fullWidth
        />
        {error && (
          <Typography variant="body2" color="error">
            {error}
          </Typography>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={handleSave} disabled={submitting}>
          Save
        </Button>
      </DialogActions>
    </Dialog>
  );
}

interface AccountDialogProps {
  open: boolean;
  onClose: () => void;
  initial: Account | null;
  onSave: (input: UpdateAccountInput) => Promise<void>;
}

function toDateInputValue(date: string): string {
  return date.slice(0, 10);
}

function numberOrNull(value: string): number | null {
  const parsed = Number(value);
  return !Number.isNaN(parsed) && value.trim() !== "" ? parsed : null;
}

function intOrNull(value: string): number | null {
  const parsed = parseInt(value, 10);
  return !Number.isNaN(parsed) ? parsed : null;
}

function AccountDialog({ open, onClose, initial, onSave }: AccountDialogProps) {
  const [name, setName] = useState(initial?.name ?? "");
  const [type, setType] = useState<AccountType>(initial?.type ?? AccountType.Checking);
  const [currency, setCurrency] = useState(initial?.currency ?? "EUR");
  const [initialBalance, setInitialBalance] = useState(
    initial ? String(initial.initialBalance) : "",
  );
  const [balanceDate, setBalanceDate] = useState(
    toDateInputValue(initial?.balanceDate ?? new Date().toISOString().slice(0, 10)),
  );
  const [creditLimit, setCreditLimit] = useState(
    initial ? (initial.creditLimit != null ? String(initial.creditLimit) : "") : "",
  );
  const [availableCredit, setAvailableCredit] = useState(
    initial ? (initial.availableCredit != null ? String(initial.availableCredit) : "") : "",
  );
  const [outstandingBalance, setOutstandingBalance] = useState(
    initial ? (initial.outstandingBalance != null ? String(initial.outstandingBalance) : "") : "",
  );
  const [monthlyPayment, setMonthlyPayment] = useState(
    initial ? (initial.monthlyPayment != null ? String(initial.monthlyPayment) : "") : "",
  );
  const [installmentMonths, setInstallmentMonths] = useState(
    initial ? (initial.installmentMonths != null ? String(initial.installmentMonths) : "") : "",
  );
  const [installmentStartDate, setInstallmentStartDate] = useState(
    toDateInputValue(initial?.installmentStartDate ?? new Date().toISOString().slice(0, 10)),
  );
  const [interestRate, setInterestRate] = useState(
    initial ? (initial.monthlyInterestRate != null ? String(initial.monthlyInterestRate) : "") : "",
  );
  const [annualFee, setAnnualFee] = useState(
    initial ? (initial.annualFee != null ? String(initial.annualFee) : "") : "",
  );
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  const isCreditCard = type === AccountType.CreditCard;

  const handleSave = async () => {
    if (!name.trim()) {
      setError("Name is required.");
      return;
    }
    setSubmitting(true);
    try {
      await onSave({
        name: name.trim(),
        type,
        currency,
        initialBalance: Number(initialBalance) || 0,
        balanceDate,
        creditLimit: isCreditCard ? numberOrNull(creditLimit) : null,
        availableCredit: isCreditCard ? numberOrNull(availableCredit) : null,
        outstandingBalance: isCreditCard ? numberOrNull(outstandingBalance) : null,
        monthlyPayment: isCreditCard ? numberOrNull(monthlyPayment) : null,
        installmentMonths: isCreditCard ? intOrNull(installmentMonths) : null,
        installmentStartDate: isCreditCard ? installmentStartDate || null : null,
        monthlyInterestRate: isCreditCard ? numberOrNull(interestRate) : null,
        annualFee: isCreditCard ? numberOrNull(annualFee) : null,
      });
      onClose();
    } catch {
      setError("Could not save account.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="xs">
      <DialogTitle>{initial ? "Edit account" : "Add account"}</DialogTitle>
      <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 2 }}>
        <TextField
          label="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          fullWidth
          autoFocus
        />
        <FormControl fullWidth>
          <InputLabel>Type</InputLabel>
          <Select
            label="Type"
            value={type}
            onChange={(e) => setType(e.target.value as AccountType)}
          >
            {ACCOUNT_TYPE_OPTIONS.map((o) => (
              <MenuItem key={o.value} value={o.value}>
                {o.label}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        <FormControl fullWidth>
          <InputLabel>Currency</InputLabel>
          <Select label="Currency" value={currency} onChange={(e) => setCurrency(e.target.value)}>
            {CURRENCIES.map((c) => (
              <MenuItem key={c} value={c}>
                {c}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        {isCreditCard ? (
          <>
            <TextField
              label="Credit limit"
              value={creditLimit}
              onChange={(e) => setCreditLimit(e.target.value)}
              type="number"
              fullWidth
              helperText="Total amount you can borrow."
            />
            <Box
              sx={{
                display: "grid",
                gridTemplateColumns: "1fr 1fr",
                gap: 2,
              }}
            >
              <TextField
                label="Still to spend"
                value={availableCredit}
                onChange={(e) => setAvailableCredit(e.target.value)}
                type="number"
                fullWidth
                helperText="Credit still available on the card."
              />
              <TextField
                label="Still to pay back"
                value={outstandingBalance}
                onChange={(e) => setOutstandingBalance(e.target.value)}
                type="number"
                fullWidth
                helperText="Remaining debt."
              />
            </Box>
            {creditLimit.trim() !== "" && (availableCredit.trim() !== "" || outstandingBalance.trim() !== "") && (
              <Typography variant="caption" color="text.secondary">
                Auto: spent so far{" "}
                {formatCurrency(
                  Math.max(0, (numberOrNull(creditLimit) ?? 0) - (numberOrNull(availableCredit) ?? 0)),
                  currency,
                )}
                {" · "}
                paid back so far{" "}
                {formatCurrency(
                  Math.max(
                    0,
                    (numberOrNull(creditLimit) ?? 0) -
                      (numberOrNull(availableCredit) ?? 0) -
                      (numberOrNull(outstandingBalance) ?? 0),
                  ),
                  currency,
                )}
              </Typography>
            )}
            <Box
              sx={{
                display: "grid",
                gridTemplateColumns: "1fr 1fr",
                gap: 2,
              }}
            >
              <TextField
                label="Monthly payment"
                value={monthlyPayment}
                onChange={(e) => setMonthlyPayment(e.target.value)}
                type="number"
                fullWidth
              />
              <TextField
                label="Installments"
                value={installmentMonths}
                onChange={(e) => setInstallmentMonths(e.target.value)}
                type="number"
                fullWidth
              />
            </Box>
            <Box
              sx={{
                display: "grid",
                gridTemplateColumns: "1fr 1fr",
                gap: 2,
              }}
            >
              <TextField
                label="Interest (monthly %)"
                value={interestRate}
                onChange={(e) => setInterestRate(e.target.value)}
                type="number"
                fullWidth
                helperText="0 for 0% financing."
              />
              <TextField
                label="Annual fee"
                value={annualFee}
                onChange={(e) => setAnnualFee(e.target.value)}
                type="number"
                fullWidth
              />
            </Box>
            <TextField
              label="Installment start"
              value={installmentStartDate}
              onChange={(e) => setInstallmentStartDate(e.target.value)}
              type="date"
              fullWidth
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </>
        ) : (
          <>
            <TextField
              label="Balance"
              value={initialBalance}
              onChange={(e) => setInitialBalance(e.target.value)}
              type="number"
              fullWidth
            />
            <TextField
              label="Balance as of"
              value={balanceDate}
              onChange={(e) => setBalanceDate(e.target.value)}
              type="date"
              fullWidth
              helperText="Transactions after this date update the balance; earlier ones are recorded only."
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </>
        )}
        {error && (
          <Typography variant="body2" color="error">
            {error}
          </Typography>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={handleSave} disabled={submitting}>
          Save
        </Button>
      </DialogActions>
    </Dialog>
  );
}

export default function SettingsPage() {
  const { themeMode, setThemeMode } = useSettings();
  const categoriesState = useApiData<Category[]>(getCategories, "settings-categories");
  const accountsState = useApiData<Account[]>(getAccounts, "settings-accounts");
  const [categoryDialogOpen, setCategoryDialogOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Category | null>(null);
  const [deleteCategoryTarget, setDeleteCategoryTarget] = useState<Category | null>(null);
  const [accountDialogOpen, setAccountDialogOpen] = useState(false);
  const [editingAccount, setEditingAccount] = useState<Account | null>(null);

  const categories = categoriesState.data ?? [];
  const accounts = accountsState.data ?? [];

  const handleCategorySave = async (input: CreateCategoryInput) => {
    if (editingCategory) {
      await updateCategory(editingCategory.id, input);
      toast.success("Category updated");
    } else {
      await createCategory(input);
      toast.success("Category added");
    }
    await categoriesState.reload();
    setEditingCategory(null);
  };

  const handleCategoryDelete = (category: Category) => setDeleteCategoryTarget(category);

  const confirmCategoryDelete = async () => {
    if (!deleteCategoryTarget) return;
    try {
      await deleteCategory(deleteCategoryTarget.id);
      toast.success("Category deleted");
      await categoriesState.reload();
    } catch {
      toast.error("Could not delete category.");
    }
    setDeleteCategoryTarget(null);
  };

  const handleAccountSave = async (input: UpdateAccountInput) => {
    if (editingAccount) {
      await updateAccount(editingAccount.id, input);
      toast.success("Account updated");
    } else {
      await createAccount(input);
      toast.success("Account added");
    }
    await accountsState.reload();
    setEditingAccount(null);
  };

  return (
    <Stack spacing={3}>
      <Box>
        <Typography variant="h5" sx={{ fontWeight: 700 }}>
          Settings
        </Typography>
        <Typography variant="body2" color="text.secondary">
          Appearance, categories and accounts — switch display currency from the top bar
        </Typography>
      </Box>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 6 }}>
          <Stack spacing={2}>
            <Card>
              <CardContent>
                <Typography variant="h6">Appearance</Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                  Choose between light and dark mode.
                </Typography>
                <FormControlLabel
                  control={
                    <Switch
                      checked={themeMode === "dark"}
                      onChange={(e) => setThemeMode(e.target.checked ? "dark" : "light")}
                    />
                  }
                  label="Dark mode"
                />
              </CardContent>
            </Card>

            <Card>
              <CardContent>
                <Box
                  sx={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    mb: 1.5,
                  }}
                >
                  <Typography variant="h6">Accounts</Typography>
                  <Button
                    size="small"
                    variant="outlined"
                    startIcon={<AddIcon />}
                    onClick={() => {
                      setEditingAccount(null);
                      setAccountDialogOpen(true);
                    }}
                  >
                    Add
                  </Button>
                </Box>
                <Stack spacing={1}>
                  {accounts.map((a) => (
                    <Box
                      key={a.id}
                      sx={{
                        display: "flex",
                        justifyContent: "space-between",
                        alignItems: "center",
                      }}
                    >
                      <Box>
                        <Typography variant="body2" sx={{ fontWeight: 600 }}>
                          {a.name}
                        </Typography>
                        <Typography variant="caption" color="text.secondary">
                          {ACCOUNT_TYPE_OPTIONS.find((o) => o.value === a.type)?.label}
                          {a.type === AccountType.CreditCard && a.creditLimit != null
                            ? ` · limit ${formatCurrency(a.creditLimit, a.currency)} · avail ${formatCurrency(
                                Math.max(0, a.creditLimit - (a.outstandingBalance ?? 0)),
                                a.currency,
                              )}`
                            : ` · ${a.currency} · as of ${a.balanceDate.slice(0, 10)}`}
                          {a.type !== AccountType.CreditCard &&
                            a.balance !== a.initialBalance &&
                            ` · initial ${formatCurrency(a.initialBalance, a.currency)}`}
                        </Typography>
                      </Box>
                      <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
                        <Typography variant="body2" sx={{ fontWeight: 600 }}>
                          {a.type === AccountType.CreditCard
                            ? `owe ${formatCurrency(a.outstandingBalance ?? 0, a.currency)}`
                            : formatCurrency(a.balance, a.currency)}
                        </Typography>
                        <IconButton
                          size="small"
                          aria-label={`Edit ${a.name}`}
                          onClick={() => {
                            setEditingAccount(a);
                            setAccountDialogOpen(true);
                          }}
                        >
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Box>
                    </Box>
                  ))}
                </Stack>
              </CardContent>
            </Card>
          </Stack>
        </Grid>

        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Box
                sx={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  mb: 1.5,
                }}
              >
                <Typography variant="h6">Categories</Typography>
                <Button
                  size="small"
                  variant="outlined"
                  startIcon={<AddIcon />}
                  onClick={() => {
                    setEditingCategory(null);
                    setCategoryDialogOpen(true);
                  }}
                >
                  Add
                </Button>
              </Box>
              <Stack spacing={1}>
                {categories.map((c) => (
                  <Box
                    key={c.id}
                    sx={{
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "center",
                      gap: 1,
                    }}
                  >
                    <Chip
                      size="small"
                      label={`${c.icon} ${c.name}`}
                      sx={{ bgcolor: `${c.color}22` }}
                    />
                    <Box>
                      <Typography variant="caption" color="text.secondary" sx={{ mr: 1 }}>
                        {c.type === CategoryType.Income
                          ? "Income"
                          : c.type === CategoryType.Expense
                            ? "Expense"
                            : "Transfer"}
                      </Typography>
                      {c.type !== CategoryType.Transfer && (
                        <>
                          <IconButton
                            size="small"
                            onClick={() => {
                              setEditingCategory(c);
                              setCategoryDialogOpen(true);
                            }}
                          >
                            <EditIcon fontSize="small" />
                          </IconButton>
                          {!c.isCardPayment && (
                            <IconButton
                              size="small"
                              color="error"
                              onClick={() => handleCategoryDelete(c)}
                            >
                              <DeleteIcon fontSize="small" />
                            </IconButton>
                          )}
                        </>
                      )}
                    </Box>
                  </Box>
                ))}
              </Stack>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <CategoryDialog
        key={categoryDialogOpen ? "category-dialog-open" : "category-dialog-closed"}
        open={categoryDialogOpen}
        onClose={() => setCategoryDialogOpen(false)}
        initial={editingCategory}
        onSave={handleCategorySave}
      />
      <AccountDialog
        key={
          accountDialogOpen
            ? `account-dialog-open-${editingAccount?.id ?? "new"}`
            : "account-dialog-closed"
        }
        open={accountDialogOpen}
        onClose={() => {
          setAccountDialogOpen(false);
          setEditingAccount(null);
        }}
        initial={editingAccount}
        onSave={handleAccountSave}
      />

      <ConfirmDialog
        open={deleteCategoryTarget != null}
        title="Delete category"
        message={`Delete "${deleteCategoryTarget?.name}"? Transactions using it will also be removed.`}
        onClose={() => setDeleteCategoryTarget(null)}
        onConfirm={confirmCategoryDelete}
      />
    </Stack>
  );
}