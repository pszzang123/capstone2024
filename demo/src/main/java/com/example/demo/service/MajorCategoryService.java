package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.MajorCategoryDto;

public interface MajorCategoryService {
    MajorCategoryDto createMajorCategory(MajorCategoryDto majorCategoryDto);

    MajorCategoryDto getMajorCategoryById(Long majorCategoryId);

    List<MajorCategoryDto> getAllMajorCategories();

    void deleteMajorCategory(Long majorCategoryId);
}
