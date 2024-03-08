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

import com.example.demo.dto.SellerDto;
import com.example.demo.service.SellerService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/sellers")
public class SellerController {
    private SellerService sellerService;

    // Build Add Employee REST API
    @PostMapping
    public ResponseEntity<SellerDto> createSeller(@RequestBody SellerDto sellerDto) {
        SellerDto savedSeller = sellerService.createSeller(sellerDto);
        return new ResponseEntity<>(savedSeller, HttpStatus.CREATED);
    }

    // Build Get Employee REST API
    @GetMapping("{id}")
    public ResponseEntity<SellerDto> getSellerByEmail(@PathVariable("id") String customerEmail) {
        SellerDto sellerDto = sellerService.getSellerByEmail(customerEmail);
        return ResponseEntity.ok(sellerDto);
    }

    // Build Get All Employees REST API
    @GetMapping
    public ResponseEntity<List<SellerDto>> getAllSellers() {
        List<SellerDto> sellers = sellerService.getAllSellers();
        return ResponseEntity.ok(sellers);
    }

    // Build Update Employee REST API
    @PutMapping("{id}")
    public ResponseEntity<SellerDto> updateSeller(@PathVariable("id") String customerEmail, @RequestBody SellerDto updatedSeller) {
        SellerDto sellerDto = sellerService.updateSeller(customerEmail, updatedSeller);
        return ResponseEntity.ok(sellerDto);
    }

    // Build Delete Employee REST API
    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteCustomer(@PathVariable("id") String customerEmail) {
        sellerService.deleteSeller(customerEmail);
        return ResponseEntity.ok("Seller deleted successfully.");
    }
}
