package com.example.demo.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.SubCategoryDto;
import com.example.demo.service.SubCategoryService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/sub_category")
public class SubCategoryController {
    private SubCategoryService subCategoryService;

    @PostMapping
    public ResponseEntity<SubCategoryDto> createSubCategory(@RequestBody SubCategoryDto subCategoryDto) {
        SubCategoryDto savedSubCategory = subCategoryService.createSubCategory(subCategoryDto);
        return new ResponseEntity<>(savedSubCategory, HttpStatus.CREATED);
    }

    @GetMapping("major_category/{major_category_id}")
    public ResponseEntity<List<SubCategoryDto>> getSubCategoryByMajorCategoryId(@PathVariable("major_category_id") Long majorCategoryId) {
        List<SubCategoryDto> subCategoryDtos = subCategoryService.getSubCategoryByMajorCategoryId(majorCategoryId);
        return ResponseEntity.ok(subCategoryDtos);
    }

    @GetMapping("{id}")
    public ResponseEntity<SubCategoryDto> getMajorCategoryById(@PathVariable("id") Long subCategoryId) {
        SubCategoryDto subCategoryDto = subCategoryService.getSubCategoryById(subCategoryId);
        return ResponseEntity.ok(subCategoryDto);
    }

    @GetMapping
    public ResponseEntity<List<SubCategoryDto>> getAllSubCategories() {
        List<SubCategoryDto> subCategories = subCategoryService.getAllSubCategories();
        return ResponseEntity.ok(subCategories);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteSubCategory(@PathVariable("id") Long subCategoryId) {
        subCategoryService.deleteSubCategory(subCategoryId);
        return ResponseEntity.ok("Cart deleted successfully.");
    }
}
