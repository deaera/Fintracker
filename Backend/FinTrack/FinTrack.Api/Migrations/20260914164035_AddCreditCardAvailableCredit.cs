using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FinTrack.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddCreditCardAvailableCredit : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "AvailableCredit",
                table: "Accounts",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            // Existing credit card rows: available = limit − outstanding so the new inputs stay consistent.
            migrationBuilder.Sql(
                "UPDATE \"Accounts\" SET \"AvailableCredit\" = \"CreditLimit\" - \"OutstandingBalance\" WHERE \"Type\" = 2;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AvailableCredit",
                table: "Accounts");
        }
    }
}
