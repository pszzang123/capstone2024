package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.ReceiptDetailDto;
import com.example.demo.vo.ReceiptDetailVo;

public interface ReceiptDetailService {
    ReceiptDetailDto createReceiptDetail(ReceiptDetailDto receiptDetailDto);

    List<ReceiptDetailVo> getReceiptDetailByCustomerEmail(String customerEmail);

    List<ReceiptDetailVo> getReceiptDetailByReceiptId(Long receiptId);

    List<ReceiptDetailDto> getAllReceiptDetail();

    void deleteReceiptDetailByReceiptId(Long receiptId);
}
