package com.example.mapper;

import com.example.demo.dto.ClothesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Seller;

public class ClothesMapper {
    public static ClothesDto mapToClothesDto(Clothes clothes) {
        return new ClothesDto(
            clothes.getClothesId(),
            clothes.getName(),
            clothes.getValue(),
            clothes.getSize(),
            clothes.getColor(),
            clothes.getDetail(),
            clothes.getRemaining(),
            clothes.getSeller().getEmail()
        );
    }

    public static Clothes mapToClothes(ClothesDto clothesDto, Seller seller_info) {
        return new Clothes(
            clothesDto.getClothesId(),
            clothesDto.getName(),
            clothesDto.getValue(),
            clothesDto.getSize(),
            clothesDto.getColor(),
            clothesDto.getDetail(),
            clothesDto.getRemaining(),
            seller_info
        );
    }
}
