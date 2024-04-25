package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;

// JpaRepository<type of entity, type of primary key>
public interface ReceiptDetailRepository extends JpaRepository<ReceiptDetail, Long> {
    List<ReceiptDetail> findAllByReceipt(Receipt receipt);

    List<ReceiptDetail> findAllByCustomer(Customer customer);

    List<ReceiptDetail> findAllByClothesDetail(ClothesDetail clothesDetail);
}
