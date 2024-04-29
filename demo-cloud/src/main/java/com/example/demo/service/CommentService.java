package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.CommentDto;
import com.example.demo.vo.CommentVo;

public interface CommentService {
    CommentDto createComment(CommentDto commentDto);

    List<CommentVo> getCommentByCustomerEmail(String customerEmail);

    List<CommentVo> getCommentByClothesId(Long clothesId);

    CommentVo getCommentById(String customerEmail, Long clothesId);

    List<CommentVo> getAllComments();

    CommentVo updateComment(String customerEmail, Long clothesId, String comment);

    void deleteCommentById(String customerEmail, Long clothesId);
}
