package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.SubCategoryDto;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.SubCategory;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.MajorCategoryRepository;
import com.example.demo.repository.SubCategoryRepository;
import com.example.demo.service.SubCategoryService;
import com.example.mapper.SubCategoryMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class SubCategoryServiceImpl implements SubCategoryService {
    private MajorCategoryRepository majorCategoryRepository;
    private SubCategoryRepository subCategoryRepository;

    @Override
    public SubCategoryDto createSubCategory(SubCategoryDto subCategoryDto) {
        MajorCategory majorCategoryInfo = majorCategoryRepository.findById(subCategoryDto.getMajorCategoryId()).orElseThrow(() -> 
            new ResourceNotFoundException("Major Category is not exists with given id : " + subCategoryDto.getMajorCategoryId())
        );
        SubCategory subCategory = SubCategoryMapper.mapToSubCategory(subCategoryDto, majorCategoryInfo);
        SubCategory savedSubCategory = subCategoryRepository.save(subCategory);
        return SubCategoryMapper.mapToSubCategoryDto(savedSubCategory);
    }

    @Override
    public SubCategoryDto getSubCategoryById(Long subCategoryId) {
        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Sub Category is not exists with given id : " + subCategoryId)
        );
        
        return SubCategoryMapper.mapToSubCategoryDto(subCategory);
    }

    @Override
    public List<SubCategoryDto> getSubCategoryByMajorCategoryId(Long majorCategoryId) {
        MajorCategory majorCategoryInfo = majorCategoryRepository.findById(majorCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Major Category is not exists with given id : " + majorCategoryId)
        );
        List<SubCategory> subCategories = subCategoryRepository.findAllByMajorCategory(majorCategoryInfo);
        return subCategories.stream().map((subCategory) -> SubCategoryMapper.mapToSubCategoryDto(subCategory)).collect(Collectors.toList());
    }

    @Override
    public List<SubCategoryDto> getAllSubCategories() {
        List<SubCategory> subCategories = subCategoryRepository.findAll();
        return subCategories.stream().map((subCategory) -> SubCategoryMapper.mapToSubCategoryDto(subCategory)).collect(Collectors.toList());
    }

    @Override
    public void deleteSubCategory(Long subCategoryId) {
        subCategoryRepository.findById(subCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        majorCategoryRepository.deleteById(subCategoryId);
    }
}
