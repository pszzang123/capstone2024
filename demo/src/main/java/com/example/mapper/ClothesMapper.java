package com.example.mapper;

import com.example.demo.dto.ClothesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Seller;
import com.example.demo.vo.CartVo;

public class ClothesMapper {
    public static ClothesDto mapToClothesDto(Clothes clothes) {
        return new ClothesDto(
            clothes.getClothesId(),
            clothes.getName(),
            clothes.getDetail(),
            clothes.getGenderCategory(),
            clothes.getLargeCategory() * 100 + clothes.getSmallCategory(),
            clothes.getPrice(),
            clothes.getSeller().getEmail()
        );
    }

    public static Clothes mapToClothes(ClothesDto clothesDto, Seller sellerInfo) {
        return new Clothes(
            clothesDto.getClothesId(),
            clothesDto.getName(),
            clothesDto.getDetail(),
            clothesDto.getGenderCategory(),
            clothesDto.getCategoryNumber() / 100,
            clothesDto.getCategoryNumber(),
            clothesDto.getPrice(),
            sellerInfo
        );
    }
}
