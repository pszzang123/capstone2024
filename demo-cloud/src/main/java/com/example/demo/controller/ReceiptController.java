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

import com.example.demo.dto.ReceiptDto;
import com.example.demo.service.ReceiptService;
import com.example.demo.vo.ReceiptVo;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/receipt")
public class ReceiptController {
    private ReceiptService receiptService;

    @PostMapping
    public ResponseEntity<ReceiptDto> createReceipt(@RequestBody ReceiptDto receiptDto) {
        ReceiptDto savedReceipt = receiptService.createReceipt(receiptDto);
        return new ResponseEntity<>(savedReceipt, HttpStatus.CREATED);
    }

    @GetMapping("{email}")
    public ResponseEntity<List<ReceiptVo>> getReceiptByCustomerEmail(@PathVariable("email") String customerEmail) {
        List<ReceiptVo> receiptVos = receiptService.getReceiptByCustomerEmail(customerEmail);
        return ResponseEntity.ok(receiptVos);
    }

    @GetMapping
    public ResponseEntity<List<ReceiptDto>> getAllReceipt() {
        List<ReceiptDto> receipts = receiptService.getAllReceipts();
        return ResponseEntity.ok(receipts);
    }

    @PutMapping("{id}/{status}")
    public ResponseEntity<ReceiptDto> updateReceiptStatus(@PathVariable("id") Long receiptId, @PathVariable("status") Integer status) {
        ReceiptDto receiptDto = receiptService.updateReceiptStatus(receiptId, status);
        return ResponseEntity.ok(receiptDto);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteReceipt(@PathVariable("id") Long receiptId) {
        receiptService.deleteReceiptById(receiptId);
        return ResponseEntity.ok("Receipt deleted successfully.");
    }
}
