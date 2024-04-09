package com.example.mapper;

import com.example.demo.dto.ReceiptDto;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Receipt;
import com.example.demo.vo.ReceiptVo;

public class ReceiptMapper {
    public static ReceiptDto mapToReceiptDto(Receipt receipt) {
        return new ReceiptDto(
            receipt.getReceiptId(),
            receipt.getCustomer().getEmail(),
            receipt.getStatus()
        );
    }

    public static ReceiptVo mapToReceiptVo(Receipt receipt) {
        return new ReceiptVo(
            receipt.getReceiptId(),
            receipt.getCustomer().getEmail(),
            receipt.getStatus(),
            receipt.getDate()
        );
    }

    public static Receipt mapToReceipt(ReceiptDto receiptDto, Customer customer, String date) {
        return new Receipt(
            receiptDto.getReceiptId(),
            customer,
            receiptDto.getStatus(),
            date
        );
    }
}
