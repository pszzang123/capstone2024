package com.example.mapper;

import com.example.demo.dto.SellerDto;
import com.example.demo.entity.Seller;

public class SellerMapper {
    public static SellerDto mapToSellerDto(Seller seller) {
        return new SellerDto(
            seller.getSeller(),
            seller.getSellerEmail(),
            seller.getName()
        );
    }

    public static Seller mapToSeller(SellerDto sellerDto) {
        return new Seller(
            sellerDto.getSeller(),
            sellerDto.getSellerEmail(),
            sellerDto.getName()
        );
    }
}
