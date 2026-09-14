using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Categories;

public class CategoryResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public CategoryType Type { get; set; }

    public string Icon { get; set; } = string.Empty;

    public string Color { get; set; } = string.Empty;

    public bool IsCardPayment { get; set; }
}