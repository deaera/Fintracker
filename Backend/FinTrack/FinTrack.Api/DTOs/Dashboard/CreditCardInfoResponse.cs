namespace FinTrack.Api.DTOs.Dashboard;

public class CreditCardInfoResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Currency { get; set; } = "EUR";

    /// <summary>Maximum amount that can be borrowed, in the card's currency.</summary>
    public decimal CreditLimit { get; set; }

    /// <summary>Current outstanding debt, in the card's currency.</summary>
    public decimal OutstandingBalance { get; set; }

    /// <summary>Credit still available to use, in the card's currency.</summary>
    public decimal AvailableCredit { get; set; }

    /// <summary>Fixed amount paid each month for the installment plan.</summary>
    public decimal? MonthlyPayment { get; set; }

    /// <summary>Total number of installments in the plan.</summary>
    public int? InstallmentMonths { get; set; }

    /// <summary>Installments still left to pay (derived from the start date).</summary>
    public int? RemainingPayments { get; set; }

    /// <summary>Monthly interest rate in percent (0 for 0% financing).</summary>
    public decimal? MonthlyInterestRate { get; set; }

    /// <summary>Recurring card fees, e.g. annual fee, in the card's currency.</summary>
    public decimal? AnnualFee { get; set; }

    /// <summary>Outstanding debt converted to EUR (negative contribution to net worth).</summary>
    public decimal DebtInEur { get; set; }
}