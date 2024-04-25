package com.example.demo.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.service.SalesService;
import com.example.demo.vo.SalesVo;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/sales")
public class SalesController {
    private SalesService salesService;

    @GetMapping("customer/{email}")
    public ResponseEntity<List<SalesVo>> getSalesByCustomerEmail(@PathVariable("email") String customerEmail) {
        List<SalesVo> salesVos = salesService.getSalesByCustomerEmail(customerEmail);
        return ResponseEntity.ok(salesVos);
    }

    @GetMapping("clothes/{clothesId}")
    public ResponseEntity<List<SalesVo>> getSalesByClothesId(@PathVariable("clothesId") Long clothesId) {
        List<SalesVo> salesVos = salesService.getSalesByClothesId(clothesId);
        return ResponseEntity.ok(salesVos);
    }
}
