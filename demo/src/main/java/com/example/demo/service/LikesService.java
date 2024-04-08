package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.LikesDto;
import com.example.demo.vo.LikesVo;

public interface LikesService {
    LikesDto createLikes(LikesDto likesDto);

    List<LikesVo> getLikesByCustomerEmail(String customerEmail);

    List<LikesVo> getLikesByClothesId(Long clothesId);

    LikesVo getLikesById(String customerEmail, Long clothesId);

    List<LikesVo> getAllLikes();

    void deleteLikesById(String customerEmail, Long clothesId);
}
