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

import com.example.demo.dto.LookbookDetailDto;
import com.example.demo.dto.LookbookDto;
import com.example.demo.service.LookbookDetailService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/lookbook_detail")
public class LookbookDetailController {
    private LookbookDetailService lookbookDetailService;

    @PostMapping
    public ResponseEntity<LookbookDetailDto> createLookbookDetail(@RequestBody LookbookDetailDto lookbookDetailDto) {
        LookbookDetailDto savedLookbookDetail = lookbookDetailService.createLookbookDetail(lookbookDetailDto);
        return new ResponseEntity<>(savedLookbookDetail, HttpStatus.CREATED);
    }

    @GetMapping("lookbook/{id}")
    public ResponseEntity<List<LookbookDetailDto>> getLookbookDetailByLookbookId(@PathVariable("id") Long lookbookId) {
        List<LookbookDetailDto> lookbookDetailDtos = lookbookDetailService.getLookbookDetailByLookbookId(lookbookId);
        return ResponseEntity.ok(lookbookDetailDtos);
    }

    @GetMapping("clothes_detail/{id}")
    public ResponseEntity<List<LookbookDto>> getLookbooksByDetailId(@PathVariable("id") Long detailId) {
        List<LookbookDto> lookbookDtos = lookbookDetailService.getLookbooksByDetailId(detailId);
        return ResponseEntity.ok(lookbookDtos);
    }

    @GetMapping
    public ResponseEntity<List<LookbookDetailDto>> getAllLookbooks() {
        List<LookbookDetailDto> lookbooks = lookbookDetailService.getAllLookbookDetail();
        return ResponseEntity.ok(lookbooks);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteLookbookDetail(@PathVariable("id") Long lookbookDetailId) {
        lookbookDetailService.deleteLookbookDetailById(lookbookDetailId);
        return ResponseEntity.ok("Lookbook Detail deleted successfully.");
    }

    @DeleteMapping("lookbook/{id}")
    public ResponseEntity<String> deleteLookbookDetailByLookbookId(@PathVariable("id") Long lookbookId) {
        lookbookDetailService.deleteLookbookDetailByLookbookId(lookbookId);
        return ResponseEntity.ok("Lookbook Details deleted successfully.");
    }
}
