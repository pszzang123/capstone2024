package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ClothesImagesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.ClothesImagesId;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesImagesRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.service.ClothesImagesService;
import com.example.mapper.ClothesImagesMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ClothesImagesServiceImpl implements ClothesImagesService {
    private ClothesImagesRepository clothesImagesRepository;
    private ClothesRepository clothesRepository;

    @Override
    public ClothesImagesDto createClothesImages(ClothesImagesDto clothesImagesDto) {
        ClothesImages clothesImages = ClothesImagesMapper.mapToClothesImages(clothesImagesDto);
        ClothesImages savedClothesImages = clothesImagesRepository.save(clothesImages);
        return ClothesImagesMapper.mapToClothesImagesDto(savedClothesImages);
    }

    @Override
    public List<String> getImageUrlsByClothesId(Long clothesId) {
        List<ClothesImages> clothesImages = null;
        try{
            Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
            );
            clothesImages = clothesImagesRepository.findAllByClothes(clothes);
        } catch (Exception e) {
            new ResourceNotFoundException("Clothes are not exists with given id : " + clothesId);
            return null;
        }

        List<String> imageUrls = clothesImages.stream().map((clothesImage) -> clothesImage.getImageUrl()).collect(Collectors.toList());
        
        return imageUrls;
    }

    @Override
    public List<ClothesImagesDto> getAllClothesImages() {
        List<ClothesImages> clothesImages = clothesImagesRepository.findAll();
        return clothesImages.stream().map((clothesImage) -> ClothesImagesMapper.mapToClothesImagesDto(clothesImage)).collect(Collectors.toList());
    }

    @Override
    public void deleteClothesImagesById(Long clothesId, String imageUrl) {
        ClothesImagesId deleteClothesImagesId = new ClothesImagesId(
            clothesRepository.findById(clothesId).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exists with given id : " + clothesId)
            ),
            imageUrl
        );
        clothesImagesRepository.findById(deleteClothesImagesId).orElseThrow(() -> 
            new ResourceNotFoundException("Image is not exists with given id : " + clothesId + ", " + imageUrl)
        );
        
        clothesImagesRepository.deleteById(deleteClothesImagesId);
    }
}
