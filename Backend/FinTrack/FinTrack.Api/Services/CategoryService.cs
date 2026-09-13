using FinTrack.Api.Data;
using FinTrack.Api.DTOs.Categories;
using FinTrack.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace FinTrack.Api.Services;

public class CategoryService
{
    private readonly FinanceDbContext _context;

    public CategoryService(FinanceDbContext context)
    {
        _context = context;
    }

    public async Task<List<CategoryResponse>> GetAllAsync()
    {
        return await _context.Categories
            .OrderBy(c => c.Type)
            .ThenBy(c => c.Name)
            .Select(c => new CategoryResponse
            {
                Id = c.Id,
                Name = c.Name,
                Type = c.Type,
                Icon = c.Icon,
                Color = c.Color
            })
            .ToListAsync();
    }

    public async Task<CategoryResponse> CreateAsync(CreateCategoryRequest request)
    {
        var category = new Category
        {
            Name = request.Name,
            Type = request.Type,
            Icon = request.Icon,
            Color = request.Color
        };

        _context.Categories.Add(category);

        await _context.SaveChangesAsync();

        return new CategoryResponse
        {
            Id = category.Id,
            Name = category.Name,
            Type = category.Type,
            Icon = category.Icon,
            Color = category.Color
        };
    }

    public async Task<CategoryResponse?> UpdateAsync(Guid id, UpdateCategoryRequest request)
    {
        var category = await _context.Categories.FindAsync(id);

        if (category is null)
            return null;

        category.Name = request.Name;
        category.Type = request.Type;
        category.Icon = request.Icon;
        category.Color = request.Color;

        await _context.SaveChangesAsync();

        return new CategoryResponse
        {
            Id = category.Id,
            Name = category.Name,
            Type = category.Type,
            Icon = category.Icon,
            Color = category.Color
        };
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var category = await _context.Categories.FindAsync(id);

        if (category is null)
            return false;

        _context.Categories.Remove(category);

        await _context.SaveChangesAsync();

        return true;
    }
}