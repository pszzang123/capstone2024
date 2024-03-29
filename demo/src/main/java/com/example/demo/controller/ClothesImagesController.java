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

import com.example.demo.dto.ClothesImagesDto;
import com.example.demo.service.ClothesImagesService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/clothes_images")
public class ClothesImagesController {
    private ClothesImagesService clothesImagesService;

    @PostMapping
    public ResponseEntity<ClothesImagesDto> createClothesImages(@RequestBody ClothesImagesDto clothesImagesDto) {
        ClothesImagesDto savedClothesImages = clothesImagesService.createClothesImages(clothesImagesDto);
        return new ResponseEntity<>(savedClothesImages, HttpStatus.CREATED);
    }

    @GetMapping("/{clothes_id}")
    public ResponseEntity<List<ClothesImagesDto>> getImageUrlByClothesId(@PathVariable("clothes_id") Long clothesId) {
        List<ClothesImagesDto> imageUrls = clothesImagesService.getImageUrlsByClothesId(clothesId);
        return ResponseEntity.ok(imageUrls);
    }

    @GetMapping
    public ResponseEntity<List<ClothesImagesDto>> getAllClothesImages() {
        List<ClothesImagesDto> clothesImages = clothesImagesService.getAllClothesImages();
        return ResponseEntity.ok(clothesImages);
    }

    @PutMapping("{clothes_id}/{url1}/{url2}")
    public ResponseEntity<List<ClothesImagesDto>> updateClothes(@PathVariable("clothes_id") Long clothesId, @PathVariable("url1") String url1, @PathVariable("url2") String url2) {
        List<ClothesImagesDto> clothesImagesDtos = clothesImagesService.changeClothesImagesOrder(clothesId, url1, url2);
        return ResponseEntity.ok(clothesImagesDtos);
    }

    @DeleteMapping("{clothes_id}/{image_url}")
    public ResponseEntity<String> deleteClothesImages(@PathVariable("clothes_id") Long clothesId, @PathVariable("image_url") String imageUrl) {
        clothesImagesService.deleteClothesImagesById(clothesId, imageUrl);
        return ResponseEntity.ok("Clothes Image deleted successfully.");
    }
}
