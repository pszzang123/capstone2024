package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.CategoryDto;

public interface CategoryService {
    CategoryDto createCategory(CategoryDto categoryDto);

    CategoryDto getCategoryById(Long categoryId);

    List<CategoryDto> getAllCategories();

    CategoryDto updateCategory(Long categoryId, CategoryDto updatedCategory);

    void deleteCategory(Long categoryId);
}
