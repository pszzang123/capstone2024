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
import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.SellerDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.Clothes;
import com.example.demo.service.ClothesDetailService;
import com.example.demo.service.ClothesService;
import com.example.demo.service.SellerService;
import com.example.mapper.ClothesMapper;
import com.example.mapper.SellerMapper;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/detail")
public class ClothesDetailController {
    private ClothesDetailService clothesDetailService;
    private ClothesService clothesService;
    private SellerService sellerService;

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
        ClothesDto clothesDto = clothesService.getClothesById(clothesId);
        StatisticsDto statisticsDto = clothesService.getStatisticsById(clothesId);
        SellerDto sellerDto = sellerService.getSellerByEmail(clothesDto.getSellerEmail());
        Clothes clothes = ClothesMapper.mapToClothes(clothesDto, statisticsDto, SellerMapper.mapToSeller(sellerDto));
        List<ClothesDetailDto> clothesDetails = clothesDetailService.getClothesDetailByClothes(clothes);
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
