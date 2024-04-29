package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.LookbookDto;
import com.example.demo.dto.ReferencedLookbookDto;

public interface ReferencedLookbookService {
    ReferencedLookbookDto createReferencedLookbook(ReferencedLookbookDto referencedLookbookDto);

    List<LookbookDto> getReferencedLookbookByCustomerEmail(String customerEmail);

    List<ReferencedLookbookDto> getAllReferencedLookbook();

    void deleteReferencedLookbookById(String customerEmail, Long lookbookId);
}
