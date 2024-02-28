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

import com.example.demo.dto.CategoryDto;
import com.example.demo.dto.ClothesCategoriesDto;
import com.example.demo.dto.ClothesDto;
import com.example.demo.service.ClothesCategoriesService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/clothes_categories")
public class ClothesCategoriesController {
    private ClothesCategoriesService clothesCategoriesService;

    @PostMapping
    public ResponseEntity<ClothesCategoriesDto> createClothesCategories(@RequestBody ClothesCategoriesDto clothesCategoriesDto) {
        ClothesCategoriesDto savedClothes = clothesCategoriesService.createClothesCategories(clothesCategoriesDto);
        return new ResponseEntity<>(savedClothes, HttpStatus.CREATED);
    }

    @GetMapping("category/{category_id}")
    public ResponseEntity<List<ClothesDto>> getClothesByCategoryId(@PathVariable("category_id") Long categoryId) {
        List<ClothesDto> clothes = clothesCategoriesService.getClothesByCategoryId(categoryId);
        return ResponseEntity.ok(clothes);
    }

    @GetMapping("clothes/{clothes_id}")
    public ResponseEntity<List<CategoryDto>> getCategoriesByClothesId(@PathVariable("clothes_id") Long clothesId) {
        List<CategoryDto> categories = clothesCategoriesService.getCategoriesByClothesId(clothesId);
        return ResponseEntity.ok(categories);
    }

    @GetMapping
    public ResponseEntity<List<ClothesCategoriesDto>> getAllClothesCategories() {
        List<ClothesCategoriesDto> clothesCategories = clothesCategoriesService.getAllClothesCategories();
        return ResponseEntity.ok(clothesCategories);
    }

    @DeleteMapping("{clothes_id}/{category_id}")
    public ResponseEntity<String> deleteClothes(@PathVariable("clothes_id") Long clothesId, @PathVariable("category_id") Long categoryId) {
        clothesCategoriesService.deleteClothesCategoriesById(clothesId, categoryId);
        return ResponseEntity.ok("Clothes Category deleted successfully.");
    }
}
