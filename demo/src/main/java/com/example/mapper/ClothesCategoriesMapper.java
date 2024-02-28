package com.example.mapper;

import com.example.demo.dto.ClothesCategoriesDto;
import com.example.demo.entity.ClothesCategories;

public class ClothesCategoriesMapper {
    public static ClothesCategoriesDto mapToClothesCategoriesDto(ClothesCategories clothesCategories) {
        return new ClothesCategoriesDto(
            clothesCategories.getClothes(),
            clothesCategories.getCategory()
        );
    }

    public static ClothesCategories mapToClothesCategories(ClothesCategoriesDto clothesCategoriesDto) {
        return new ClothesCategories(
            clothesCategoriesDto.getClothes(),
            clothesCategoriesDto.getCategory()
        );
    }
}
