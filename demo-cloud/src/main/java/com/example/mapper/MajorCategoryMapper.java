package com.example.mapper;

import com.example.demo.dto.MajorCategoryDto;
import com.example.demo.entity.MajorCategory;

public class MajorCategoryMapper {
    public static MajorCategoryDto mapToMajorCategoryDto(MajorCategory majorCategory) {
        return new MajorCategoryDto(
            majorCategory.getMajorCategoryId(),
            majorCategory.getName()
        );
    }

    public static MajorCategory mapToMajorCategory(MajorCategoryDto majorCategoryDto) {
        return new MajorCategory(
            majorCategoryDto.getMajorCategoryId(),
            majorCategoryDto.getName()
        );
    }
}
