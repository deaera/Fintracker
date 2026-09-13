using FinTrack.Api.Data;
using FinTrack.Api.Entities;
using FinTrack.Api.Utils.Enums;

namespace FinTrack.Api.Services;

public class DatabaseSeeder
{
    private readonly FinanceDbContext _context;

    public DatabaseSeeder(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task SeedAsync()
    {
        await SeedInvestmentsAsync();

        if (!_context.Categories.Any())
        {
            _context.Categories.AddRange(SeedCategories());
            await _context.SaveChangesAsync();
        }

        if (_context.Accounts.Any())
            return;

        var checking = new Account
        {
            Name = "Checking",
            Type = AccountType.Checking,
            Currency = "EUR",
            InitialBalance = 4500
        };

        var savings = new Account
        {
            Name = "Savings",
            Type = AccountType.Savings,
            Currency = "EUR",
            InitialBalance = 12000
        };

        var creditCard = new Account
        {
            Name = "Credit Card",
            Type = AccountType.CreditCard,
            Currency = "EUR",
            InitialBalance = 0
        };

        var cash = new Account
        {
            Name = "Cash",
            Type = AccountType.Cash,
            Currency = "EUR",
            InitialBalance = 300
        };

        _context.Accounts.AddRange(checking, savings, creditCard, cash);
        await _context.SaveChangesAsync();

        if (_context.CashTransactions.Any())
            return;

        var categories = _context.Categories.ToDictionary(c => c.Name);

        var transactions = BuildDemoTransactions(
            categories,
            checking.Id,
            savings.Id,
            creditCard.Id,
            cash.Id);

        _context.CashTransactions.AddRange(transactions);
        await _context.SaveChangesAsync();
    }

    private async Task SeedInvestmentsAsync()
    {
        if (_context.InvestmentAccounts.Any())
            return;

        var account = new InvestmentAccount
        {
            Name = "Interactive Brokers",
            Institution = "Interactive Brokers",
            Currency = "EUR",
            OpeningBalance = 5000
        };

        var vwce = new Asset
        {
            Ticker = "VWCE",
            Name = "Vanguard FTSE All-World ETF",
            Type = AssetType.ETF,
            Currency = "EUR",
            StooqSymbol = "VWCE.DE"
        };

        var vusa = new Asset
        {
            Ticker = "VUSA",
            Name = "Vanguard S&P 500 UCITS ETF",
            Type = AssetType.ETF,
            Currency = "USD",
            StooqSymbol = "VOO"
        };

        var msft = new Asset
        {
            Ticker = "MSFT",
            Name = "Microsoft Corp.",
            Type = AssetType.Stock,
            Currency = "USD",
            StooqSymbol = "msft.us"
        };

        _context.InvestmentAccounts.Add(account);
        _context.Assets.AddRange(vwce, vusa, msft);
        await _context.SaveChangesAsync();

        var today = DateTime.Today;
        var random = new Random(7);

        var transactions = new List<InvestmentTransaction>();
        var prices = new List<PriceHistory>();
        var vwcePrice = 118m;
        decimal vusaPrice = 470m;
        decimal msftPrice = 410m;

        for (var offset = 5; offset >= 0; offset--)
        {
            var monthStart = today.AddMonths(-offset);
            var daysInMonth = DateTime.DaysInMonth(monthStart.Year, monthStart.Month);
            var lastDay = offset == 0 ? Math.Min(today.Day, daysInMonth) : daysInMonth;

            if (offset == 0 && today.Day < 10)
                continue;

            DateOnly Day(int d) => new(monthStart.Year, monthStart.Month, Math.Min(Math.Max(1, d), lastDay));
            var month = Day(offset == 0 ? 1 : 1);

            transactions.Add(new InvestmentTransaction
            {
                InvestmentAccountId = account.Id,
                Type = InvestmentTransactionType.TransferIn,
                Date = month,
                Amount = 500,
                Note = "Monthly contribution"
            });

            var vwceQty = 2;
            transactions.Add(new InvestmentTransaction
            {
                InvestmentAccountId = account.Id,
                AssetId = vwce.Id,
                Type = InvestmentTransactionType.Buy,
                Date = Day(3),
                Quantity = vwceQty,
                Price = vwcePrice,
                Amount = decimal.Round(vwceQty * vwcePrice, 2),
                Fee = 1.50m,
                Note = "Monthly buy"
            });

            if (offset % 2 == 1)
            {
                transactions.Add(new InvestmentTransaction
                {
                    InvestmentAccountId = account.Id,
                    AssetId = vusa.Id,
                    Type = InvestmentTransactionType.Buy,
                    Date = Day(8),
                    Quantity = 1,
                    Price = vusaPrice,
                    Amount = vusaPrice,
                    Fee = 1.50m,
                    Note = "Accumulate"
                });

                transactions.Add(new InvestmentTransaction
                {
                    InvestmentAccountId = account.Id,
                    AssetId = msft.Id,
                    Type = InvestmentTransactionType.Buy,
                    Date = Day(10),
                    Quantity = 1,
                    Price = msftPrice,
                    Amount = msftPrice,
                    Fee = 1.00m,
                    Note = "Stock pick"
                });
            }

            if (offset > 0 && offset % 3 == 0)
            {
                transactions.Add(new InvestmentTransaction
                {
                    InvestmentAccountId = account.Id,
                    AssetId = vwce.Id,
                    Type = InvestmentTransactionType.Dividend,
                    Date = Day(20),
                    Amount = 1.40m,
                    Note = "Quarterly dividend VWCE"
                });

                transactions.Add(new InvestmentTransaction
                {
                    InvestmentAccountId = account.Id,
                    AssetId = msft.Id,
                    Type = InvestmentTransactionType.Dividend,
                    Date = Day(22),
                    Amount = 7.50m,
                    Note = "Quarterly dividend MSFT"
                });
            }

            if (offset == 2)
            {
                transactions.Add(new InvestmentTransaction
                {
                    InvestmentAccountId = account.Id,
                    AssetId = vwce.Id,
                    Type = InvestmentTransactionType.Sell,
                    Date = Day(12),
                    Quantity = 1,
                    Price = 128m,
                    Amount = 128m,
                    Fee = 1.50m,
                    Note = "Reallocated some VWCE"
                });
            }

            if (offset > 0)
            {
                var priceDay = Day(15);

                prices.Add(new PriceHistory { AssetId = vwce.Id, Date = priceDay, Price = vwcePrice });
                prices.Add(new PriceHistory { AssetId = vusa.Id, Date = priceDay, Price = vusaPrice });
                prices.Add(new PriceHistory { AssetId = msft.Id, Date = priceDay, Price = msftPrice });
            }

            vwcePrice += random.Next(-3, 6);
            vusaPrice += random.Next(-12, 18);
            msftPrice += random.Next(-8, 14);
        }

        _context.InvestmentTransactions.AddRange(transactions);
        _context.PriceHistory.AddRange(prices);
        await _context.SaveChangesAsync();
    }

    private static List<Category> SeedCategories() =>
    [
        // Income
        new Category { Name = "Salary", Type = CategoryType.Income, Icon = "💼", Color = "#4CAF50" },
        new Category { Name = "Freelance", Type = CategoryType.Income, Icon = "🧑‍💻", Color = "#66BB6A" },
        new Category { Name = "Interest", Type = CategoryType.Income, Icon = "🏦", Color = "#43A047" },
        new Category { Name = "Bonus", Type = CategoryType.Income, Icon = "🎁", Color = "#2E7D32" },

        // Expenses
        new Category { Name = "Food", Type = CategoryType.Expense, Icon = "🍔", Color = "#EF5350" },
        new Category { Name = "Groceries", Type = CategoryType.Expense, Icon = "🛒", Color = "#E57373" },
        new Category { Name = "Housing", Type = CategoryType.Expense, Icon = "🏠", Color = "#8E24AA" },
        new Category { Name = "Utilities", Type = CategoryType.Expense, Icon = "💡", Color = "#5C6BC0" },
        new Category { Name = "Transport", Type = CategoryType.Expense, Icon = "🚗", Color = "#1E88E5" },
        new Category { Name = "Shopping", Type = CategoryType.Expense, Icon = "🛍️", Color = "#EC407A" },
        new Category { Name = "Entertainment", Type = CategoryType.Expense, Icon = "🎮", Color = "#FF7043" },
        new Category { Name = "Healthcare", Type = CategoryType.Expense, Icon = "🏥", Color = "#26A69A" },
        new Category { Name = "Travel", Type = CategoryType.Expense, Icon = "✈️", Color = "#29B6F6" },
        new Category { Name = "Subscriptions", Type = CategoryType.Expense, Icon = "📺", Color = "#AB47BC" },
        new Category { Name = "Other", Type = CategoryType.Expense, Icon = "📦", Color = "#78909C" }
    ];

    private static List<CashTransaction> BuildDemoTransactions(
        Dictionary<string, Category> categories,
        Guid checkingId,
        Guid savingsId,
        Guid creditCardId,
        Guid cashId)
    {
        var today = DateTime.Today;
        var transactions = new List<CashTransaction>();
        var random = new Random(2026);

        for (var offset = 5; offset >= 0; offset--)
        {
            var monthStart = today.AddMonths(-offset);
            var daysInMonth = DateTime.DaysInMonth(monthStart.Year, monthStart.Month);
            var lastDay = offset == 0 ? Math.Min(today.Day, daysInMonth) : daysInMonth;

            if (offset == 0 && today.Day < 3)
                continue;

            DateOnly Day(int day) => new(monthStart.Year, monthStart.Month, Math.Min(Math.Max(1, day), lastDay));

            transactions.Add(new CashTransaction
            {
                AccountId = checkingId,
                CategoryId = categories["Salary"].Id,
                Amount = 3200,
                Date = Day(1),
                Description = "Monthly salary"
            });

            if (offset % 3 == 0)
            {
                transactions.Add(new CashTransaction
                {
                    AccountId = checkingId,
                    CategoryId = categories["Bonus"].Id,
                    Amount = 400,
                    Date = Day(2),
                    Description = "Performance bonus"
                });
            }

            transactions.Add(new CashTransaction
            {
                AccountId = checkingId,
                CategoryId = categories["Housing"].Id,
                Amount = 850,
                Date = Day(3),
                Description = "Apartment rent"
            });

            transactions.Add(new CashTransaction
            {
                AccountId = checkingId,
                CategoryId = categories["Utilities"].Id,
                Amount = random.Next(90, 145),
                Date = Day(5),
                Description = "Electricity + internet"
            });

            for (var week = 0; week < 4; week++)
            {
                var day = 2 + week * 7;
                if (day > lastDay)
                    break;

                transactions.Add(new CashTransaction
                {
                    AccountId = week == 3 ? checkingId : creditCardId,
                    CategoryId = categories["Groceries"].Id,
                    Amount = random.Next(55, 95),
                    Date = Day(day),
                    Description = "Groceries"
                });

                if (day + 2 <= lastDay)
                {
                    transactions.Add(new CashTransaction
                    {
                        AccountId = creditCardId,
                        CategoryId = categories["Food"].Id,
                        Amount = random.Next(18, 46),
                        Date = Day(day + 2),
                        Description = random.Next(0, 2) == 0 ? "Coffee & snacks" : "Dinner out"
                    });
                }

                if (day + 1 <= lastDay)
                {
                    transactions.Add(new CashTransaction
                    {
                        AccountId = week == 2 ? cashId : checkingId,
                        CategoryId = categories["Transport"].Id,
                        Amount = random.Next(12, 48),
                        Date = Day(day + 1),
                        Description = "Public transport / fuel"
                    });
                }
            }

            transactions.Add(new CashTransaction
            {
                AccountId = creditCardId,
                CategoryId = categories["Subscriptions"].Id,
                Amount = 12.99m,
                Date = Day(8),
                Description = "Streaming"
            });

            transactions.Add(new CashTransaction
            {
                AccountId = creditCardId,
                CategoryId = categories["Subscriptions"].Id,
                Amount = 9.99m,
                Date = Day(20),
                Description = "Music app"
            });

            if (WithinMonth(15, lastDay))
            {
                transactions.Add(new CashTransaction
                {
                    AccountId = creditCardId,
                    CategoryId = categories["Entertainment"].Id,
                    Amount = random.Next(20, 45),
                    Date = Day(15),
                    Description = "Movie night"
                });
            }

            if (offset % 2 == 1)
            {
                transactions.Add(new CashTransaction
                {
                    AccountId = checkingId,
                    CategoryId = categories["Healthcare"].Id,
                    Amount = random.Next(60, 130),
                    Date = Day(12),
                    Description = "Pharmacy / check-up"
                });
            }

            if (offset % 3 == 2)
            {
                transactions.Add(new CashTransaction
                {
                    AccountId = creditCardId,
                    CategoryId = categories["Travel"].Id,
                    Amount = random.Next(80, 220),
                    Date = Day(21),
                    Description = "Weekend trip"
                });
            }

            transactions.Add(new CashTransaction
            {
                AccountId = creditCardId,
                CategoryId = categories["Shopping"].Id,
                Amount = random.Next(30, 130),
                Date = Day(14),
                Description = "Clothes / gadgets"
            });
        }

        return transactions;

        static bool WithinMonth(int d, int lastDay) => d <= lastDay;
    }
}