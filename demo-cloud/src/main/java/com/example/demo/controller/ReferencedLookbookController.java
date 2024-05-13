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

import com.example.demo.dto.LookbookDto;
import com.example.demo.dto.ReferencedLookbookDto;
import com.example.demo.service.ReferencedLookbookService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/referenced_lookbook")
public class ReferencedLookbookController {
    private ReferencedLookbookService referencedLookbookService;

    @PostMapping
    public ResponseEntity<ReferencedLookbookDto> createReferencedLookbook(@RequestBody ReferencedLookbookDto referencedLookbookDto) {
        ReferencedLookbookDto savedReferencedLookbook = referencedLookbookService.createReferencedLookbook(referencedLookbookDto);
        return new ResponseEntity<>(savedReferencedLookbook, HttpStatus.CREATED);
    }

    @GetMapping("{email}")
    public ResponseEntity<List<LookbookDto>> getReferencedLookbookByCustomerEmail(@PathVariable("email") String customerEmail) {
        List<LookbookDto> referencedLookbookDto = referencedLookbookService.getReferencedLookbookByCustomerEmail(customerEmail);
        return ResponseEntity.ok(referencedLookbookDto);
    }

    @GetMapping
    public ResponseEntity<List<ReferencedLookbookDto>> getAllReferencedLookbook() {
        List<ReferencedLookbookDto> referencedLookbookDtos = referencedLookbookService.getAllReferencedLookbook();
        return ResponseEntity.ok(referencedLookbookDtos);
    }

    @DeleteMapping("{email}/{id}")
    public ResponseEntity<String> deleteReferencedLookbookById(@PathVariable("email") String customerEmail, @PathVariable("id") Long lookbookId) {
        referencedLookbookService.deleteReferencedLookbookById(customerEmail, lookbookId);
        return ResponseEntity.ok("Referenced Lookbook deleted successfully.");
    }
}
