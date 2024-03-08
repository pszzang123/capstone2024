package com.example.mapper;

import com.example.demo.dto.CategoryDto;
import com.example.demo.entity.Category;

public class CategoryMapper {
    public static CategoryDto mapToCategoryDto(Category category) {
        return new CategoryDto(
            category.getCategoryId(),
            category.getName()
        );
    }

    public static Category mapToCategory(CategoryDto categoryDto) {
        return new Category(
            categoryDto.getCategoryId(),
            categoryDto.getName()
        );
    }
}
