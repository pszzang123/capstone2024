package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.LookbookDto;

public interface LookbookService {
    LookbookDto createLookbook(LookbookDto lookbookDto);

    List<LookbookDto> getLookbookByCustomerEmail(String customerEmail);

    List<LookbookDto> getAllLookbooks();

    LookbookDto copyLookbook(Long lookbookId, String customerEmail);

    LookbookDto updateLookbook(Long lookbookId, LookbookDto lookbookDto);

    void deleteLookbookById(Long lookbookId);
}
