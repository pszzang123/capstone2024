package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Customer;

// JpaRepository<type of entity, type of primary key>
public interface CustomerRepository extends JpaRepository<Customer, String> {
    
}
