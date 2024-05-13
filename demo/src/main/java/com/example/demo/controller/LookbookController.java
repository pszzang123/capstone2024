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

import com.example.demo.dto.LookbookDto;
import com.example.demo.service.LookbookService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/lookbook")
public class LookbookController {
    private LookbookService lookbookService;

    @PostMapping
    public ResponseEntity<LookbookDto> createLookbook(@RequestBody LookbookDto lookbookDto) {
        LookbookDto savedLookbook = lookbookService.createLookbook(lookbookDto);
        return new ResponseEntity<>(savedLookbook, HttpStatus.CREATED);
    }

    @PostMapping("{id}/{email}")
    public ResponseEntity<LookbookDto> copyLookbook(@PathVariable("id") Long lookbookId, @PathVariable("email") String customerEmail) {
        LookbookDto savedLookbook = lookbookService.copyLookbook(lookbookId, customerEmail);
        return new ResponseEntity<>(savedLookbook, HttpStatus.CREATED);
    }

    @GetMapping("{email}")
    public ResponseEntity<List<LookbookDto>> getLookbookByCustomerEmail(@PathVariable("email") String customerEmail) {
        List<LookbookDto> lookbookDtos = lookbookService.getLookbookByCustomerEmail(customerEmail);
        return ResponseEntity.ok(lookbookDtos);
    }

    @GetMapping
    public ResponseEntity<List<LookbookDto>> getAllLookbook() {
        List<LookbookDto> lookbooks = lookbookService.getAllLookbooks();
        return ResponseEntity.ok(lookbooks);
    }

    @PutMapping("{id}")
    public ResponseEntity<LookbookDto> updateLookbook(@PathVariable("id") Long lookbookId, @RequestBody LookbookDto lookbookDto) {
        LookbookDto lookbook = lookbookService.updateLookbook(lookbookId, lookbookDto);
        return ResponseEntity.ok(lookbook);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteLookbook(@PathVariable("id") Long lookbookId) {
        lookbookService.deleteLookbookById(lookbookId);
        return ResponseEntity.ok("Lookbook deleted successfully.");
    }
}
