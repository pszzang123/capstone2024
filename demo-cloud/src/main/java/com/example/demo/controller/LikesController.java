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

import com.example.demo.dto.LikesDto;
import com.example.demo.service.LikesService;
import com.example.demo.vo.LikesVo;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/like")
public class LikesController {
    private LikesService likesService;

    @PostMapping
    public ResponseEntity<LikesDto> createLikes(@RequestBody LikesDto likesDto) {
        LikesDto savedLikes = likesService.createLikes(likesDto);
        return new ResponseEntity<>(savedLikes, HttpStatus.CREATED);
    }

    @GetMapping("{email}/{id}")
    public ResponseEntity<LikesVo> getLikesById(@PathVariable("email") String customerEmail, @PathVariable("id") Long clothesId) {
        LikesVo likesVo = likesService.getLikesById(customerEmail, clothesId);
        return ResponseEntity.ok(likesVo);
    }

    @GetMapping("customer/{email}")
    public ResponseEntity<List<LikesVo>> getLikesByCustomer(@PathVariable("email") String customerEmail) {
        List<LikesVo> likes = likesService.getLikesByCustomerEmail(customerEmail);
        return ResponseEntity.ok(likes);
    }

    @GetMapping("clothes/{id}")
    public ResponseEntity<List<LikesVo>> getLikesByClothes(@PathVariable("id") Long clothesId) {
        List<LikesVo> likes = likesService.getLikesByClothesId(clothesId);
        return ResponseEntity.ok(likes);
    }

    @GetMapping
    public ResponseEntity<List<LikesVo>> getAllLikes() {
        List<LikesVo> likes = likesService.getAllLikes();
        return ResponseEntity.ok(likes);
    }

    @DeleteMapping("{email}/{id}")
    public ResponseEntity<String> deleteClothes(@PathVariable("email") String customerEmail, @PathVariable("id") Long clothesId) {
        likesService.deleteLikesById(customerEmail, clothesId);
        return ResponseEntity.ok("Like deleted successfully.");
    }
}
