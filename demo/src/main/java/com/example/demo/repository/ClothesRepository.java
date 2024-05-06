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

    List<Clothes> findAllByGenderCategoryOrderByDailyViewDesc(Integer genderCategory);

    List<Clothes> findAllByMajorCategoryOrderByDailyViewDesc(MajorCategory majorCategory);

    List<Clothes> findAllBySubCategoryOrderByDailyViewDesc(SubCategory subCategory);

    List<Clothes> findAllByGenderCategoryAndSubCategoryOrderByDailyViewDesc(Integer genderCategory, SubCategory subCategory);

    List<Clothes> findAllByGenderCategoryAndMajorCategoryOrderByDailyViewDesc(Integer genderCategory, MajorCategory majorCategory);

    List<Clothes> findAllByMajorCategoryAndSubCategoryOrderByDailyViewDesc(MajorCategory majorCategory, SubCategory subCategory);

    List<Clothes> findAllByGenderCategoryAndMajorCategoryAndSubCategoryOrderByDailyViewDesc(Integer genderCategory, MajorCategory majorCategory, SubCategory subCategory);

    List<Clothes> findAllByNameContainingOrderByDailyViewDesc(String name);

    List<Clothes> findAllByGenderCategoryAndNameContainingOrderByDailyViewDesc(Integer genderCategory, String name);

    List<Clothes> findAllBySubCategoryAndNameContainingOrderByDailyViewDesc(SubCategory subCategory, String name);

    List<Clothes> findAllByMajorCategoryAndNameContainingOrderByDailyViewDesc(MajorCategory majorCategory, String name);

    List<Clothes> findAllByGenderCategoryAndSubCategoryAndNameContainingOrderByDailyViewDesc(Integer genderCategory, SubCategory subCategory, String name);

    List<Clothes> findAllByGenderCategoryAndMajorCategoryAndNameContainingOrderByDailyViewDesc(Integer genderCategory, MajorCategory majorCategory, String name);

    List<Clothes> findAllByMajorCategoryAndSubCategoryAndNameContainingOrderByDailyViewDesc(MajorCategory majorCategory, SubCategory subCategory, String name);

    List<Clothes> findAllByGenderCategoryAndMajorCategoryAndSubCategoryAndNameContainingOrderByDailyViewDesc(Integer genderCategory, MajorCategory majorCategory, SubCategory subCategory, String name);
}
