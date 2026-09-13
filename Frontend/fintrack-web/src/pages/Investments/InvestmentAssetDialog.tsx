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
  createInvestmentAsset,
  updateInvestmentAsset,
} from "../../services/investmentService";
import type { InvestmentAsset } from "../../types";
import { AssetType } from "../../types";
import { ASSET_TYPE_LABELS } from "../../utils/investmentLabels";

const CURRENCIES = ["EUR", "USD", "RON", "GBP", "CHF"];

interface Props {
  open: boolean;
  onClose: () => void;
  asset?: InvestmentAsset | null;
  onSaved: () => void;
}

export function InvestmentAssetDialog({ open, onClose, asset, onSaved }: Props) {
  const [ticker, setTicker] = useState(asset?.ticker ?? "");
  const [name, setName] = useState(asset?.name ?? "");
  const [type, setType] = useState<number>(asset?.type ?? AssetType.Stock);
  const [assetCurrency, setAssetCurrency] = useState(asset?.currency ?? "EUR");
  const [symbolOverride, setSymbolOverride] = useState(asset?.stooqSymbol ?? "");
  const [manualPrice, setManualPrice] = useState(
    asset?.manualPrice != null ? String(asset.manualPrice) : "",
  );
  const [saving, setSaving] = useState(false);

  const handleSubmit = async () => {
    if (!ticker.trim() || !name.trim()) {
      toast.error("Please enter a ticker and name.");
      return;
    }
    setSaving(true);
    try {
      const input = {
        ticker: ticker.trim().toUpperCase(),
        name: name.trim(),
        type: type as never,
        currency: assetCurrency,
        manualPrice: manualPrice ? Number(manualPrice) : null,
        stooqSymbol: symbolOverride.trim() || null,
      };
      if (asset) {
        await updateInvestmentAsset(asset.id, input);
        toast.success("Asset updated");
      } else {
        await createInvestmentAsset(input);
        toast.success("Asset added");
      }
      onSaved();
      onClose();
    } catch {
      toast.error("Could not save asset.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
      <DialogTitle>{asset ? "Edit asset" : "Add asset"}</DialogTitle>
      <DialogContent>
        <Stack spacing={2} sx={{ pt: 1 }}>
          <TextField
            size="small"
            label="Ticker"
            value={ticker}
            onChange={(e) => setTicker(e.target.value)}
            disabled={!!asset}
          />
          <TextField
            size="small"
            label="Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
          <TextField
            select
            size="small"
            label="Type"
            value={type}
            onChange={(e) => setType(Number(e.target.value))}
          >
            {Object.entries(ASSET_TYPE_LABELS).map(([value, label]) => (
              <MenuItem key={value} value={Number(value)}>
                {label}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            select
            size="small"
            label="Currency"
            value={assetCurrency}
            onChange={(e) => setAssetCurrency(e.target.value)}
          >
            {CURRENCIES.map((c) => (
              <MenuItem key={c} value={c}>
                {c}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            size="small"
            label="Symbol override (optional)"
            value={symbolOverride}
            onChange={(e) => setSymbolOverride(e.target.value)}
            helperText="Provider symbol used for live prices, e.g. VWCE.DE"
          />
          <TextField
            size="small"
            label="Manual price override"
            type="number"
            value={manualPrice}
            onChange={(e) => setManualPrice(e.target.value)}
            slotProps={{ htmlInput: { step: "any" } }}
            helperText="When set, live prices are ignored for this asset."
          />
        </Stack>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={handleSubmit} disabled={saving}>
          {saving ? "Saving…" : asset ? "Update" : "Add"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}