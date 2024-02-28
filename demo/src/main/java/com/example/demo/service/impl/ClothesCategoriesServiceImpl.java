package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.CategoryDto;
import com.example.demo.dto.ClothesCategoriesDto;
import com.example.demo.dto.ClothesDto;
import com.example.demo.entity.Category;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesCategories;
import com.example.demo.entity.ClothesCategoriesId;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.repository.ClothesCategoriesRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.service.ClothesCategoriesService;
import com.example.mapper.CategoryMapper;
import com.example.mapper.ClothesCategoriesMapper;
import com.example.mapper.ClothesMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ClothesCategoriesServiceImpl implements ClothesCategoriesService {
    private ClothesCategoriesRepository clothesCategoriesRepository;
    private ClothesRepository clothesRepository;
    private CategoryRepository categoryRepository;

    @Override
    public ClothesCategoriesDto createClothesCategories(ClothesCategoriesDto clothesCategoriesDto) {
        ClothesCategories clothesCategories = ClothesCategoriesMapper.mapToClothesCategories(clothesCategoriesDto);
        ClothesCategories savedClothesCategories = clothesCategoriesRepository.save(clothesCategories);
        return ClothesCategoriesMapper.mapToClothesCategoriesDto(savedClothesCategories);
    }

    @Override
    public List<CategoryDto> getCategoriesByClothesId(Long clothesId) {
        List<ClothesCategories> clothesCategories = null;
        try{
            Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
            );
            clothesCategories = clothesCategoriesRepository.findAllByClothes(clothes);
        } catch (Exception e) {
            new ResourceNotFoundException("Clothes are not exists with given id : " + clothesId);
            return null;
        }

        List<CategoryDto> categoryDtos = clothesCategories.stream().map((clothesCategory) -> CategoryMapper.mapToCategoryDto(clothesCategory.getCategory())).collect(Collectors.toList());
        
        return categoryDtos;
    }

    @Override
    public List<ClothesDto> getClothesByCategoryId(Long categoryId) {
        List<ClothesCategories> clothesCategories = null;
        try{
            Category category = categoryRepository.findById(categoryId).orElseThrow(() -> 
                new ResourceNotFoundException("Category is not exists with given id : " + categoryId)
            );
            clothesCategories = clothesCategoriesRepository.findAllByCategory(category);
        } catch (Exception e) {
            new ResourceNotFoundException("Category is not exists with given id : " + categoryId);
            return null;
        }

        List<ClothesDto> categoryDtos = clothesCategories.stream().map((clothesCategory) -> ClothesMapper.mapToClothesDto(clothesCategory.getClothes())).collect(Collectors.toList());
        
        return categoryDtos;
    }

    @Override
    public List<ClothesCategoriesDto> getAllClothesCategories() {
        List<ClothesCategories> clothesCategories = clothesCategoriesRepository.findAll();
        return clothesCategories.stream().map((clothesCategory) -> ClothesCategoriesMapper.mapToClothesCategoriesDto(clothesCategory)).collect(Collectors.toList());
    }

    @Override
    public void deleteClothesCategoriesById(Long clothesId, Long categoryId) {
        ClothesCategoriesId deleteClothesCategoriesId = new ClothesCategoriesId(
            clothesRepository.findById(clothesId).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exists with given id : " + clothesId)
            ),
            categoryRepository.findById(categoryId).orElseThrow(() -> 
                new ResourceNotFoundException("Category is not exists with given id : " + categoryId)
            )
        );
        clothesCategoriesRepository.findById(deleteClothesCategoriesId).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exists with given id : " + clothesId + ", " + categoryId)
        );
        
        clothesCategoriesRepository.deleteById(deleteClothesCategoriesId);
    }
}
