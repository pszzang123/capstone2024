package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.Seller;
import com.example.demo.entity.SubCategory;
import com.example.demo.vo.ClothesVo;

public interface ClothesService {
    ClothesDto createClothes(ClothesDto clothesDto);

    ClothesDto getClothesById(Long clothesId);

    StatisticsDto getStatisticsById(Long clothesId);

    List<ClothesVo> getClothesBySeller(Seller seller);

    List<ClothesVo> getClothesByMajorCategory(MajorCategory majorCategory);

    List<ClothesVo> getClothesBySubCategory(SubCategory subCategory);

    List<ClothesVo> searchClothesByNameOrderByDailyView(String name);

    List<ClothesVo> getAllClothes();

    ClothesDto updateClothes(Long clothesId, ClothesDto updatedClothes);

    void deleteClothes(Long clothesId);
}
