package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesImagesDto;

public interface ClothesImagesService {
    ClothesImagesDto createClothesImages(ClothesImagesDto clothesImagesDto);

    List<String> getImageUrlsByClothesId(Long clothesId);

    List<ClothesImagesDto> getAllClothesImages();

    void deleteClothesImagesById(Long categoryId, String imageUrl);
}
