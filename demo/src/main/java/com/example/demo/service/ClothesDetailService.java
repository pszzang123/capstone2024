package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesDetailDto;
import com.example.demo.entity.Clothes;

public interface ClothesDetailService {
    ClothesDetailDto createClothesDetail(ClothesDetailDto clothesDetailDto);

    ClothesDetailDto getClothesDetailById(Long detailId);

    List<ClothesDetailDto> getClothesDetailByClothes(Clothes clothes);

    List<ClothesDetailDto> getAllClothesDetails();

    ClothesDetailDto updateClothesDetail(Long detailId, ClothesDetailDto updatedClothesDetail);

    void deleteClothesDetail(Long detailId);
}
