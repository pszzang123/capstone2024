package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Customer;
import com.example.demo.entity.Receipt;

// JpaRepository<type of entity, type of primary key>
public interface ReceiptRepository extends JpaRepository<Receipt, Long> {
    List<Receipt> findAllByCustomer(Customer customer);
}
