package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.SellerDto;

public interface SellerService {
    SellerDto createSeller(SellerDto sellerDto);

    SellerDto getSellerByEmail(String customerEmail);

    List<SellerDto> getAllSellers();

    SellerDto updateSeller(String customerEmail, SellerDto updatedSeller);

    void deleteSeller(String customerEmail);
}
