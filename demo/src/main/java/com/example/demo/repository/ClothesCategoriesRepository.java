package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Category;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesCategories;
import com.example.demo.entity.ClothesCategoriesId;

// JpaRepository<type of entity, type of primary key>
public interface ClothesCategoriesRepository extends JpaRepository<ClothesCategories, ClothesCategoriesId> {
    List<ClothesCategories> findAllByCategory(Category category);

    List<ClothesCategories> findAllByClothes(Clothes clothes);
}
