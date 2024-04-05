package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.Seller;

public interface ClothesService {
    ClothesDto createClothes(ClothesDto clothesDto);

    ClothesDto getClothesById(Long clothesId);

    StatisticsDto getStatisticsById(Long clothesId);

    List<ClothesDto> getClothesBySeller(Seller seller);

    List<ClothesDto> searchClothesByNameOrderByDailyView(String name);

    List<ClothesDto> getAllClothes();

    ClothesDto updateClothes(Long clothesId, ClothesDto updatedClothes);

    void deleteClothes(Long clothesId);
}
