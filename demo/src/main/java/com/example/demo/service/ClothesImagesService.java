package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ClothesImagesDto;

public interface ClothesImagesService {
    ClothesImagesDto createClothesImages(ClothesImagesDto clothesImagesDto);

    List<ClothesImagesDto> getImageUrlsByClothesId(Long clothesId);

    List<ClothesImagesDto> getAllClothesImages();

    List<ClothesImagesDto> changeClothesImagesOrder(Long clothesId, String imageUrl1, String imageUrl2);

    void deleteClothesImagesById(Long clothesId, String imageUrl);

    void deleteClothesImagesByPosition(Long clothesId, Long order);
}
