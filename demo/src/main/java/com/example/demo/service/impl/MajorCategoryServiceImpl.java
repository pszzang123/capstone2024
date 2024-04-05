package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.MajorCategoryDto;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.SubCategory;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.MajorCategoryRepository;
import com.example.demo.repository.SubCategoryRepository;
import com.example.demo.service.MajorCategoryService;
import com.example.mapper.MajorCategoryMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class MajorCategoryServiceImpl implements MajorCategoryService {
    private MajorCategoryRepository majorCategoryRepository;
    private SubCategoryRepository subCategoryRepository;

    @Override
    public MajorCategoryDto createMajorCategory(MajorCategoryDto majorCategoryDto) {
        MajorCategory majorCategory = MajorCategoryMapper.mapToMajorCategory(majorCategoryDto);
        MajorCategory savedMajorCategory = majorCategoryRepository.save(majorCategory);
        return MajorCategoryMapper.mapToMajorCategoryDto(savedMajorCategory);
    }

    @Override
    public MajorCategoryDto getMajorCategoryById(Long majorCategoryId) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Major Category is not exists with given id : " + majorCategoryId)
        );
        
        return MajorCategoryMapper.mapToMajorCategoryDto(majorCategory);
    }

    @Override
    public List<MajorCategoryDto> getAllMajorCategories() {
        List<MajorCategory> majorCategories = majorCategoryRepository.findAll();
        return majorCategories.stream().map((majorCategory) -> MajorCategoryMapper.mapToMajorCategoryDto(majorCategory)).collect(Collectors.toList());
    }

    @Override
    public void deleteMajorCategory(Long majorCategoryId) {
        List<SubCategory> subCategories = null;
        try{
            MajorCategory majorCategoryInfo = majorCategoryRepository.findById(majorCategoryId).orElseThrow(() -> 
                new ResourceNotFoundException("Major Category is not exists with given id : " + majorCategoryId)
            );
            subCategories = subCategoryRepository.findAllByMajorCategory(majorCategoryInfo);
        } catch (Exception e) {
            new ResourceNotFoundException("Major Category is not exists with given id : " + majorCategoryId);
            return;
        }

        subCategories.forEach((subCategory) -> subCategoryRepository.delete(subCategory));

        majorCategoryRepository.deleteById(majorCategoryId);
    }
}
