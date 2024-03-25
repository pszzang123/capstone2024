package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.CartDto;
import com.example.demo.entity.Cart;
import com.example.demo.entity.CartId;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.Customer;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CartRepository;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.ClothesImagesRepository;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.service.CartService;
import com.example.demo.vo.CartVo;
import com.example.mapper.CartMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CartServiceImpl implements CartService {
    private ClothesDetailRepository clothesDetailRepository;
    private ClothesImagesRepository clothesImagesRepository;
    private CustomerRepository customerRepository;
    private CartRepository cartRepository;

    @Override
    public CartDto createCart(CartDto cartDto) {
        Customer customer_info = customerRepository.findById(cartDto.getCustomerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Seller is not exist with given id : " + cartDto.getCustomerEmail())
        );
        ClothesDetail clothes_info = clothesDetailRepository.findById(cartDto.getDetailId()).orElseThrow(() ->
            new ResourceNotFoundException("Seller is not exist with given id : " + cartDto.getDetailId())
        );
        Cart cart = CartMapper.mapToCart(cartDto, customer_info, clothes_info);
        Cart savedCart = cartRepository.save(cart);
        return CartMapper.mapToCartDto(savedCart);
    }

    @Override
    public List<CartVo> getCartByCustomerEmail(String customerEmail) {
        List<Cart> carts = null;
        try{
            Customer customer = customerRepository.findById(customerEmail).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exist with given id : " + customerEmail)
            );
            carts = cartRepository.findAllByCustomer(customer);
        } catch (Exception e) {
            new ResourceNotFoundException("Clothes are not exists with given id : " + customerEmail);
            return null;
        }

        List<CartVo> cartVos = carts.stream().map((cart) -> {
            String imageUrl = "";
            Clothes clothesInfo = cart.getClothesDetail().getClothes();
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothesInfo);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return CartMapper.mapToCartVo(cart, imageUrl);
        }).collect(Collectors.toList());
        
        return cartVos;
    }

    @Override
    public List<CartDto> getAllCarts() {
        List<Cart> carts = cartRepository.findAll();
        return carts.stream().map((cart) -> CartMapper.mapToCartDto(cart)).collect(Collectors.toList());
    }

    @Override
    public CartDto updateCart(String customerEmail, Long detailId, CartDto updatedCart) {
        Customer customer_info = customerRepository.findById(customerEmail).orElseThrow(
            () -> new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        ClothesDetail clothes_info = clothesDetailRepository.findById(detailId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + detailId)
        );

        CartId cartId = new CartId(customer_info, clothes_info);
        Cart cart = cartRepository.findById(cartId).orElseThrow(
            () -> new ResourceNotFoundException("Cart is not exist with given id : " + customerEmail + ", " + detailId)
        );

        cart.setQuantity(updatedCart.getQuantity());

        Cart updatedCartObj = cartRepository.save(cart);

        return CartMapper.mapToCartDto(updatedCartObj);
    }

    @Override
    public void deleteCartById(String customerEmail, Long clothesId) {
        Customer customer_info = customerRepository.findById(customerEmail).orElseThrow(
            () -> new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        ClothesDetail clothes_info = clothesDetailRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        CartId cartId = new CartId(customer_info, clothes_info);
        cartRepository.findById(cartId).orElseThrow(
            () -> new ResourceNotFoundException("Cart is not exist with given id : " + customerEmail + ", " + clothesId)
        );
        
        cartRepository.deleteById(cartId);
    }
}
