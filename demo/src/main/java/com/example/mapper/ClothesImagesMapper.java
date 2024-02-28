package com.example.mapper;

import com.example.demo.dto.ClothesImagesDto;
import com.example.demo.entity.ClothesImages;

public class ClothesImagesMapper {
    public static ClothesImagesDto mapToClothesImagesDto(ClothesImages clothesImages) {
        return new ClothesImagesDto(
            clothesImages.getClothes(),
            clothesImages.getImageUrl()
        );
    }

    public static ClothesImages mapToClothesImages(ClothesImagesDto clothesImagesDto) {
        return new ClothesImages(
            clothesImagesDto.getClothes(),
            clothesImagesDto.getImageUrl()
        );
    }
}
