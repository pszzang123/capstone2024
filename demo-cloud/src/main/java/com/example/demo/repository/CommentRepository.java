package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.Comment;
import com.example.demo.entity.CommentId;
import com.example.demo.entity.Customer;

// JpaRepository<type of entity, type of primary key>
public interface CommentRepository extends JpaRepository<Comment, CommentId> {
    List<Comment> findAllByCustomer(Customer customer);

    List<Comment> findAllByClothes(Clothes clothes);
}
