package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.LookbookDetailDto;
import com.example.demo.dto.LookbookDto;

public interface LookbookDetailService {
    LookbookDetailDto createLookbookDetail(LookbookDetailDto lookbookDetailDto);

    List<LookbookDetailDto> getLookbookDetailByLookbookId(Long lookbookId);

    List<LookbookDto> getLookbooksByDetailId(Long detailId);

    List<LookbookDetailDto> getAllLookbookDetail();

    void deleteLookbookDetailById(Long lookbookDetailId);

    void deleteLookbookDetailByLookbookId(Long lookbookId);
}
