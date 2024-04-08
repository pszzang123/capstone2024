package com.example.mapper;

import com.example.demo.dto.LikesDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Likes;
import com.example.demo.vo.LikesVo;

public class LikesMapper {
    public static LikesDto mapToLikesDto(Likes likes) {
        return new LikesDto(
            likes.getCustomer().getEmail(),
            likes.getClothes().getClothesId()
        );
    }

    public static LikesVo mapToLikesVo(Likes likes) {
        return new LikesVo(
            likes.getCustomer().getEmail(),
            likes.getClothes().getClothesId(),
            likes.getDate()
        );
    }

    public static Likes mapToLikes(Customer customerInfo, Clothes clothesInfo, String date) {
        return new Likes(
            customerInfo,
            clothesInfo,
            date
        );
    }
}
