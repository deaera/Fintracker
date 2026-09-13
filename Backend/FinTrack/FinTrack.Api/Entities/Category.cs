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

    public ICollection<CashTransaction> CashTransactions { get; set; } = [];
}