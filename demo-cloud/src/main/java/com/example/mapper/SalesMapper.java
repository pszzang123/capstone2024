package com.example.mapper;

import com.example.demo.vo.ReceiptDetailVo;
import com.example.demo.vo.ReceiptVo;
import com.example.demo.vo.SalesVo;

public class SalesMapper {
    public static SalesVo mapToSalesVo(ReceiptVo receiptVo, ReceiptDetailVo receiptDetailVo) {
        return new SalesVo(
            receiptVo.getReceiptId(),
            receiptVo.getCustomerEmail(),
            receiptDetailVo.getName(),
            receiptDetailVo.getColor(),
            receiptDetailVo.getSize(),
            receiptDetailVo.getPrice(),
            receiptDetailVo.getQuantity(),
            receiptVo.getDate()
        );
    }
}
