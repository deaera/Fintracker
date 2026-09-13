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

        if (!_context.Categories.Any(c => c.Name == "Transfer" && c.Type == CategoryType.Transfer))
        {
            _context.Categories.Add(new Category
            {
                Name = "Transfer",
                Type = CategoryType.Transfer,
                Icon = "↔️",
                Color = "#64748B"
            });
            await _context.SaveChangesAsync();
        }
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
}