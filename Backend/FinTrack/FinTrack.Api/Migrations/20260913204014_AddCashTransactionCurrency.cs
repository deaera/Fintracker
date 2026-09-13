using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FinTrack.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddCashTransactionCurrency : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Currency",
                table: "CashTransactions",
                type: "character varying(8)",
                maxLength: 8,
                nullable: false,
                defaultValue: "EUR");

            migrationBuilder.Sql(
                """
                UPDATE "CashTransactions" SET "Currency" = a."Currency"
                FROM "Accounts" AS a
                WHERE a."Id" = "CashTransactions"."AccountId";
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Currency",
                table: "CashTransactions");
        }
    }
}
