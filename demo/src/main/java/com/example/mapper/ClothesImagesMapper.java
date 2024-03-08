package com.example.mapper;

import com.example.demo.dto.ClothesImagesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesImages;

public class ClothesImagesMapper {
    public static ClothesImagesDto mapToClothesImagesDto(ClothesImages clothesImages) {
        return new ClothesImagesDto(
            clothesImages.getClothes().getClothesId(),
            clothesImages.getImageUrl()
        );
    }

    public static ClothesImages mapToClothesImages(ClothesImagesDto clothesImagesDto, Clothes clothes_info) {
        return new ClothesImages(
            clothes_info,
            clothesImagesDto.getImageUrl()
        );
    }
}
