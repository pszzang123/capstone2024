package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.CartDto;

public interface CartService {
    CartDto createCart(CartDto cartDto);

    List<CartDto> getCartByCustomerEmail(String customerEmail);

    List<CartDto> getAllCarts();

    CartDto updateCart(String customerEmail, Long clothesId, CartDto updatedCart);

    void deleteCartById(String customerEmail, Long clothesId);
}
