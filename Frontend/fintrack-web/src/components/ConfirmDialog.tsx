import { useState } from "react";
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Typography,
} from "@mui/material";

interface Props {
  open: boolean;
  title: string;
  message?: React.ReactNode;
  confirmLabel?: string;
  tone?: "error" | "primary";
  onClose: () => void;
  onConfirm: () => void | Promise<void>;
}

export default function ConfirmDialog({
  open,
  title,
  message,
  confirmLabel = "Delete",
  tone = "error",
  onClose,
  onConfirm,
}: Props) {
  const [busy, setBusy] = useState(false);

  const handleConfirm = async () => {
    setBusy(true);
    try {
      await onConfirm();
    } finally {
      setBusy(false);
    }
  };

  return (
    <Dialog open={open} onClose={busy ? undefined : onClose} fullWidth maxWidth="xs">
      <DialogTitle>{title}</DialogTitle>
      {message && (
        <DialogContent>
          <Typography variant="body2" color="text.secondary">
            {message}
          </Typography>
        </DialogContent>
      )}
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} disabled={busy}>
          Cancel
        </Button>
        <Button color={tone} variant="contained" onClick={handleConfirm} disabled={busy}>
          {busy ? "Working…" : confirmLabel}
        </Button>
      </DialogActions>
    </Dialog>
  );
}