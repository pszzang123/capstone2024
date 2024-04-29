package com.example.mapper;

import com.example.demo.dto.CommentDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Comment;
import com.example.demo.entity.Customer;
import com.example.demo.vo.CommentVo;

public class CommentMapper {
    public static CommentDto mapToCommentDto(Comment comment) {
        return new CommentDto(
            comment.getCustomer().getEmail(),
            comment.getClothes().getClothesId(),
            comment.getComment()
        );
    }

    public static CommentVo mapToCommentVo(Comment comment) {
        return new CommentVo(
            comment.getCustomer().getEmail(),
            comment.getClothes().getClothesId(),
            comment.getComment(),
            comment.getDate()
        );
    }

    public static Comment mapToComment(CommentDto comment, Customer customerInfo, Clothes clothesInfo, String date) {
        return new Comment(
            customerInfo,
            clothesInfo,
            comment.getComment(),
            date
        );
    }
}
