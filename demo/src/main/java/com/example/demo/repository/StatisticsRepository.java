package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Statistics;

// JpaRepository<type of entity, type of primary key>
public interface StatisticsRepository extends JpaRepository<Statistics, Long> {
    
}
