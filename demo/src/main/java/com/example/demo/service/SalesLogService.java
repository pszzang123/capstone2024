package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.SalesLogDto;

public interface SalesLogService {
    SalesLogDto createSalesLog(SalesLogDto salesLogDto);

    List<SalesLogDto> getSalesLogByClothesId(Long clothesId);

    List<SalesLogDto> getSalesLogByCustomerEmail(String customerEmail);

    List<SalesLogDto> getAllSalesLog();

    void deleteSalesLogByClothesId(Long clothesId);

    void deleteSalesLogByCustomerEmail(String customerEmail);
}
