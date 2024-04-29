package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Lookbook;
import com.example.demo.entity.LookbookDetail;

// JpaRepository<type of entity, type of primary key>
public interface LookbookDetailRepository extends JpaRepository<LookbookDetail, Long> {
    List<LookbookDetail> findAllByLookbook(Lookbook lookbook);

    List<LookbookDetail> findAllByClothesDetail(ClothesDetail clothesDetail);
}
