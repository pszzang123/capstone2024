package com.example.mapper;

import com.example.demo.dto.SalesLogDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Customer;
import com.example.demo.entity.SalesLog;

public class SalesLogMapper {
    public static SalesLogDto mapToSalesLogDto(SalesLog salesLog) {
        return new SalesLogDto(
            salesLog.getSalesLogId(),
            salesLog.getSalesDate(),
            salesLog.getQuantity(),
            salesLog.getClothes().getClothesId(),
            salesLog.getCustomer().getEmail()
        );
    }

    public static SalesLog mapToSalesLog(SalesLogDto salesLogDto, Clothes clothesInfo, Customer customerInfo) {
        return new SalesLog(
            salesLogDto.getSalesLogId(),
            salesLogDto.getSalesDate(),
            salesLogDto.getQuantity(),
            clothesInfo,
            customerInfo
        );
    }
}
