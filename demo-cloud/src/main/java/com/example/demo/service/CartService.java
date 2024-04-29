package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.CartDto;
import com.example.demo.vo.CartVo;

public interface CartService {
    CartDto createCart(CartDto cartDto);

    List<CartVo> getCartByCustomerEmail(String customerEmail);

    List<CartDto> getAllCarts();

    CartDto updateCart(String customerEmail, Long clothesId, CartDto updatedCart);

    void deleteCartById(String customerEmail, Long clothesId);
}
