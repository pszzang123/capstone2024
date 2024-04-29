package com.example.mapper;

import com.example.demo.dto.SubCategoryDto;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.SubCategory;

public class SubCategoryMapper {
    public static SubCategoryDto mapToSubCategoryDto(SubCategory subCategory) {
        return new SubCategoryDto(
            subCategory.getSubCategoryId(),
            subCategory.getMajorCategory().getMajorCategoryId(),
            subCategory.getName()
        );
    }

    public static SubCategory mapToSubCategory(SubCategoryDto subCategoryDto, MajorCategory majorCategory) {
        return new SubCategory(
            subCategoryDto.getSubCategoryId(),
            majorCategory,
            subCategoryDto.getName()
        );
    }
}
