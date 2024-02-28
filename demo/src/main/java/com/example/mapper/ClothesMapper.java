package com.example.mapper;

import com.example.demo.dto.ClothesDto;
import com.example.demo.entity.Clothes;

public class ClothesMapper {
    public static ClothesDto mapToClothesDto(Clothes clothes) {
        return new ClothesDto(
            clothes.getClothes_id(),
            clothes.getName(),
            clothes.getValue(),
            clothes.getSize(),
            clothes.getColor(),
            clothes.getSeller()
        );
    }

    public static Clothes mapToClothes(ClothesDto clothesDto) {
        return new Clothes(
            clothesDto.getClothes_id(),
            clothesDto.getName(),
            clothesDto.getValue(),
            clothesDto.getSize(),
            clothesDto.getColor(),
            clothesDto.getSeller()
        );
    }
}
