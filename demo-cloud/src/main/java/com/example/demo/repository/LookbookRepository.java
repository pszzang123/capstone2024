package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Customer;
import com.example.demo.entity.Lookbook;

// JpaRepository<type of entity, type of primary key>
public interface LookbookRepository extends JpaRepository<Lookbook, Long> {
    List<Lookbook> findAllByCustomer(Customer customer);
}
