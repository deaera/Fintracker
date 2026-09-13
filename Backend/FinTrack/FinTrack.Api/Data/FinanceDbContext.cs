using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Data;

public class FinanceDbContext : DbContext
{
    public FinanceDbContext(DbContextOptions<FinanceDbContext> options)
        : base(options)
    {
    }

    public DbSet<Account> Accounts => Set<Account>();

    public DbSet<Category> Categories => Set<Category>();

    public DbSet<CashTransaction> CashTransactions => Set<CashTransaction>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Account>()
            .HasMany(a => a.CashTransactions)
            .WithOne(t => t.Account)
            .HasForeignKey(t => t.AccountId);

        modelBuilder.Entity<Category>()
            .HasMany(c => c.CashTransactions)
            .WithOne(t => t.Category)
            .HasForeignKey(t => t.CategoryId);
    }
}