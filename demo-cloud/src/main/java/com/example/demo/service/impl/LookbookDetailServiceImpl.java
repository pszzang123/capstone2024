package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.LookbookDetailDto;
import com.example.demo.dto.LookbookDto;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Lookbook;
import com.example.demo.entity.LookbookDetail;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.LookbookDetailRepository;
import com.example.demo.repository.LookbookRepository;
import com.example.demo.service.LookbookDetailService;
import com.example.mapper.LookbookDetailMapper;
import com.example.mapper.LookbookMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class LookbookDetailServiceImpl implements LookbookDetailService {
    private ClothesDetailRepository clothesDetailRepository;
    private LookbookRepository lookbookRepository;
    private LookbookDetailRepository lookbookDetailRepository;

    @Override
    public LookbookDetailDto createLookbookDetail(LookbookDetailDto lookbookDetailDto) {
        Lookbook lookbook_info = lookbookRepository.findById(lookbookDetailDto.getLookbookId()).orElseThrow(() ->
            new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookDetailDto.getLookbookId())
        );
        ClothesDetail clothesDetail_info = clothesDetailRepository.findById(lookbookDetailDto.getDetailId()).orElseThrow(() ->
            new ResourceNotFoundException("Clothes Detail is not exist with given id : " + lookbookDetailDto.getDetailId())
        );

        LookbookDetail lookbookDetail = LookbookDetailMapper.mapToLookbookDetail(lookbookDetailDto, lookbook_info, clothesDetail_info);
        LookbookDetail savedLookbookDetail = lookbookDetailRepository.save(lookbookDetail);
        return LookbookDetailMapper.mapToLookbookDetailDto(savedLookbookDetail);
    }

    @Override
    public List<LookbookDetailDto> getLookbookDetailByLookbookId(Long lookbookId) {
        Lookbook lookbookInfo = lookbookRepository.findById(lookbookId).orElseThrow(() -> 
            new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId)
        );

        List<LookbookDetail> lookbookDetails = lookbookDetailRepository.findAllByLookbook(lookbookInfo);

        return lookbookDetails.stream().map((lookbookDetail) -> LookbookDetailMapper.mapToLookbookDetailDto(lookbookDetail)).collect(Collectors.toList());
    }

    @Override
    public List<LookbookDto> getLookbooksByDetailId(Long detailId) {
        ClothesDetail clothesDetail = clothesDetailRepository.findById(detailId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes Detail is not exist with given id : " + detailId)
        );

        List<LookbookDetail> lookbookDetails = lookbookDetailRepository.findAllByClothesDetail(clothesDetail);

        List<LookbookDto> lookbookDtos = lookbookDetails.stream().map((lookbookDetail) -> LookbookMapper.mapToLookbookDto(lookbookDetail.getLookbook())).collect(Collectors.toList());
        
        return lookbookDtos;
    }

    @Override
    public List<LookbookDetailDto> getAllLookbookDetail() {
        List<LookbookDetail> lookbookDetails = lookbookDetailRepository.findAll();
        return lookbookDetails.stream().map((lookbookDetail) -> LookbookDetailMapper.mapToLookbookDetailDto(lookbookDetail)).collect(Collectors.toList());
    }

    @Override
    public void deleteLookbookDetailById(Long lookbookDetailId) {
        LookbookDetail lookbookDetail = lookbookDetailRepository.findById(lookbookDetailId).orElseThrow(() -> 
            new ResourceNotFoundException("Lookbook Detail is not exist with given id : " + lookbookDetailId)
        );

        lookbookDetailRepository.delete(lookbookDetail);
    }

    @Override
    public void deleteLookbookDetailByLookbookId(Long lookbookId) {
        List<LookbookDetail> lookbookDetails = null;
        try{
            Lookbook lookbookInfo = lookbookRepository.findById(lookbookId).orElseThrow(() -> 
                new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId)
            );
            lookbookDetails = lookbookDetailRepository.findAllByLookbook(lookbookInfo);
        } catch (Exception e) {
            new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId);
            return;
        }
        
        lookbookDetails.forEach((lookbookDetail) -> lookbookDetailRepository.delete(lookbookDetail));
    }
}
