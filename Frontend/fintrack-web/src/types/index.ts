export const AccountType = { Checking: 0, Savings: 1, CreditCard: 2, Cash: 3 } as const;
export type AccountType = (typeof AccountType)[keyof typeof AccountType];

export const CategoryType = { Income: 0, Expense: 1 } as const;
export type CategoryType = (typeof CategoryType)[keyof typeof CategoryType];

export interface Category {
  id: string;
  name: string;
  type: CategoryType;
  icon: string;
  color: string;
}

export interface Account {
  id: string;
  name: string;
  type: AccountType;
  currency: string;
  initialBalance: number;
}

export interface CashTransaction {
  id: string;
  date: string;
  amount: number;
  description: string;
  accountId: string;
  accountName: string;
  categoryId: string;
  categoryName: string;
  categoryType: CategoryType;
}

export interface CategorySummary {
  category: string;
  amount: number;
  color: string;
}

export interface LatestTransaction {
  id: string;
  date: string;
  description: string;
  amount: number;
  category: string;
  categoryType: CategoryType;
  account: string;
}

export interface MonthlyTrend {
  year: number;
  month: number;
  income: number;
  expenses: number;
  savings: number;
}

export interface Dashboard {
  totalBalance: number;
  income: number;
  expenses: number;
  savings: number;
  savingsRate: number;
  investmentValue: number;
  netWorth: number;
  expensesByCategory: CategorySummary[];
  recentTransactions: LatestTransaction[];
  monthlyTrend: MonthlyTrend[];
}

export interface CategorySpending {
  category: string;
  amount: number;
  percentage: number;
  color: string;
}

export interface Analytics {
  totalIncome: number;
  totalExpenses: number;
  savings: number;
  savingsRate: number;
  averageMonthlySpending: number;
  monthCount: number;
  bestMonth: MonthlyTrend | null;
  monthly: MonthlyTrend[];
  incomeBreakdown: CategorySpending[];
  expenseBreakdown: CategorySpending[];
}

export interface CreateTransactionInput {
  date: string;
  amount: number;
  description: string;
  accountId: string;
  categoryId: string;
}

export interface CreateCategoryInput {
  name: string;
  type: CategoryType;
  icon: string;
  color: string;
}

export interface CreateAccountInput {
  name: string;
  type: AccountType;
  currency: string;
  initialBalance: number;
}

export interface CurrencyRates {
  base: string;
  rates: Record<string, number>;
  updatedAt: string;
  source: "live" | "fallback";
}

export const AssetType = { Stock: 0, ETF: 1, Fund: 2, Bond: 3, Crypto: 4, Cash: 5, Other: 6 } as const;
export type AssetType = (typeof AssetType)[keyof typeof AssetType];

export const InvestmentTransactionType = {
  Buy: 0,
  Sell: 1,
  Dividend: 2,
  Interest: 3,
  Fee: 4,
  TransferIn: 5,
  TransferOut: 6,
} as const;
export type InvestmentTransactionType =
  (typeof InvestmentTransactionType)[keyof typeof InvestmentTransactionType];

export interface InvestmentAsset {
  id: string;
  ticker: string;
  name: string;
  type: AssetType;
  currency: string;
  manualPrice: number | null;
  stooqSymbol: string | null;
}

export interface InvestmentAccount {
  id: string;
  name: string;
  institution: string;
  currency: string;
  openingBalance: number;
  cashBalance: number;
}

export interface InvestmentTransaction {
  id: string;
  investmentAccountId: string;
  accountName: string;
  accountCurrency: string;
  assetId: string | null;
  ticker: string;
  assetName: string;
  assetCurrency: string;
  type: InvestmentTransactionType;
  date: string;
  quantity: number;
  price: number;
  amount: number;
  fee: number;
  note: string;
}

export interface InvestmentOverview {
  totalValue: number;
  totalInvested: number;
  profitLoss: number;
  returnPct: number;
  realizedGain: number;
  unrealizedGain: number;
  cashBalance: number;
  holdingsCount: number;
  accountCount: number;
}

export interface InvestmentHolding {
  assetId: string;
  ticker: string;
  name: string;
  assetType: string;
  currency: string;
  accountId: string;
  accountName: string;
  quantity: number;
  avgCost: number;
  cost: number;
  currentPrice: number;
  priceSource: string;
  currentValueInCurrency: number;
  currentValue: number;
  gain: number;
  gainPct: number;
}

export interface PerformanceResponse {
  range: string;
  dates: string[];
  values: number[];
}

export interface AllocationEntry {
  label: string;
  value: number;
  color: string;
}

export interface ContributionEntry {
  year: number;
  month: number;
  contributed: number;
  cumulative: number;
}

export interface DividendRow {
  id: string;
  date: string;
  ticker: string;
  assetName: string;
  accountName: string;
  amount: number;
  currency: string;
}

export interface DividendMonthSummary {
  month: number;
  total: number;
}

export interface DividendResponse {
  year: number;
  yearlyTotal: number;
  payments: DividendRow[];
  monthly: DividendMonthSummary[];
  upcoming: DividendRow[];
}

export interface BenchmarkResponse {
  symbol: string;
  dates: string[];
  portfolio: number[];
  benchmark: number[];
}

export interface PriceRefreshResponse {
  updated: number;
  failed: number;
  errors: string[];
}

export interface PriceHistoryRow {
  id: string;
  date: string;
  price: number;
  isManual: boolean;
}

export interface CreateInvestmentTransactionInput {
  investmentAccountId: string;
  assetId: string | null;
  type: InvestmentTransactionType;
  date: string;
  quantity?: number;
  price?: number;
  amount?: number;
  fee: number;
  note: string;
}

export interface CreateInvestmentAccountInput {
  name: string;
  institution: string;
  currency: string;
  openingBalance: number;
}

export interface CreateInvestmentAssetInput {
  ticker: string;
  name: string;
  type: AssetType;
  currency: string;
  manualPrice?: number | null;
  stooqSymbol?: string | null;
}

export interface AddPriceInput {
  date: string;
  price: number;
}

export interface Period {
  month: number | null;
  year: number | null;
}