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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.Seller;
import com.example.demo.service.ClothesService;
import com.example.demo.service.SellerService;
import com.example.demo.vo.ClothesVo;
import com.example.mapper.SellerMapper;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/clothes")
public class ClothesController {
    private ClothesService clothesService;
    private SellerService sellerService;

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
    public ResponseEntity<List<ClothesVo>> getClothesBySeller(@PathVariable("email") String sellerEmail) {
        Seller seller = SellerMapper.mapToSeller(sellerService.getSellerByEmail(sellerEmail));
        List<ClothesVo> clothes = clothesService.getClothesBySeller(seller);
        return ResponseEntity.ok(clothes);
    }

    @GetMapping("statistics/{id}")
    public ResponseEntity<StatisticsDto> getStatisticsById(@PathVariable("id") Long clothesId) {
        StatisticsDto statisticsDto = clothesService.getStatisticsById(clothesId);
        return ResponseEntity.ok(statisticsDto);
    }

    @GetMapping("search/{name}")
    public ResponseEntity<List<ClothesVo>> getClothesByName(@RequestParam(name = "gender", required = false) Integer genderCategory, @RequestParam(name = "major_category", required = false) Long majorCategoryId, @RequestParam(name = "sub_category", required = false) Long subCategoryId, @PathVariable("name") String name) {
        List<ClothesVo> clothesVos = null;
        if (genderCategory != null) {
            if (majorCategoryId != null) {
                if (subCategoryId != null) {
                    clothesVos = clothesService.searchClothesByGenderCategoryAndMajorCategoryAndSubCategoryAndName(genderCategory, majorCategoryId, subCategoryId, name);
                }
                else {
                    clothesVos = clothesService.searchClothesByGenderCategoryAndMajorCategoryAndName(genderCategory, majorCategoryId, name);
                }
            }
            else {
                if (subCategoryId != null) {
                    clothesVos = clothesService.searchClothesByGenderCategoryAndSubCategoryAndName(genderCategory, subCategoryId, name);
                }
                else {
                    clothesVos = clothesService.searchClothesByGenderCategoryAndName(genderCategory, name);
                }
            }
        }
        else {
            if (majorCategoryId != null) {
                if (subCategoryId != null) {
                    clothesVos = clothesService.searchClothesByMajorCategoryAndSubCategoryAndName(majorCategoryId, subCategoryId, name);
                }
                else {
                    clothesVos = clothesService.searchClothesByMajorCategoryAndName(majorCategoryId, name);
                }
            }
            else {
                if (subCategoryId != null) {
                    clothesVos = clothesService.searchClothesBySubCategoryAndName(subCategoryId, name);
                }
                else {
                    clothesVos = clothesService.searchClothesByName(name);
                }
            }
        }
        return ResponseEntity.ok(clothesVos);
    }

    @GetMapping
    public ResponseEntity<List<ClothesVo>> getClothes(@RequestParam(name = "gender", required = false) Integer genderCategory, @RequestParam(name = "major_category", required = false) Long majorCategoryId, @RequestParam(name = "sub_category", required = false) Long subCategoryId) {
        List<ClothesVo> clothesVos = null;
        if (genderCategory != null) {
            if (majorCategoryId != null) {
                if (subCategoryId != null) {
                    clothesVos = clothesService.getClothesByGenderCategoryAndMajorCategoryAndSubCategory(genderCategory, majorCategoryId, subCategoryId);
                }
                else {
                    clothesVos = clothesService.getClothesByGenderCategoryAndMajorCategory(genderCategory, majorCategoryId);
                }
            }
            else {
                if (subCategoryId != null) {
                    clothesVos = clothesService.getClothesByGenderCategoryAndSubCategory(genderCategory, subCategoryId);
                }
                else {
                    clothesVos = clothesService.getClothesByGenderCategory(genderCategory);
                }
            }
        }
        else {
            if (majorCategoryId != null) {
                if (subCategoryId != null) {
                    clothesVos = clothesService.getClothesByMajorCategoryAndSubCategory(majorCategoryId, subCategoryId);
                }
                else {
                    clothesVos = clothesService.getClothesByMajorCategory(majorCategoryId);
                }
            }
            else {
                if (subCategoryId != null) {
                    clothesVos = clothesService.getClothesBySubCategory(subCategoryId);
                }
                else {
                    clothesVos = clothesService.getAllClothes();
                }
            }
        }
        return ResponseEntity.ok(clothesVos);
    }

    @PutMapping("sort/{id}")
    public ResponseEntity<List<ClothesVo>> sortClothesVos(@PathVariable("id") Integer sortId, @RequestBody List<ClothesVo> clothes) {
        List<ClothesVo> sortedClothes = clothesService.sortClothesVos(clothes, sortId);
        return ResponseEntity.ok(sortedClothes);
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
