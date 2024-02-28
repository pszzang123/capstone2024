package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.Customer;

// JpaRepository<type of entity, type of primary key>
public interface ClothesRepository extends JpaRepository<Clothes, Long> {
    List<Clothes> findAllBySeller(Customer seller);
}
