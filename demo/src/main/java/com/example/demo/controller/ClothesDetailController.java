package com.example.demo.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.ClothesDetailDto;
import com.example.demo.service.ClothesDetailService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/detail")
public class ClothesDetailController {
    private ClothesDetailService clothesDetailService;
    

    @PostMapping
    public ResponseEntity<ClothesDetailDto> createClothesDetail(@RequestBody ClothesDetailDto clothesDetailDto) {
        ClothesDetailDto savedClothesDetail = clothesDetailService.createClothesDetail(clothesDetailDto);
        return new ResponseEntity<>(savedClothesDetail, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<ClothesDetailDto> getClothesDetailById(@PathVariable("id") Long detailId) {
        ClothesDetailDto clothesDetailDto = clothesDetailService.getClothesDetailById(detailId);
        return ResponseEntity.ok(clothesDetailDto);
    }

    @GetMapping("clothes/{id}")
    public ResponseEntity<List<ClothesDetailDto>> getClothesDetailsByClothes(@PathVariable("id") Long clothesId) {
        List<ClothesDetailDto> clothesDetails = clothesDetailService.getClothesDetailByClothes(clothesId);
        return ResponseEntity.ok(clothesDetails);
    }

    @GetMapping
    public ResponseEntity<List<ClothesDetailDto>> getAllClothesDetail() {
        List<ClothesDetailDto> clothesDetails = clothesDetailService.getAllClothesDetails();
        return ResponseEntity.ok(clothesDetails);
    }

    @PutMapping("{id}")
    public ResponseEntity<ClothesDetailDto> updateClothesDetail(@PathVariable("id") Long detailId, @RequestBody ClothesDetailDto updatedClothesDetail) {
        ClothesDetailDto clothesDetailDto = clothesDetailService.updateClothesDetail(detailId, updatedClothesDetail);
        return ResponseEntity.ok(clothesDetailDto);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteClothesDetail(@PathVariable("id") Long detailId) {
        clothesDetailService.deleteClothesDetail(detailId);
        return ResponseEntity.ok("Clothes Detail deleted successfully.");
    }

    @DeleteMapping("clothes/{id}")
    public ResponseEntity<String> deleteClothesDetailByClothesId(@PathVariable("id") Long clothesId) {
        clothesDetailService.deleteClothesDetailByClothesId(clothesId);
        return ResponseEntity.ok("Clothes Detail deleted successfully.");
    }
}
