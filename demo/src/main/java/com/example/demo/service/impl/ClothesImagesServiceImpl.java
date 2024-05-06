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

    @Override
    public List<ClothesImagesDto> updateAllClothesImages(List<ClothesImagesDto> clothesImagesDtos) {
        Long clothesId = clothesImagesDtos.get(0).getClothesId();
        for(ClothesImagesDto clothesImagesDto : clothesImagesDtos) {
            if (clothesImagesDto.getClothesId() != clothesId) {
                return null;
            }
        }

        Clothes clothes_info = clothesRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        List<ClothesImages> pastClothesImages = clothesImagesRepository.findAllByClothes(clothes_info);
        pastClothesImages.forEach((clothesImage) -> {
            clothesImagesRepository.delete(clothesImage);
        });

        List<ClothesImagesDto> savedClothesImagesDtos = clothesImagesDtos.stream().map((clothesImagesDto) -> {
            Boolean addable = true;
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
        }).collect(Collectors.toList());

        return savedClothesImagesDtos;
    }

    @Override
    public ClothesImagesDto changeClothesImagesOrder(Long clothesId, Long pos1, Long pos2) {
        Clothes clothes_info = clothesRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        ClothesImages clothesImage = clothesImagesRepository.findByClothesAndOrder(clothes_info, pos1);

        clothesImage.setOrder(pos2);

        ClothesImages updatedClothesImagesObj = clothesImagesRepository.save(clothesImage);
        ClothesImagesDto clothesImagesDto = ClothesImagesMapper.mapToClothesImagesDto(updatedClothesImagesObj);

        return clothesImagesDto;
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

        ClothesImages clothesImage = clothesImagesRepository.findByClothesAndOrder(clothesInfo, order);

        if (clothesImage != null) {
            Long removedOrder = clothesImage.getOrder();
            clothesImagesRepository.delete(clothesImage);
            List<ClothesImages> allImages = clothesImagesRepository.findAllByClothes(clothesInfo);
            for (ClothesImages image : allImages) {
                if (image.getOrder() > removedOrder) {
                    image.setOrder(image.getOrder() - 1);
                    clothesImagesRepository.save(image);
                }
            }
        } else {
            throw new ResourceNotFoundException("Clothes Image with given order not found for clothes id : " + clothesId + " and order : " + order);
        }
    }
}
