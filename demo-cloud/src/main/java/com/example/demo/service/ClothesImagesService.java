package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesImagesDto;

public interface ClothesImagesService {
    ClothesImagesDto createClothesImages(ClothesImagesDto clothesImagesDto);

    List<ClothesImagesDto> getImageUrlsByClothesId(Long clothesId);

    List<ClothesImagesDto> getAllClothesImages();

    List<ClothesImagesDto> updateAllClothesImages(List<ClothesImagesDto> clothesImagesDtos);

    ClothesImagesDto changeClothesImagesOrder(Long clothesId, Long pos1, Long pos2);

    void deleteClothesImagesById(Long clothesId, String imageUrl);

    void deleteClothesImagesByPosition(Long clothesId, Long order);
}
