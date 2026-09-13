import { useMemo, useState } from "react";
import dayjs from "dayjs";
import toast from "react-hot-toast";
import {
  Alert,
  Box,
  Button,
  Card,
  CardContent,
  Chip,
  CircularProgress,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
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
import PriceChangeIcon from "@mui/icons-material/PriceChange";
import UploadFileIcon from "@mui/icons-material/UploadFile";
import { useSettings } from "../../context/settings";
import { useApiData } from "../../hooks/useApiData";
import {
  addManualPrice,
  commitXtbImport,
  deleteInvestmentAccount,
  deleteInvestmentAsset,
  getInvestmentAccounts,
  getInvestmentAssets,
  parseXtbImport,
  parseXtbWorkbook,
} from "../../services/investmentService";
import type { InvestmentAccount, InvestmentAsset } from "../../types";
import { formatCurrency } from "../../utils/format";
import InvestmentAccountDialog from "./InvestmentAccountDialog";
import { ASSET_TYPE_LABELS, INVESTMENT_TYPE_LABELS } from "../../utils/investmentLabels";
import { InvestmentAssetDialog } from "./InvestmentAssetDialog";
import type { XtbImportParseResponse } from "../../types";

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
  const [cashRows, setCashRows] = useState("");
  const [openPositions, setOpenPositions] = useState("");
  const [xlsxFile, setXlsxFile] = useState<File | null>(null);
  const [importCurrency, setImportCurrency] = useState("EUR");
  const [importAccountName, setImportAccountName] = useState("XTB");
  const [preview, setPreview] = useState<XtbImportParseResponse | null>(null);
  const [parsing, setParsing] = useState(false);
  const [importing, setImporting] = useState(false);

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

  const handleParse = async () => {
    if (!cashRows.trim()) {
      toast.error("Paste the Cash Operations rows first.");
      return;
    }
    setParsing(true);
    try {
      const result = await parseXtbImport({
        cashRows,
        openPositions: openPositions.trim() ? openPositions : undefined,
        accountCurrency: importCurrency,
      });
      setPreview(result);
      toast.success(`Parsed ${result.supportedCount} supported rows`);
    } catch {
      toast.error("Could not parse the pasted data.");
    } finally {
      setParsing(false);
    }
  };

  const handleParseFile = async () => {
    if (!xlsxFile) {
      toast.error("Choose an .xlsx report first.");
      return;
    }
    setParsing(true);
    try {
      const result = await parseXtbWorkbook(xlsxFile, importCurrency);
      setPreview(result);
      toast.success(
        `Parsed ${result.supportedCount} rows from ${result.parsedSheets.join(", ")}`,
      );
    } catch (err) {
      const data = (err as { response?: { data?: unknown } })?.response?.data;
      const detail =
        typeof data === "string" && data.trim()
          ? data
          : (data as { message?: string } | null | undefined)?.message;
      toast.error(
        detail ||
          "Could not parse the workbook. Make sure the backend is running the latest build and the file is an XTB .xlsx export.",
      );
    } finally {
      setParsing(false);
    }
  };

  const handleCommit = async () => {
    if (!preview) return;
    const confirmed = window.confirm(
      `Import ${preview.supportedCount} transactions into "${importAccountName}"?\n\nExisting transactions are kept — anything already in the account is skipped.`,
    );
    if (!confirmed) return;
    setImporting(true);
    try {
      const result = await commitXtbImport({
        accountName: importAccountName,
        accountCurrency: importCurrency,
        cashRows: preview.cashRows || cashRows,
      });
      toast.success(
        result.skipped > 0
          ? `Imported ${result.imported} transactions (${result.skipped} already present, skipped)`
          : `Imported ${result.imported} transactions`,
      );
      setPreview(null);
      setCashRows("");
      setOpenPositions("");
      setXlsxFile(null);
      await Promise.all([accountsState.reload(), assetsState.reload()]);
    } catch {
      toast.error("Import failed. Check that sales never exceed buys.");
    } finally {
      setImporting(false);
    }
  };

  const mismatches = preview?.reconciliation?.filter((r) => !r.match) ?? [];

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
            <Box>
              <Typography variant="h6">Import from XTB</Typography>
              <Typography variant="body2" color="text.secondary">
                Upload an .xlsx export (Cash Operations + Open/Closed Positions), or paste the
                Cash Operations columns.
              </Typography>
            </Box>
          </Box>
          <Stack spacing={2}>
            <Stack
              direction={{ xs: "column", sm: "row" }}
              spacing={2}
              sx={{ alignItems: "center", flexWrap: "wrap" }}
            >
              <TextField
                size="small"
                label="Account name"
                value={importAccountName}
                onChange={(e) => setImportAccountName(e.target.value)}
                sx={{ width: 180 }}
              />
              <TextField
                select
                size="small"
                label="Account currency"
                value={importCurrency}
                onChange={(e) => setImportCurrency(e.target.value)}
                sx={{ width: 180 }}
              >
                {["EUR", "USD", "RON", "GBP", "PLN", "HUF", "CZK"].map((c) => (
                  <MenuItem key={c} value={c}>
                    {c}
                  </MenuItem>
                ))}
              </TextField>
              <Stack direction="row" spacing={1} sx={{ alignItems: "center" }}>
                <Button variant="outlined" component="label" startIcon={<UploadFileIcon />}>
                  {xlsxFile ? xlsxFile.name : "Choose .xlsx report"}
                  <input
                    type="file"
                    accept=".xlsx"
                    hidden
                    onChange={(e) => {
                      const f = e.target.files?.[0] ?? null;
                      setXlsxFile(f);
                      if (f) setPreview(null);
                    }}
                  />
                </Button>
                <Button
                  variant="contained"
                  onClick={handleParseFile}
                  disabled={!xlsxFile || parsing || importing}
                >
                  {parsing ? "Parsing…" : "Parse file"}
                </Button>
              </Stack>
            </Stack>
            <Typography variant="overline" color="text.secondary">
              or paste
            </Typography>
            <TextField
              label="Cash operations (Type / Name / Ticker / Class / Date / Amount / ID / Note)"
              multiline
              minRows={8}
              fullWidth
              value={cashRows}
              onChange={(e) => setCashRows(e.target.value)}
              sx={{ fontFamily: "monospace" }}
            />
            <TextField
              label="Open positions (optional, for reconciliation)"
              multiline
              minRows={3}
              fullWidth
              value={openPositions}
              onChange={(e) => setOpenPositions(e.target.value)}
              sx={{ fontFamily: "monospace" }}
            />
            <Box>
              <Button variant="contained" onClick={handleParse} disabled={parsing || importing}>
                {parsing ? "Parsing…" : "Parse"}
              </Button>
              {preview && (
                <Button
                  variant="outlined"
                  onClick={handleCommit}
                  disabled={importing || preview.supportedCount === 0}
                  sx={{ ml: 1 }}
                >
                  {importing
                    ? "Importing…"
                    : `Import ${preview.supportedCount} transactions`}
                </Button>
              )}
            </Box>

            {preview && (
              <>
                <Stack direction="row" spacing={1} sx={{ flexWrap: "wrap" }}>
                  <Chip size="small" label={`${preview.totalCount} rows parsed`} />
                  <Chip
                    size="small"
                    color="success"
                    label={`${preview.supportedCount} to import`}
                  />
                  {preview.skippedCount > 0 && (
                    <Chip size="small" color="warning" label={`${preview.skippedCount} skipped`} />
                  )}
                  {preview.newAssets > 0 && (
                    <Chip size="small" color="info" label={`${preview.newAssets} new assets`} />
                  )}
                  <Chip
                    size="small"
                    color={preview.skippedCount > 0 ? "warning" : "default"}
                    label={`Ending cash ${formatCurrency(preview.finalCash, preview.accountCurrency)}`}
                  />
                </Stack>

                {mismatches.length > 0 && (
                  <Alert severity="warning">
                    Open positions don't match the cash ledger for:{" "}
                    {mismatches.map((m) => `${m.ticker} (expected ${m.expectedQuantity}, imported ${m.importedQuantity})`).join(", ")}
                  </Alert>
                )}

                {preview.reconciliation && mismatches.length === 0 && (
                  <Alert severity="success">
                    Open positions match the imported ledger for all {preview.reconciliation.length} tickers.
                  </Alert>
                )}

                {preview.sourceFile && (
                  <Alert severity="info" icon={false}>
                    Read <b>{preview.sourceFile}</b> → {preview.parsedSheets.join(", ")}
                  </Alert>
                )}

                {preview.closedPositions && preview.closedPositions.length > 0 && (
                  <>
                    <Typography variant="subtitle2">Closed positions (broker report vs computed)</Typography>
                    <Table size="small">
                      <TableHead>
                        <TableRow>
                          <TableCell>Ticker</TableCell>
                          <TableCell align="right">Trades</TableCell>
                          <TableCell align="right">Broker P&L</TableCell>
                          <TableCell align="right">Computed P&L</TableCell>
                          <TableCell align="right">Diff</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {preview.closedPositions.map((c) => {
                          const diff = c.brokerProfit - c.computedProfit;
                          return (
                            <TableRow key={c.ticker} hover>
                              <TableCell sx={{ fontWeight: 600 }}>{c.ticker}</TableCell>
                              <TableCell align="right">{c.trades}</TableCell>
                              <TableCell align="right">
                                {formatCurrency(c.brokerProfit, preview.accountCurrency)}
                              </TableCell>
                              <TableCell align="right">
                                {formatCurrency(c.computedProfit, preview.accountCurrency)}
                              </TableCell>
                              <TableCell align="right">
                                <Typography
                                  component="span"
                                  sx={{ color: Math.abs(diff) > 0.05 ? "warning.main" : "success.main" }}
                                >
                                  {formatCurrency(diff, preview.accountCurrency)}
                                </Typography>
                              </TableCell>
                            </TableRow>
                          );
                        })}
                      </TableBody>
                    </Table>
                  </>
                )}

                <TableContainer sx={{ maxHeight: 320 }}>
                  <Table size="small" stickyHeader>
                    <TableHead>
                      <TableRow>
                        <TableCell>Type</TableCell>
                        <TableCell>Date</TableCell>
                        <TableCell>Ticker</TableCell>
                        <TableCell>Name</TableCell>
                        <TableCell align="right">Qty</TableCell>
                        <TableCell align="right">Price</TableCell>
                        <TableCell align="right">Amount</TableCell>
                        <TableCell>Note</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {preview.rows.map((r, i) => (
                        <TableRow
                          key={i}
                          hover
                          sx={r.supported ? undefined : { opacity: 0.55 }}
                        >
                          <TableCell>
                            {r.type != null ? (
                              <Chip
                                size="small"
                                label={INVESTMENT_TYPE_LABELS[r.type] ?? "?"}
                                variant="outlined"
                              />
                            ) : (
                              <Typography variant="body2">{r.rawType}</Typography>
                            )}
                          </TableCell>
                          <TableCell>{r.supported ? r.date : "—"}</TableCell>
                          <TableCell sx={{ fontWeight: 600 }}>{r.ticker || "—"}</TableCell>
                          <TableCell>{r.name || "—"}</TableCell>
                          <TableCell align="right">{r.supported ? r.quantity : "—"}</TableCell>
                          <TableCell align="right">{r.supported ? r.price : "—"}</TableCell>
                          <TableCell align="right">{r.supported ? formatCurrency(Math.abs(r.amount), preview.accountCurrency) : "—"}</TableCell>
                          <TableCell sx={{ color: "text.secondary" }}>
                            <Typography variant="body2">
                              {r.supported ? r.note : r.reason}
                            </Typography>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
              </>
            )}
          </Stack>
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