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

export interface Period {
  month: number | null;
  year: number | null;
}