package com.example.mapper;

import com.example.demo.dto.SellerDto;
import com.example.demo.entity.Seller;

public class SellerMapper {
    public static SellerDto mapToSellerDto(Seller seller) {
        return new SellerDto(
            seller.getEmail(),
            seller.getPassword(),
            seller.getName(),
            seller.getAddress(),
            seller.getPhone(),
            seller.getCompanyName()
        );
    }

    public static Seller mapToSeller(SellerDto sellerDto) {
        return new Seller(
            sellerDto.getEmail(),
            sellerDto.getPassword(),
            sellerDto.getName(),
            sellerDto.getAddress(),
            sellerDto.getPhone(),
            sellerDto.getCompanyName()
        );
    }
}
