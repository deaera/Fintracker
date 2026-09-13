import { useMemo, useState } from "react";
import dayjs from "dayjs";
import toast from "react-hot-toast";
import {
  Box,
  Button,
  Card,
  CardContent,
  CircularProgress,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  IconButton,
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
import PriceChangeIcon from "@mui/icons-material/PriceChange";
import { useSettings } from "../../context/settings";
import { useApiData } from "../../hooks/useApiData";
import {
  addManualPrice,
  deleteInvestmentAccount,
  deleteInvestmentAsset,
  getInvestmentAccounts,
  getInvestmentAssets,
} from "../../services/investmentService";
import type { InvestmentAccount, InvestmentAsset } from "../../types";
import { formatCurrency } from "../../utils/format";
import InvestmentAccountDialog from "./InvestmentAccountDialog";
import { ASSET_TYPE_LABELS } from "../../utils/investmentLabels";
import { InvestmentAssetDialog } from "./InvestmentAssetDialog";

export default function AccountsTab() {
  const { currency, convert } = useSettings();
  const accountsState = useApiData(getInvestmentAccounts, "invest-accounts");
  const assetsState = useApiData(getInvestmentAssets, "invest-assets");

  const [accountDialogOpen, setAccountDialogOpen] = useState(false);
  const [editingAccount, setEditingAccount] = useState<InvestmentAccount | null>(null);
  const [assetDialogOpen, setAssetDialogOpen] = useState(false);
  const [editingAsset, setEditingAsset] = useState<InvestmentAsset | null>(null);
  const [priceAsset, setPriceAsset] = useState<InvestmentAsset | null>(null);
  const [priceDate, setPriceDate] = useState(dayjs().format("YYYY-MM-DD"));
  const [priceValue, setPriceValue] = useState("");
  const [savingPrice, setSavingPrice] = useState(false);

  const accounts = useMemo(() => accountsState.data ?? [], [accountsState.data]);
  const assets = useMemo(() => assetsState.data ?? [], [assetsState.data]);

  if (accountsState.loading || assetsState.loading) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 12 }}>
        <CircularProgress />
      </Box>
    );
  }

  const handleDeleteAccount = async (id: string, name: string) => {
    if (!window.confirm(`Delete account "${name}" and all of its transactions?`)) return;
    try {
      await deleteInvestmentAccount(id);
      toast.success("Account deleted");
      await accountsState.reload();
    } catch {
      toast.error("Could not delete account. It may have transactions.");
    }
  };

  const handleDeleteAsset = async (a: InvestmentAsset) => {
    if (!window.confirm(`Delete asset "${a.ticker}"?`)) return;
    try {
      await deleteInvestmentAsset(a.id);
      toast.success("Asset deleted");
      await assetsState.reload();
    } catch {
      toast.error("Could not delete asset. It may be used by transactions.");
    }
  };

  const handleSavePrice = async () => {
    if (!priceAsset) return;
    if (!(Number(priceValue) > 0)) {
      toast.error("Please enter a price.");
      return;
    }
    setSavingPrice(true);
    try {
      await addManualPrice(priceAsset.id, { date: priceDate, price: Number(priceValue) });
      toast.success("Manual price added");
      setPriceAsset(null);
      setPriceValue("");
      await assetsState.reload();
    } catch {
      toast.error("Could not save price.");
    } finally {
      setSavingPrice(false);
    }
  };

  return (
    <Stack spacing={3}>
      <Card>
        <CardContent>
          <Box
            sx={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
              mb: 2,
            }}
          >
            <Typography variant="h6">Broker accounts</Typography>
            <Button
              variant="contained"
              startIcon={<AddIcon />}
              onClick={() => {
                setEditingAccount(null);
                setAccountDialogOpen(true);
              }}
            >
              Add account
            </Button>
          </Box>
          <TableContainer>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Account</TableCell>
                  <TableCell>Institution</TableCell>
                  <TableCell align="right">Opening</TableCell>
                  <TableCell align="right">Cash</TableCell>
                  <TableCell align="right">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {accounts.map((a) => (
                  <TableRow key={a.id} hover>
                    <TableCell>
                      <Typography sx={{ fontWeight: 600 }}>{a.name}</Typography>
                    </TableCell>
                    <TableCell>{a.institution || "—"}</TableCell>
                    <TableCell align="right">
                      {formatCurrency(convert(a.openingBalance), currency)}
                    </TableCell>
                    <TableCell align="right" sx={{ fontWeight: 600 }}>
                      {formatCurrency(convert(a.cashBalance), currency)}
                    </TableCell>
                    <TableCell align="right">
                      <IconButton
                        size="small"
                        onClick={() => {
                          setEditingAccount(a);
                          setAccountDialogOpen(true);
                        }}
                      >
                        <EditIcon fontSize="small" />
                      </IconButton>
                      <IconButton
                        size="small"
                        color="error"
                        onClick={() => handleDeleteAccount(a.id, a.name)}
                      >
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                ))}
                {accounts.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={5} align="center" sx={{ py: 4, color: "text.secondary" }}>
                      No broker accounts yet.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </TableContainer>
        </CardContent>
      </Card>

      <Card>
        <CardContent>
          <Box
            sx={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
              mb: 2,
            }}
          >
            <Typography variant="h6">Asset library</Typography>
            <Button
              variant="outlined"
              startIcon={<AddIcon />}
              onClick={() => {
                setEditingAsset(null);
                setAssetDialogOpen(true);
              }}
            >
              Add asset
            </Button>
          </Box>
          <TableContainer>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Ticker</TableCell>
                  <TableCell>Name</TableCell>
                  <TableCell>Type</TableCell>
                  <TableCell>Currency</TableCell>
                  <TableCell align="right">Price</TableCell>
                  <TableCell align="right">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {assets.map((a) => (
                  <TableRow key={a.id} hover>
                    <TableCell sx={{ fontWeight: 600 }}>{a.ticker}</TableCell>
                    <TableCell>{a.name}</TableCell>
                    <TableCell>{ASSET_TYPE_LABELS[a.type] ?? "Other"}</TableCell>
                    <TableCell>{a.currency}</TableCell>
                    <TableCell align="right">
                      {a.manualPrice != null
                        ? `${formatCurrency(a.manualPrice, a.currency)} (manual)`
                        : a.stooqSymbol ?? "auto"}
                    </TableCell>
                    <TableCell align="right">
                      <IconButton size="small" onClick={() => setPriceAsset(a)}>
                        <PriceChangeIcon fontSize="small" />
                      </IconButton>
                      <IconButton
                        size="small"
                        onClick={() => {
                          setEditingAsset(a);
                          setAssetDialogOpen(true);
                        }}
                      >
                        <EditIcon fontSize="small" />
                      </IconButton>
                      <IconButton
                        size="small"
                        color="error"
                        onClick={() => handleDeleteAsset(a)}
                      >
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                ))}
                {assets.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={6} align="center" sx={{ py: 4, color: "text.secondary" }}>
                      No assets defined yet.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </TableContainer>
        </CardContent>
      </Card>

      <InvestmentAccountDialog
        key={accountDialogOpen ? (editingAccount?.id ?? "new") : "closed"}
        open={accountDialogOpen}
        onClose={() => setAccountDialogOpen(false)}
        account={editingAccount}
        onSaved={async () => {
          await accountsState.reload();
        }}
      />

      <InvestmentAssetDialog
        key={assetDialogOpen ? (editingAsset?.id ?? "new") : "closed"}
        open={assetDialogOpen}
        onClose={() => setAssetDialogOpen(false)}
        asset={editingAsset}
        onSaved={async () => {
          await assetsState.reload();
        }}
      />

      <Dialog
        open={priceAsset != null}
        onClose={() => setPriceAsset(null)}
        fullWidth
        maxWidth="xs"
      >
        <DialogTitle>Add price for {priceAsset?.ticker}</DialogTitle>
        <DialogContent>
          <Stack spacing={2} sx={{ pt: 1 }}>
            <TextField
              size="small"
              type="date"
              label="Date"
              value={priceDate}
              onChange={(e) => setPriceDate(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
            <TextField
              size="small"
              label="Price"
              type="number"
              value={priceValue}
              onChange={(e) => setPriceValue(e.target.value)}
              slotProps={{ htmlInput: { step: "any" } }}
            />
          </Stack>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setPriceAsset(null)}>Cancel</Button>
          <Button variant="contained" onClick={handleSavePrice} disabled={savingPrice}>
            {savingPrice ? "Saving…" : "Add price"}
          </Button>
        </DialogActions>
      </Dialog>
    </Stack>
  );
}