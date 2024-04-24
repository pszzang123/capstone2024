package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.ClothesImagesId;

// JpaRepository<type of entity, type of primary key>
public interface ClothesImagesRepository extends JpaRepository<ClothesImages, ClothesImagesId> {
    List<ClothesImages> findAllByClothes(Clothes clothes);

    List<ClothesImages> findAllByClothesOrderByOrder(Clothes clothes);

    ClothesImages findByClothesAndOrder(Clothes clothes, Long order);
}
