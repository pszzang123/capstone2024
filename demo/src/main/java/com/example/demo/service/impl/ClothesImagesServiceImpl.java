package com.example.demo.service.impl;

import java.util.ArrayList;
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
        Boolean addable = true;

        Clothes clothes_info = clothesRepository.findById(clothesImagesDto.getClothesId()).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesImagesDto.getClothesId())
        );
        List<ClothesImages> clothesImagesSet = clothesImagesRepository.findAllByClothes(clothes_info);
        for(ClothesImages clothesImages : clothesImagesSet) {
            addable = clothesImages.getOrder() != clothesImagesDto.getOrder();
            if (!addable) {
                break;
            } else {
                continue;
            }
        }
        ClothesImages clothesImages = ClothesImagesMapper.mapToClothesImages(clothesImagesDto, clothes_info);
        ClothesImages savedClothesImages = addable ? clothesImagesRepository.save(clothesImages) : null;
        return ClothesImagesMapper.mapToClothesImagesDto(savedClothesImages);
    }

    @Override
    public List<ClothesImagesDto> getImageUrlsByClothesId(Long clothesId) {
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

        List<ClothesImagesDto> clothesImagesDtos = clothesImages.stream().map((clothesImage) -> ClothesImagesMapper.mapToClothesImagesDto(clothesImage)).collect(Collectors.toList());
        
        return clothesImagesDtos;
    }

    @Override
    public List<ClothesImagesDto> getAllClothesImages() {
        List<ClothesImages> clothesImages = clothesImagesRepository.findAll();
        return clothesImages.stream().map((clothesImage) -> ClothesImagesMapper.mapToClothesImagesDto(clothesImage)).collect(Collectors.toList());
    }

    public List<ClothesImagesDto> changeClothesImagesOrder(Long clothesId, String imageUrl1, String imageUrl2) {
        Clothes clothes_info = clothesRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        ClothesImagesId clothesImagesId1 = new ClothesImagesId(clothes_info, imageUrl1);
        ClothesImagesId clothesImagesId2 = new ClothesImagesId(clothes_info, imageUrl2);

        ClothesImages clothesImages1 = clothesImagesRepository.findById(clothesImagesId1).orElseThrow(() -> 
            new ResourceNotFoundException("Image is not exist with given id : " + clothesImagesId1)
        );

        ClothesImages clothesImages2 = clothesImagesRepository.findById(clothesImagesId2).orElseThrow(() -> 
            new ResourceNotFoundException("Image is not exist with given id : " + clothesImagesId2)
        );

        Long order = clothesImages1.getOrder();
        clothesImages1.setOrder(clothesImages2.getOrder());
        clothesImages2.setOrder(order);

        ClothesImages updatedClothesImagesObj1 = clothesImagesRepository.save(clothesImages1);
        ClothesImages updatedClothesImagesObj2 = clothesImagesRepository.save(clothesImages2);

        List<ClothesImagesDto> updates = new ArrayList<>();
        updates.add(ClothesImagesMapper.mapToClothesImagesDto(updatedClothesImagesObj1));
        updates.add(ClothesImagesMapper.mapToClothesImagesDto(updatedClothesImagesObj2));

        return updates;
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

    @Override
    public void deleteClothesImagesByPosition(Long clothesId, Long order) {
        Clothes clothesInfo = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exists with given id : " + clothesId)
        );

        ClothesImages clothesImages = clothesImagesRepository.findByClothesAndOrder(clothesInfo, order);
        
        clothesImagesRepository.delete(clothesImages);
    }
}
