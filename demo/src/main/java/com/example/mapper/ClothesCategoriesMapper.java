package com.example.mapper;

import com.example.demo.dto.ClothesCategoriesDto;
import com.example.demo.entity.Category;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesCategories;

public class ClothesCategoriesMapper {
    public static ClothesCategoriesDto mapToClothesCategoriesDto(ClothesCategories clothesCategories) {
        return new ClothesCategoriesDto(
            clothesCategories.getClothes().getClothesId(),
            clothesCategories.getCategory().getCategoryId()
        );
    }

    public static ClothesCategories mapToClothesCategories(Clothes clothes, Category category) {
        return new ClothesCategories(
            clothes,
            category
        );
    }
}
