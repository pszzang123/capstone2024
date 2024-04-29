package com.example.demo.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.LikesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Likes;
import com.example.demo.entity.LikesId;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.repository.LikesRepository;
import com.example.demo.service.LikesService;
import com.example.demo.vo.LikesVo;
import com.example.mapper.LikesMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class LikesServiceImpl implements LikesService {
    private ClothesRepository clothesRepository;
    private CustomerRepository customerRepository;
    private LikesRepository likesRepository;

    @Override
    public LikesDto createLikes(LikesDto likesDto) {
        Customer customer_info = customerRepository.findById(likesDto.getCustomerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Customer is not exist with given id : " + likesDto.getCustomerEmail())
        );
        Clothes clothes_info = clothesRepository.findById(likesDto.getClothesId()).orElseThrow(() ->
            new ResourceNotFoundException("Clothes are not exist with given id : " + likesDto.getClothesId())
        );

        Likes likes = LikesMapper.mapToLikes(customer_info, clothes_info, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        Likes savedLikes = likesRepository.save(likes);

        clothes_info.setDailyLike(clothes_info.getDailyLike() + 1);
        clothes_info.setMonthlyLike(clothes_info.getMonthlyLike() + 1);
        clothes_info.setTotalLike(clothes_info.getTotalLike() + 1);
        clothesRepository.save(clothes_info);

        return LikesMapper.mapToLikesDto(savedLikes);
    }

    @Override
    public LikesVo getLikesById(String customerEmail, Long clothesId) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        LikesId likesId = new LikesId(cusomter, clothes);

        Likes likes = likesRepository.findById(likesId).orElseThrow(() -> 
            new ResourceNotFoundException("Like is not exist with given id : " + customerEmail + ", " + clothesId)
        );
        
        return LikesMapper.mapToLikesVo(likes);
    }

    @Override
    public List<LikesVo> getLikesByCustomerEmail(String customerEmail) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        List<Likes> likes = likesRepository.findAllByCustomer(cusomter);
        return likes.stream().map((like) -> LikesMapper.mapToLikesVo(like)).collect(Collectors.toList());
    }

    @Override
    public List<LikesVo> getLikesByClothesId(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        List<Likes> likes = likesRepository.findAllByClothes(clothes);
        return likes.stream().map((like) -> LikesMapper.mapToLikesVo(like)).collect(Collectors.toList());
    }

    @Override
    public List<LikesVo> getAllLikes() {
        List<Likes> likes = likesRepository.findAll();
        return likes.stream().map((like) -> LikesMapper.mapToLikesVo(like)).collect(Collectors.toList());
    }

    @Override
    public void deleteLikesById(String customerEmail, Long clothesId) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );
        LikesId likesId = new LikesId(cusomter, clothes);

        Likes likes = likesRepository.findById(likesId).orElseThrow(() -> 
            new ResourceNotFoundException("Like is not exist with given id : " + customerEmail + ", " + clothesId)
        );

        LocalDateTime dateTime = LocalDateTime.parse(likes.getDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        LocalDateTime now = LocalDateTime.now();
        if (dateTime.getYear() == now.getYear()) {
            if (dateTime.getMonth() == now.getMonth()) {
                clothes.setMonthlyLike(clothes.getMonthlyLike() - 1);
            }
            if (dateTime.getDayOfYear() == now.getDayOfYear()) {
                clothes.setDailyLike(clothes.getDailyLike() - 1);
            }
        }
        clothes.setTotalLike(clothes.getTotalLike() - 1);
        
        likesRepository.deleteById(likesId);
    }
}
