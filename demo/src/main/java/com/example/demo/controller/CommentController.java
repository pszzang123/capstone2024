package com.example.demo.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.CommentDto;
import com.example.demo.service.CommentService;
import com.example.demo.vo.CommentVo;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/comment")
public class CommentController {
    private CommentService commentService;

    @PostMapping
    public ResponseEntity<CommentDto> createComment(@RequestBody CommentDto commentDto) {
        CommentDto savedComment = commentService.createComment(commentDto);
        return new ResponseEntity<>(savedComment, HttpStatus.CREATED);
    }

    @GetMapping("{email}/{id}")
    public ResponseEntity<CommentVo> getCommentById(@PathVariable("email") String customerEmail, @PathVariable("id") Long clothesId) {
        CommentVo commentVo = commentService.getCommentById(customerEmail, clothesId);
        return ResponseEntity.ok(commentVo);
    }

    @GetMapping("customer/{email}")
    public ResponseEntity<List<CommentVo>> getCommentsByCustomer(@PathVariable("email") String customerEmail) {
        List<CommentVo> comments = commentService.getCommentByCustomerEmail(customerEmail);
        return ResponseEntity.ok(comments);
    }

    @GetMapping("clothes/{id}")
    public ResponseEntity<List<CommentVo>> getCommentsByClothes(@PathVariable("id") Long clothesId) {
        List<CommentVo> comments = commentService.getCommentByClothesId(clothesId);
        return ResponseEntity.ok(comments);
    }

    @GetMapping
    public ResponseEntity<List<CommentVo>> getAllClothes() {
        List<CommentVo> comments = commentService.getAllComments();
        return ResponseEntity.ok(comments);
    }

    @PutMapping
    public ResponseEntity<CommentVo> updateComment(@RequestBody CommentDto commentDto) {
        CommentVo comment = commentService.updateComment(commentDto.getCustomerEmail(), commentDto.getClothesId(), commentDto.getComment());
        return ResponseEntity.ok(comment);
    }

    @DeleteMapping("{email}/{id}")
    public ResponseEntity<String> deleteClothes(@PathVariable("email") String customerEmail, @PathVariable("id") Long clothesId) {
        commentService.deleteCommentById(customerEmail, clothesId);
        return ResponseEntity.ok("Comment deleted successfully.");
    }
}
