import { AssetType, InvestmentTransactionType as TxType } from "../types";

export const ASSET_TYPE_LABELS: Record<number, string> = {
  [AssetType.Stock]: "Stock",
  [AssetType.ETF]: "ETF",
  [AssetType.Fund]: "Fund",
  [AssetType.Bond]: "Bond",
  [AssetType.Crypto]: "Crypto",
  [AssetType.Cash]: "Cash",
  [AssetType.Other]: "Other",
};

export const INVESTMENT_TYPE_LABELS: Record<number, string> = {
  [TxType.Buy]: "Buy",
  [TxType.Sell]: "Sell",
  [TxType.Dividend]: "Dividend",
  [TxType.Interest]: "Interest",
  [TxType.Fee]: "Fee",
  [TxType.TransferIn]: "Transfer in",
  [TxType.TransferOut]: "Transfer out",
};