package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;

// JpaRepository<type of entity, type of primary key>
public interface ClothesDetailRepository extends JpaRepository<ClothesDetail, Long> {
    List<ClothesDetail> findAllByClothes(Clothes clothes);
}
