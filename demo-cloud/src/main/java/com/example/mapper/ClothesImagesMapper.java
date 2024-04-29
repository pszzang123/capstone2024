package com.example.mapper;

import com.example.demo.dto.ClothesImagesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesImages;

public class ClothesImagesMapper {
    public static ClothesImagesDto mapToClothesImagesDto(ClothesImages clothesImages) {
        return new ClothesImagesDto(
            clothesImages.getClothes().getClothesId(),
            clothesImages.getImageUrl(),
            clothesImages.getOrder()
        );
    }

    public static ClothesImages mapToClothesImages(ClothesImagesDto clothesImagesDto, Clothes clothesInfo) {
        return new ClothesImages(
            clothesInfo,
            clothesImagesDto.getImageUrl(),
            clothesImagesDto.getOrder()
        );
    }
}
