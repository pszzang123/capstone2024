package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.CategoryDto;
import com.example.demo.entity.Category;
import com.example.demo.entity.ClothesCategories;
import com.example.demo.entity.ClothesCategoriesId;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.repository.ClothesCategoriesRepository;
import com.example.demo.service.CategoryService;
import com.example.mapper.CategoryMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CategoryServiceImpl implements CategoryService {
    private CategoryRepository categoryRepository;
    private ClothesCategoriesRepository clothesCategoriesRepository;

    @Override
    public CategoryDto createCategory(CategoryDto categoryDto) {
        Category category = CategoryMapper.mapToCategory(categoryDto);
        Category savedCategory = categoryRepository.save(category);
        return CategoryMapper.mapToCategoryDto(savedCategory);
    }

    @Override
    public CategoryDto getCategoryById(Long categoryId) {
        Category category = categoryRepository.findById(categoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Category is not exists with given id : " + categoryId)
        );
        
        return CategoryMapper.mapToCategoryDto(category);
    }

    @Override
    public List<CategoryDto> getAllCategories() {
        List<Category> categories = categoryRepository.findAll();
        return categories.stream().map((category) -> CategoryMapper.mapToCategoryDto(category)).collect(Collectors.toList());
    }

    @Override
    public CategoryDto updateCategory(Long categoryId, CategoryDto updatedCategory) {
        Category category = categoryRepository.findById(categoryId).orElseThrow(
            () -> new ResourceNotFoundException("Category is not exists with given id : " + categoryId)
        );

        category.setName(updatedCategory.getName());

        Category updatedCategoryObj = categoryRepository.save(category);

        return CategoryMapper.mapToCategoryDto(updatedCategoryObj);
    }

    @Override
    public void deleteCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Category is not exists with given id : " + categoryId)
        );

        List<ClothesCategories> clothesCategories = clothesCategoriesRepository.findAllByCategory(category);
        clothesCategories.forEach(clothesCategory -> {
            ClothesCategoriesId clothesCategoriesId = new ClothesCategoriesId(clothesCategory.getClothes(), clothesCategory.getCategory());
            clothesCategoriesRepository.deleteById(clothesCategoriesId);
        });
        
        categoryRepository.deleteById(categoryId);
    }
}
