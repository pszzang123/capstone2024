package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.CategoryDto;
import com.example.demo.dto.ClothesCategoriesDto;
import com.example.demo.dto.ClothesDto;

public interface ClothesCategoriesService {
    ClothesCategoriesDto createClothesCategories(ClothesCategoriesDto clothesCategoriesDto);

    List<CategoryDto> getCategoriesByClothesId(Long clothesId);

    List<ClothesDto> getClothesByCategoryId(Long categoryId);

    List<ClothesCategoriesDto> getAllClothesCategories();

    void deleteClothesCategoriesById(Long clothesId, Long categoryId);
}
