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

import com.example.demo.dto.MajorCategoryDto;
import com.example.demo.service.MajorCategoryService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/major_category")
public class MajorCategoryController {
    private MajorCategoryService majorCategoryService;

    @PostMapping
    public ResponseEntity<MajorCategoryDto> createMajorCategory(@RequestBody MajorCategoryDto majorCategoryDto) {
        MajorCategoryDto savedMajorCategory = majorCategoryService.createMajorCategory(majorCategoryDto);
        return new ResponseEntity<>(savedMajorCategory, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<MajorCategoryDto> getMajorCategoryById(@PathVariable("id") Long majorCategoryId) {
        MajorCategoryDto majorCategoryDto = majorCategoryService.getMajorCategoryById(majorCategoryId);
        return ResponseEntity.ok(majorCategoryDto);
    }

    @GetMapping
    public ResponseEntity<List<MajorCategoryDto>> getAllMajorCategory() {
        List<MajorCategoryDto> majorCategories = majorCategoryService.getAllMajorCategories();
        return ResponseEntity.ok(majorCategories);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteMajorCategory(@PathVariable("id") Long majorCategoryId) {
        majorCategoryService.deleteMajorCategory(majorCategoryId);
        return ResponseEntity.ok("Cart deleted successfully.");
    }
}
