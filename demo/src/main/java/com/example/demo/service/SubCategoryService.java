package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.SubCategoryDto;

public interface SubCategoryService {
    SubCategoryDto createSubCategory(SubCategoryDto subCategoryDto);

    SubCategoryDto getSubCategoryById(Long subCategoryId);

    List<SubCategoryDto> getSubCategoryByMajorCategoryId(Long majorCategoryId);

    List<SubCategoryDto> getAllSubCategories();

    void deleteSubCategory(Long subCategoryId);
}
