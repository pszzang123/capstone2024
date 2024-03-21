package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ClothesDetailDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.service.ClothesDetailService;
import com.example.mapper.ClothesDetailMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ClothesDetailServiceImpl implements ClothesDetailService {
    private ClothesDetailRepository clothesDetailRepository;
    private ClothesRepository clothesRepository;

    @Override
    public ClothesDetailDto createClothesDetail(ClothesDetailDto clothesDetailDto) {
        Clothes clothes_info = clothesRepository.findById(clothesDetailDto.getClothesId()).orElseThrow(() ->
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesDetailDto.getClothesId())
        );
        ClothesDetail clothesDetail = ClothesDetailMapper.mapToClothesDetail(clothesDetailDto, clothes_info);
        ClothesDetail savedClothesDetail = clothesDetailRepository.save(clothesDetail);
        return ClothesDetailMapper.mapToClothesDetailDto(savedClothesDetail);
    }

    @Override
    public ClothesDetailDto getClothesDetailById(Long detailId) {
        ClothesDetail clothesDetail = clothesDetailRepository.findById(detailId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes Detail is not exist with given id : " + detailId)
        );
        
        return ClothesDetailMapper.mapToClothesDetailDto(clothesDetail);
    }

    @Override
    public List<ClothesDetailDto> getClothesDetailByClothes(Clothes clothes) {
        List<ClothesDetail> clothesDetails = clothesDetailRepository.findAllByClothes(clothes);
        return clothesDetails.stream().map((clothesDetail) -> ClothesDetailMapper.mapToClothesDetailDto(clothesDetail)).collect(Collectors.toList());
    }

    @Override
    public List<ClothesDetailDto> getAllClothesDetails() {
        List<ClothesDetail> clothesDetails = clothesDetailRepository.findAll();
        return clothesDetails.stream().map((clothesDetail) -> ClothesDetailMapper.mapToClothesDetailDto(clothesDetail)).collect(Collectors.toList());
    }

    @Override
    public ClothesDetailDto updateClothesDetail(Long detailId, ClothesDetailDto updatedClothesDetail) {
        ClothesDetail clothesDetail = clothesDetailRepository.findById(detailId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + detailId)
        );

        clothesDetail.setColor(updatedClothesDetail.getColor());
        clothesDetail.setSize(updatedClothesDetail.getSize());
        clothesDetail.setRemaining(updatedClothesDetail.getRemaining());
        clothesDetail.setValue(updatedClothesDetail.getValue());

        ClothesDetail updatedClothesDetailObj = clothesDetailRepository.save(clothesDetail);

        return ClothesDetailMapper.mapToClothesDetailDto(updatedClothesDetailObj);
    }

    @Override
    public void deleteClothesDetail(Long detailId) {
        clothesDetailRepository.findById(detailId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes Detail is not exists with given id : " + detailId)
        );
        
        clothesDetailRepository.deleteById(detailId);
    }
}
