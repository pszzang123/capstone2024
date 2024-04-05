package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.SubCategory;

// JpaRepository<type of entity, type of primary key>
public interface SubCategoryRepository extends JpaRepository<SubCategory, Long> {
    List<SubCategory> findAllByMajorCategory(MajorCategory majorCategory);
}
