package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Cart;
import com.example.demo.entity.CartId;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Customer;

// JpaRepository<type of entity, type of primary key>
public interface CartRepository extends JpaRepository<Cart, CartId> {
    List<Cart> findAllByCustomer(Customer customer);

    List<Cart> findAllByClothes(Clothes clothes);
}
