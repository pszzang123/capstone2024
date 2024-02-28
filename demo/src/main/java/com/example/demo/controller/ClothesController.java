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
import com.example.demo.entity.Customer;
import com.example.demo.service.ClothesService;
import com.example.demo.service.CustomerService;
import com.example.mapper.CustomerMapper;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/clothes")
public class ClothesController {
    private ClothesService clothesService;
    private CustomerService customerService;

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
        Customer seller = CustomerMapper.mapToCustomer(customerService.getCustomerByEmail(sellerEmail));
        List<ClothesDto> clothes = clothesService.getClothesBySeller(seller);
        return ResponseEntity.ok(clothes);
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
