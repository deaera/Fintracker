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