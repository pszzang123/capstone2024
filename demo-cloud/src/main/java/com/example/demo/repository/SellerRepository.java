package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Seller;

// JpaRepository<type of entity, type of primary key>
public interface SellerRepository extends JpaRepository<Seller, String> {
    
}
