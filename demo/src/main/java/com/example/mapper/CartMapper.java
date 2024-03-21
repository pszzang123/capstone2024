package com.example.mapper;

import com.example.demo.dto.CartDto;
import com.example.demo.entity.Cart;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Customer;

public class CartMapper {
    public static CartDto mapToCartDto(Cart cart) {
        return new CartDto(
            cart.getCustomer().getEmail(),
            cart.getClothes().getClothesId(),
            cart.getQuantity()
        );
    }

    public static Cart mapToCart(CartDto cart, Customer customerInfo, Clothes clothesInfo) {
        return new Cart(
            customerInfo,
            clothesInfo,
            cart.getQuantity()
        );
    }
}
