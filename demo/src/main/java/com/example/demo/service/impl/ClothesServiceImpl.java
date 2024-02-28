package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ClothesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesCategories;
import com.example.demo.entity.ClothesCategoriesId;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.ClothesImagesId;
import com.example.demo.entity.Customer;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesCategoriesRepository;
import com.example.demo.repository.ClothesImagesRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.service.ClothesService;
import com.example.mapper.ClothesMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ClothesServiceImpl implements ClothesService {
    private ClothesRepository clothesRepository;
    private ClothesCategoriesRepository clothesCategoriesRepository;
    private ClothesImagesRepository clothesImagesRepository;

    @Override
    public ClothesDto createClothes(ClothesDto clothesDto) {
        Clothes clothes = ClothesMapper.mapToClothes(clothesDto);
        Clothes savedClothes = clothesRepository.save(clothes);
        return ClothesMapper.mapToClothesDto(savedClothes);
    }

    @Override
    public ClothesDto getClothesById(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );
        
        return ClothesMapper.mapToClothesDto(clothes);
    }

    @Override
    public List<ClothesDto> getClothesBySeller(Customer seller) {
        List<Clothes> clothes = clothesRepository.findAllBySeller(seller);
        return clothes.stream().map((clothe) -> ClothesMapper.mapToClothesDto(clothe)).collect(Collectors.toList());
    }

    @Override
    public List<ClothesDto> getAllClothes() {
        List<Clothes> clothes = clothesRepository.findAll();
        return clothes.stream().map((clothe) -> ClothesMapper.mapToClothesDto(clothe)).collect(Collectors.toList());
    }

    @Override
    public ClothesDto updateClothes(Long clothesId, ClothesDto updatedClothes) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        clothes.setColor(updatedClothes.getColor());
        clothes.setName(updatedClothes.getName());
        clothes.setSize(updatedClothes.getSize());
        clothes.setValue(updatedClothes.getValue());

        Clothes updatedClothesObj = clothesRepository.save(clothes);

        return ClothesMapper.mapToClothesDto(updatedClothesObj);
    }

    @Override
    public void deleteClothes(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exists with given id : " + clothesId)
        );

        List<ClothesCategories> clothesCategories = clothesCategoriesRepository.findAllByClothes(clothes);
        clothesCategories.forEach(clothesCategory -> {
            ClothesCategoriesId clothesCategoriesId = new ClothesCategoriesId(clothesCategory.getClothes(), clothesCategory.getCategory());
            clothesCategoriesRepository.deleteById(clothesCategoriesId);
        });

        List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothes);
        clothesImages.forEach(clothesImage -> {
            ClothesImagesId clothesImagesId = new ClothesImagesId(clothesImage.getClothes(), clothesImage.getImageUrl());
            clothesImagesRepository.deleteById(clothesImagesId);
        });
        
        clothesRepository.deleteById(clothesId);
    }
}
