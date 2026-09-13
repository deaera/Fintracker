import dayjs from "dayjs";

export function formatCurrency(amount: number, currency: string): string {
  try {
    return new Intl.NumberFormat(undefined, {
      style: "currency",
      currency,
      maximumFractionDigits: 2,
    }).format(amount);
  } catch {
    return `${currency} ${amount.toFixed(2)}`;
  }
}

export function formatDate(date: string): string {
  return dayjs(date).format("MMM D, YYYY");
}

export function monthLabel(year: number, month: number): string {
  return dayjs(new Date(year, month - 1, 1)).format("MMM YY");
}

export function monthName(month: number): string {
  return dayjs(new Date(2026, month - 1, 1)).format("MMMM");
}