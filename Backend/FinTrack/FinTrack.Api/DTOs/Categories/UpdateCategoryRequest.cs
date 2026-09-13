using System.ComponentModel.DataAnnotations;
using FinTrack.Api.Entities;

namespace FinTrack.Api.DTOs.Categories;

public class UpdateCategoryRequest
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    public CategoryType Type { get; set; }

    [MaxLength(50)]
    public string Icon { get; set; } = string.Empty;

    [MaxLength(20)]
    public string Color { get; set; } = "#000000";
}