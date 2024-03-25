package com.example.mapper;

import com.example.demo.dto.CartDto;
import com.example.demo.entity.Cart;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Customer;
import com.example.demo.vo.CartVo;

public class CartMapper {
    public static CartDto mapToCartDto(Cart cart) {
        return new CartDto(
            cart.getCustomer().getEmail(),
            cart.getClothesDetail().getDetailId(),
            cart.getQuantity()
        );
    }

    public static CartVo mapToCartVo(Cart cart, String imageUrl) {
        ClothesDetail clothesInfo = cart.getClothesDetail();
        return new CartVo(
            cart.getCustomer().getEmail(),
            clothesInfo.getDetailId(),
            clothesInfo.getClothes().getName(),
            clothesInfo.getColor(),
            clothesInfo.getSize(),
            clothesInfo.getPrice(),
            imageUrl,
            cart.getQuantity()
        );
    }

    public static Cart mapToCart(CartDto cart, Customer customerInfo, ClothesDetail clothesInfo) {
        return new Cart(
            customerInfo,
            clothesInfo,
            cart.getQuantity()
        );
    }
}
