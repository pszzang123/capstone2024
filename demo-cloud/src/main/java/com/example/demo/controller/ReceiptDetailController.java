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

import com.example.demo.dto.ReceiptDetailDto;
import com.example.demo.service.ReceiptDetailService;
import com.example.demo.vo.ReceiptDetailVo;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/receipt_detail")
public class ReceiptDetailController {
    private ReceiptDetailService receiptDetailService;

    @PostMapping
    public ResponseEntity<ReceiptDetailDto> createReceiptDetail(@RequestBody ReceiptDetailDto receiptDetailDto) {
        ReceiptDetailDto savedReceiptDetail = receiptDetailService.createReceiptDetail(receiptDetailDto);
        return new ResponseEntity<>(savedReceiptDetail, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<List<ReceiptDetailVo>> getReceiptDetailByReceiptId(@PathVariable("id") Long receiptId) {
        List<ReceiptDetailVo> receiptDetailVos = receiptDetailService.getReceiptDetailByReceiptId(receiptId);
        return ResponseEntity.ok(receiptDetailVos);
    }

    @GetMapping
    public ResponseEntity<List<ReceiptDetailDto>> getAllReceiptDetail() {
        List<ReceiptDetailDto> receiptDetails = receiptDetailService.getAllReceiptDetail();
        return ResponseEntity.ok(receiptDetails);
    }

    @PutMapping("{id}/{status}")
    public ResponseEntity<ReceiptDetailDto> updateReceiptDetailStatus(@PathVariable("id") Long detailId, @PathVariable("status") Integer status) {
        ReceiptDetailDto receiptDetailDto = receiptDetailService.updateReceiptDetailStatus(detailId, status);
        return ResponseEntity.ok(receiptDetailDto);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteReceipt(@PathVariable("id") Long receiptId) {
        receiptDetailService.deleteReceiptDetailByReceiptId(receiptId);
        return ResponseEntity.ok("Receipt deleted successfully.");
    }
}
