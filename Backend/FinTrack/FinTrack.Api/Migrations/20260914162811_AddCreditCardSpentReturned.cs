using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FinTrack.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddCreditCardSpentReturned : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "TotalReturned",
                table: "Accounts",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "TotalSpent",
                table: "Accounts",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            // Existing credit card rows: assume nothing has been paid back yet.
            migrationBuilder.Sql(
                "UPDATE \"Accounts\" SET \"TotalSpent\" = \"OutstandingBalance\", \"TotalReturned\" = 0 WHERE \"Type\" = 2;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "TotalReturned",
                table: "Accounts");

            migrationBuilder.DropColumn(
                name: "TotalSpent",
                table: "Accounts");
        }
    }
}
