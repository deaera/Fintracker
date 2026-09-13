import api from "../api/api";
import type { Category, CreateCategoryInput } from "../types";

export async function getCategories(): Promise<Category[]> {
  const { data } = await api.get<Category[]>("/categories");
  return data;
}

export async function createCategory(input: CreateCategoryInput): Promise<Category> {
  const { data } = await api.post<Category>("/categories", input);
  return data;
}

export async function updateCategory(id: string, input: CreateCategoryInput): Promise<Category> {
  const { data } = await api.put<Category>(`/categories/${id}`, input);
  return data;
}

export async function deleteCategory(id: string): Promise<void> {
  await api.delete(`/categories/${id}`);
}