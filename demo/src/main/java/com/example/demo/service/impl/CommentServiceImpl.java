package com.example.demo.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.CommentDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Comment;
import com.example.demo.entity.CommentId;
import com.example.demo.entity.Customer;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.service.CommentService;
import com.example.demo.vo.CommentVo;
import com.example.mapper.CommentMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CommentServiceImpl implements CommentService {
    private ClothesRepository clothesRepository;
    private CustomerRepository customerRepository;
    private CommentRepository commentRepository;

    @Override
    public CommentDto createComment(CommentDto commentDto) {
        Customer customer_info = customerRepository.findById(commentDto.getCustomerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Customer is not exist with given id : " + commentDto.getCustomerEmail())
        );
        Clothes clothes_info = clothesRepository.findById(commentDto.getClothesId()).orElseThrow(() ->
            new ResourceNotFoundException("Clothes are not exist with given id : " + commentDto.getClothesId())
        );

        Comment comment = CommentMapper.mapToComment(commentDto, customer_info, clothes_info, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        Comment savedComment = commentRepository.save(comment);

        clothes_info.setDailyComment(clothes_info.getDailyComment() + 1);
        clothes_info.setMonthlyComment(clothes_info.getMonthlyComment() + 1);
        clothes_info.setTotalComment(clothes_info.getTotalComment() + 1);
        clothesRepository.save(clothes_info);

        return CommentMapper.mapToCommentDto(savedComment);
    }

    @Override
    public CommentVo getCommentById(String customerEmail, Long clothesId) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        CommentId commentId = new CommentId(cusomter, clothes);

        Comment comment = commentRepository.findById(commentId).orElseThrow(() -> 
            new ResourceNotFoundException("Comment is not exist with given id : " + customerEmail + ", " + clothesId)
        );
        
        return CommentMapper.mapToCommentVo(comment);
    }

    @Override
    public List<CommentVo> getCommentByCustomerEmail(String customerEmail) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        List<Comment> comments = commentRepository.findAllByCustomer(cusomter);
        return comments.stream().map((comment) -> CommentMapper.mapToCommentVo(comment)).collect(Collectors.toList());
    }

    @Override
    public List<CommentVo> getCommentByClothesId(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        List<Comment> comments = commentRepository.findAllByClothes(clothes);
        return comments.stream().map((comment) -> CommentMapper.mapToCommentVo(comment)).collect(Collectors.toList());
    }

    @Override
    public List<CommentVo> getAllComments() {
        List<Comment> comments = commentRepository.findAll();
        return comments.stream().map((comment) -> CommentMapper.mapToCommentVo(comment)).collect(Collectors.toList());
    }

    @Override
    public CommentVo updateComment(String customerEmail, Long clothesId, String comment) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );
        CommentId commentId = new CommentId(cusomter, clothes);

        Comment commentObj = commentRepository.findById(commentId).orElseThrow(() -> 
            new ResourceNotFoundException("Comment is not exist with given id : " + customerEmail + ", " + clothesId)
        );

        commentObj.setComment(comment);
        commentObj.setDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

        Comment updatedCommentObj = commentRepository.save(commentObj);

        return CommentMapper.mapToCommentVo(updatedCommentObj);
    }

    @Override
    public void deleteCommentById(String customerEmail, Long clothesId) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );
        CommentId commentId = new CommentId(cusomter, clothes);

        Comment comment = commentRepository.findById(commentId).orElseThrow(() -> 
            new ResourceNotFoundException("Comment is not exist with given id : " + customerEmail + ", " + clothesId)
        );

        LocalDateTime dateTime = LocalDateTime.parse(comment.getDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        LocalDateTime now = LocalDateTime.now();
        if (dateTime.getYear() == now.getYear()) {
            if (dateTime.getMonth() == now.getMonth()) {
                clothes.setMonthlyComment(clothes.getMonthlyComment() - 1);
            }
            if (dateTime.getDayOfYear() == now.getDayOfYear()) {
                clothes.setDailyComment(clothes.getDailyComment() - 1);
            }
        }
        clothes.setTotalComment(clothes.getTotalComment() - 1);
        
        commentRepository.deleteById(commentId);
    }
}
