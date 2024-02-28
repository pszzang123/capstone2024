package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Category;

// JpaRepository<type of entity, type of primary key>
public interface CategoryRepository extends JpaRepository<Category, Long> {
    
}
