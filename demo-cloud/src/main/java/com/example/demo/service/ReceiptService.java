package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ReceiptDto;
import com.example.demo.vo.ReceiptVo;

public interface ReceiptService {
    ReceiptDto createReceipt(ReceiptDto receiptDto);

    List<ReceiptVo> getReceiptByCustomerEmail(String customerEmail);

    List<ReceiptDto> getAllReceipts();

    ReceiptDto updateReceiptStatis(Long receiptId, Integer status);

    void deleteReceiptById(Long receiptId);
}
