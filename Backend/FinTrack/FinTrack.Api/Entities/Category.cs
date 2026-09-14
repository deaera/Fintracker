using System.ComponentModel.DataAnnotations;
using FinTrack.Api.Entities;

public class Category : BaseEntity
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    public CategoryType Type { get; set; }

    public string Icon { get; set; } = string.Empty;

    public string Color { get; set; } = "#000000";

    /// <summary>
    /// When true, transactions with this category are credit card payments: they count
    /// as an expense (money leaves the cash account) and also pay down the selected credit card.
    /// </summary>
    public bool IsCardPayment { get; set; }

    public ICollection<CashTransaction> CashTransactions { get; set; } = [];
}