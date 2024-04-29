package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Customer;
import com.example.demo.entity.Lookbook;
import com.example.demo.entity.ReferencedLookbook;
import com.example.demo.entity.ReferencedLookbookId;

// JpaRepository<type of entity, type of primary key>
public interface ReferencedLookbookRepository extends JpaRepository<ReferencedLookbook, ReferencedLookbookId> {
    List<ReferencedLookbook> findAllByCustomer(Customer customer);

    List<ReferencedLookbook> findAllByLookbook(Lookbook lookbook);
}
