package com.example.mapper;

import com.example.demo.dto.ClothesDetailDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;

public class ClothesDetailMapper {
    public static ClothesDetailDto mapToClothesDetailDto(ClothesDetail clothesDetail) {
        return new ClothesDetailDto(
            clothesDetail.getDetailId(),
            clothesDetail.getColor(),
            clothesDetail.getSize(),
            clothesDetail.getRemaining(),
            clothesDetail.getValue(),
            clothesDetail.getClothes().getClothesId()
        );
    }

    public static ClothesDetail mapToClothesDetail(ClothesDetailDto clothesDetailDto, Clothes clothesInfo) {
        return new ClothesDetail(
            clothesDetailDto.getDetailId(),
            clothesDetailDto.getColor(),
            clothesDetailDto.getSize(),
            clothesDetailDto.getRemaining(),
            clothesDetailDto.getValue(),
            clothesInfo
        );
    }
}
