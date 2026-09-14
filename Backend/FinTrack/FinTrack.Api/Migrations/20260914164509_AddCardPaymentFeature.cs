using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FinTrack.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddCardPaymentFeature : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsCardPayment",
                table: "Categories",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<Guid>(
                name: "CardPaymentAccountId",
                table: "CashTransactions",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsInstallmentPayment",
                table: "CashTransactions",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "RemainingPayments",
                table: "Accounts",
                type: "integer",
                nullable: true);

            // Seed the special "Credit card payment" expense category.
            migrationBuilder.InsertData(
                table: "Categories",
                columns: ["Id", "Name", "Type", "Icon", "Color", "IsCardPayment"],
                values: new object[]
                {
                    Guid.Parse("11111111-1111-1111-1111-111111111111"),
                    "Credit card payment",
                    1,
                    "💳",
                    "#0284C7",
                    true
                });

            // Existing credit card plans: remaining installments start equal to the plan length.
            migrationBuilder.Sql(
                "UPDATE \"Accounts\" SET \"RemainingPayments\" = \"InstallmentMonths\" WHERE \"Type\" = 2 AND \"InstallmentMonths\" IS NOT NULL;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsCardPayment",
                table: "Categories");

            migrationBuilder.DropColumn(
                name: "CardPaymentAccountId",
                table: "CashTransactions");

            migrationBuilder.DropColumn(
                name: "IsInstallmentPayment",
                table: "CashTransactions");

            migrationBuilder.Sql(
                "DELETE FROM \"Categories\" WHERE \"Id\" = '11111111-1111-1111-1111-111111111111';");

            migrationBuilder.DropColumn(
                name: "RemainingPayments",
                table: "Accounts");
        }
    }
}
