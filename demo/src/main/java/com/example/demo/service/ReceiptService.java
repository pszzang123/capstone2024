package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ReceiptDto;

public interface ReceiptService {
    ReceiptDto createReceipt(ReceiptDto receiptDto);

    List<ReceiptDto> getReceiptByCustomerEmail(String customerEmail);

    List<ReceiptDto> getAllReceipts();

    ReceiptDto updateReceiptStatis(Long receiptId, Integer status);

    void deleteReceiptById(Long receiptId);
}
