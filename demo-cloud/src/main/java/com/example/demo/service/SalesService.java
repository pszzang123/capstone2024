package com.example.demo.service;

import java.util.List;

import com.example.demo.vo.SalesVo;

public interface SalesService {
    List<SalesVo> getSalesByCustomerEmail(String customerEmail);

    List<SalesVo> getSalesByClothesId(Long clothesId);
}
