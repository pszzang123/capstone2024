package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Likes;
import com.example.demo.entity.LikesId;

// JpaRepository<type of entity, type of primary key>
public interface LikesRepository extends JpaRepository<Likes, LikesId> {
    List<Likes> findAllByCustomer(Customer customer);

    List<Likes> findAllByClothes(Clothes clothes);
}
