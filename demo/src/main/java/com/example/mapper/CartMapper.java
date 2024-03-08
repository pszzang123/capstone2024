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

    public static Cart mapToCart(CartDto cart, Customer customer_info, Clothes clothes_info) {
        return new Cart(
            customer_info,
            clothes_info,
            cart.getQuantity()
        );
    }
}
