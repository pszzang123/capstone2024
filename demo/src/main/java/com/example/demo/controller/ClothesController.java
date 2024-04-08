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

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.dto.SubCategoryDto;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.Seller;
import com.example.demo.entity.SubCategory;
import com.example.demo.service.ClothesService;
import com.example.demo.service.MajorCategoryService;
import com.example.demo.service.SellerService;
import com.example.demo.service.SubCategoryService;
import com.example.demo.vo.ClothesVo;
import com.example.mapper.MajorCategoryMapper;
import com.example.mapper.SellerMapper;
import com.example.mapper.SubCategoryMapper;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/clothes")
public class ClothesController {
    private ClothesService clothesService;
    private SellerService sellerService;
    private MajorCategoryService majorCategoryService;
    private SubCategoryService subCategoryService;

    @PostMapping
    public ResponseEntity<ClothesDto> createClothes(@RequestBody ClothesDto clothesDto) {
        ClothesDto savedClothes = clothesService.createClothes(clothesDto);
        return new ResponseEntity<>(savedClothes, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<ClothesDto> getClothesById(@PathVariable("id") Long clothesId) {
        ClothesDto clothesDto = clothesService.getClothesById(clothesId);
        return ResponseEntity.ok(clothesDto);
    }

    @GetMapping("seller/{email}")
    public ResponseEntity<List<ClothesDto>> getClothesBySeller(@PathVariable("email") String sellerEmail) {
        Seller seller = SellerMapper.mapToSeller(sellerService.getSellerByEmail(sellerEmail));
        List<ClothesDto> clothes = clothesService.getClothesBySeller(seller);
        return ResponseEntity.ok(clothes);
    }

    @GetMapping("major_category/{id}")
    public ResponseEntity<List<ClothesDto>> getClothesByMajorCategory(@PathVariable("id") Long majorCategoryId) {
        MajorCategory majorCategory = MajorCategoryMapper.mapToMajorCategory(majorCategoryService.getMajorCategoryById(majorCategoryId));
        List<ClothesDto> clothes = clothesService.getClothesByMajorCategory(majorCategory);
        return ResponseEntity.ok(clothes);
    }

    @GetMapping("sub_category/{id}")
    public ResponseEntity<List<ClothesDto>> getClothesBySubCategory(@PathVariable("id") Long subCategoryId) {
        SubCategoryDto subCategoryDto = subCategoryService.getSubCategoryById(subCategoryId);
        SubCategory subCategory = SubCategoryMapper.mapToSubCategory(subCategoryDto, MajorCategoryMapper.mapToMajorCategory(majorCategoryService.getMajorCategoryById(subCategoryDto.getMajorCategoryId())));
        List<ClothesDto> clothes = clothesService.getClothesBySubCategory(subCategory);
        return ResponseEntity.ok(clothes);
    }

    @GetMapping("statistics/{id}")
    public ResponseEntity<StatisticsDto> getStatisticsById(@PathVariable("id") Long clothesId) {
        StatisticsDto statisticsDto = clothesService.getStatisticsById(clothesId);
        return ResponseEntity.ok(statisticsDto);
    }

    @GetMapping("search/{name}")
    public ResponseEntity<List<ClothesVo>> getClothesById(@PathVariable("name") String name) {
        List<ClothesVo> clothesVo = clothesService.searchClothesByNameOrderByDailyView(name);
        return ResponseEntity.ok(clothesVo);
    }

    @GetMapping
    public ResponseEntity<List<ClothesDto>> getAllClothes() {
        List<ClothesDto> clothes = clothesService.getAllClothes();
        return ResponseEntity.ok(clothes);
    }

    @PutMapping("{id}")
    public ResponseEntity<ClothesDto> updateClothes(@PathVariable("id") Long clothesId, @RequestBody ClothesDto updatedClothes) {
        ClothesDto clothesDto = clothesService.updateClothes(clothesId, updatedClothes);
        return ResponseEntity.ok(clothesDto);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteClothes(@PathVariable("id") Long clothesId) {
        clothesService.deleteClothes(clothesId);
        return ResponseEntity.ok("Clothes deleted successfully.");
    }
}
