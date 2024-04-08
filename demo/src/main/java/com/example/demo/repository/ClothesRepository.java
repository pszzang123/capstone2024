package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.Seller;
import com.example.demo.entity.SubCategory;

// JpaRepository<type of entity, type of primary key>
public interface ClothesRepository extends JpaRepository<Clothes, Long> {
    List<Clothes> findAllBySeller(Seller seller);

    List<Clothes> findAllByMajorCategory(MajorCategory majorCategory);

    List<Clothes> findAllBySubCategory(SubCategory subCategory);

    List<Clothes> findAllByNameContainingOrderByDailyViewDesc(String name);
}
