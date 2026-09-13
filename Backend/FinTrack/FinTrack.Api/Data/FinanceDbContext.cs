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

    public DbSet<Asset> Assets => Set<Asset>();

    public DbSet<InvestmentAccount> InvestmentAccounts => Set<InvestmentAccount>();

    public DbSet<InvestmentTransaction> InvestmentTransactions => Set<InvestmentTransaction>();

    public DbSet<PriceHistory> PriceHistory => Set<PriceHistory>();

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

        modelBuilder.Entity<Asset>()
            .HasIndex(a => a.Ticker)
            .IsUnique();

        modelBuilder.Entity<PriceHistory>()
            .HasOne(p => p.Asset)
            .WithMany()
            .HasForeignKey(p => p.AssetId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<InvestmentAccount>()
            .HasMany<InvestmentTransaction>()
            .WithOne(t => t.InvestmentAccount)
            .HasForeignKey(t => t.InvestmentAccountId);

        modelBuilder.Entity<Asset>()
            .HasMany<InvestmentTransaction>()
            .WithOne(t => t.Asset)
            .HasForeignKey(t => t.AssetId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}