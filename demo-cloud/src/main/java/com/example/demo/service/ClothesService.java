package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.Seller;
import com.example.demo.vo.ClothesVo;

public interface ClothesService {
    ClothesDto createClothes(ClothesDto clothesDto);

    ClothesDto getClothesById(Long clothesId);

    StatisticsDto getStatisticsById(Long clothesId);

    List<ClothesDto> getClothesBySeller(Seller seller);

    List<ClothesVo> getClothesByGenderCategory(Integer genderCategory);

    List<ClothesVo> getClothesByMajorCategory(Long majorCategoryId);

    List<ClothesVo> getClothesBySubCategory(Long subCategoryId);

    List<ClothesVo> getClothesByGenderCategoryAndMajorCategory(Integer genderCategory, Long majorCategoryId);

    List<ClothesVo> getClothesByGenderCategoryAndSubCategory(Integer genderCategory, Long subCategoryId);

    List<ClothesVo> getClothesByMajorCategoryAndSubCategory(Long majorCategoryId, Long subCategoryId);

    List<ClothesVo> getClothesByGenderCategoryAndMajorCategoryAndSubCategory(Integer genderCategory, Long majorCategoryId, Long subCategoryId);

    List<ClothesVo> searchClothesByName(String name);

    List<ClothesVo> searchClothesByGenderCategoryAndName(Integer genderCategory, String name);

    List<ClothesVo> searchClothesBySubCategoryAndName(Long subCategoryId, String name);

    List<ClothesVo> searchClothesByMajorCategoryAndName(Long majorCategoryId, String name);

    List<ClothesVo> searchClothesByGenderCategoryAndSubCategoryAndName(Integer genderCategory, Long subCategoryId, String name);

    List<ClothesVo> searchClothesByGenderCategoryAndMajorCategoryAndName(Integer genderCategory, Long majorCategoryId, String name);

    List<ClothesVo> searchClothesByMajorCategoryAndSubCategoryAndName(Long majorCategoryId, Long subCategoryId, String name);

    List<ClothesVo> searchClothesByGenderCategoryAndMajorCategoryAndSubCategoryAndName(Integer genderCategory, Long majorCategoryId, Long subCategoryId, String name);

    List<ClothesVo> getAllClothes();

    List<ClothesVo> sortClothesVos(List<ClothesVo> clothes, Integer sortId);

    StatisticsDto viewClothes(Long clothesId);

    ClothesDto updateClothes(Long clothesId, ClothesDto updatedClothes);

    void deleteClothes(Long clothesId);
}
