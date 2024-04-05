package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;
import com.example.demo.entity.ReceiptDetailId;

// JpaRepository<type of entity, type of primary key>
public interface ReceiptDetailRepository extends JpaRepository<ReceiptDetail, ReceiptDetailId> {
    List<ReceiptDetail> findAllByReceipt(Receipt receipt);
}
