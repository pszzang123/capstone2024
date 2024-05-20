package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesDetailDto;

public interface ClothesDetailService {
    ClothesDetailDto createClothesDetail(ClothesDetailDto clothesDetailDto);

    ClothesDetailDto getClothesDetailById(Long detailId);

    List<ClothesDetailDto> getClothesDetailByClothes(Long clothesId);

    List<ClothesDetailDto> getAllClothesDetails();

    ClothesDetailDto updateClothesDetail(Long detailId, ClothesDetailDto updatedClothesDetail);

    void deleteClothesDetail(Long detailId);

    void deleteClothesDetailByClothesId(Long clothesId);
}
