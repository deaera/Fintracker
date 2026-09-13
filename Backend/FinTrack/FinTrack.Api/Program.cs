using FinTrack.Api.Data;
using FinTrack.Api.Extensions;
using FinTrack.Api.Services;
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddDbContext<FinanceDbContext>(options =>
    options.UseNpgsql(
        builder.Configuration.GetConnectionString("FinanceDatabase")));
builder.Services.AddScoped<AccountService>();
builder.Services.AddScoped<CategoryService>();
builder.Services.AddScoped<DatabaseSeeder>();
builder.Services.AddScoped<CashTransactionService>();
builder.Services.AddScoped<DashboardService>();
builder.Services.AddScoped<AnalyticsService>();
builder.Services.AddScoped<BalanceService>();
builder.Services.AddSingleton<CurrencyService>();
builder.Services.AddSingleton<MarketDataService>();
builder.Services.AddScoped<AssetService>();
builder.Services.AddScoped<InvestmentAccountService>();
builder.Services.AddScoped<InvestmentTransactionService>();
builder.Services.AddScoped<InvestmentPortfolioService>();
builder.Services.AddScoped<XtbImportService>();

builder.Services.AddHttpLogging(options =>
{
    options.LoggingFields =
        Microsoft.AspNetCore.HttpLogging.HttpLoggingFields.All;
});
builder.Services.AddCors(options =>
{
    options.AddPolicy("Frontend", policy =>
    {
        policy
            .WithOrigins("http://localhost:5173")
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();
app.UseGlobalExceptionHandling();
app.UseHttpLogging();
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<FinanceDbContext>();
    await db.Database.MigrateAsync();

    var seeder = scope.ServiceProvider.GetRequiredService<DatabaseSeeder>();
    await seeder.SeedAsync();
}
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.UseHttpsRedirection();
app.UseCors("Frontend");
app.UseAuthorization();
app.MapControllers();

app.Run();