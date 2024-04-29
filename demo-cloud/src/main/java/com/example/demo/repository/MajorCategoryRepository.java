package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.MajorCategory;

// JpaRepository<type of entity, type of primary key>
public interface MajorCategoryRepository extends JpaRepository<MajorCategory, Long> {

}
