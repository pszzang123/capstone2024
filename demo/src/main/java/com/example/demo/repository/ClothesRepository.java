package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.Seller;

// JpaRepository<type of entity, type of primary key>
public interface ClothesRepository extends JpaRepository<Clothes, Long> {
    List<Clothes> findAllBySeller(Seller seller);
    
    @Query(value = "SELECT cloth FROM Clothes cloth " +
    "LEFT JOIN statistics stat ON cloth.clothes_id = stat.clothes_id " +
    "WHERE cloth.name LIKE %:name% " +
    "ORDER BY stat.daily_view", nativeQuery = true)
    List<Clothes> searchClothesByNameOrderByDailyView(@Param("name") String name);
}
