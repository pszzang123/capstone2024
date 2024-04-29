package com.example.mapper;

import com.example.demo.dto.LookbookDetailDto;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Lookbook;
import com.example.demo.entity.LookbookDetail;

public class LookbookDetailMapper {
    public static LookbookDetailDto mapToLookbookDetailDto(LookbookDetail lookbookDetail) {
        return new LookbookDetailDto(
            lookbookDetail.getLookbookDetailId(),
            lookbookDetail.getLookbook().getLookbookId(),
            lookbookDetail.getClothesDetail().getDetailId()
        );
    }

    public static LookbookDetail mapToLookbookDetail(LookbookDetailDto lookbookDetailDto, Lookbook lookbook, ClothesDetail clothesDetail) {
        return new LookbookDetail(
            lookbookDetailDto.getLookbookDetailId(),
            lookbook,
            clothesDetail
        );
    }
}
