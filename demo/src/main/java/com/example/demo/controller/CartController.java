package com.example.demo.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.CartDto;
import com.example.demo.service.CartService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/cart")
public class CartController {
    private CartService cartService;

    @PostMapping
    public ResponseEntity<CartDto> createCart(@RequestBody CartDto cartDto) {
        CartDto savedCart = cartService.createCart(cartDto);
        return new ResponseEntity<>(savedCart, HttpStatus.CREATED);
    }

    @GetMapping("{email}")
    public ResponseEntity<List<CartDto>> getCartByCustomerEmail(@PathVariable("email") String customerEmail) {
        List<CartDto> cartDto = cartService.getCartByCustomerEmail(customerEmail);
        return ResponseEntity.ok(cartDto);
    }

    @GetMapping
    public ResponseEntity<List<CartDto>> getAllCart() {
        List<CartDto> cart = cartService.getAllCarts();
        return ResponseEntity.ok(cart);
    }

    @PutMapping("{email}/{id}")
    public ResponseEntity<CartDto> updateCart(@PathVariable("email") String customerEmail, @PathVariable("id") Long clothesId, @RequestBody CartDto updatedCart) {
        CartDto cartDto = cartService.updateCart(customerEmail, clothesId, updatedCart);
        return ResponseEntity.ok(cartDto);
    }

    @DeleteMapping("{email}/{id}")
    public ResponseEntity<String> deleteClothes(@PathVariable("email") String customerEmail, @PathVariable("id") Long clothesId) {
        cartService.deleteCartById(customerEmail, clothesId);
        return ResponseEntity.ok("Cart deleted successfully.");
    }
}
