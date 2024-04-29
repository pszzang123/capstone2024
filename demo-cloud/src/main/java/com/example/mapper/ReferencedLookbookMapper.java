package com.example.mapper;

import com.example.demo.dto.ReferencedLookbookDto;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Lookbook;
import com.example.demo.entity.ReferencedLookbook;

public class ReferencedLookbookMapper {
    public static ReferencedLookbookDto mapToReferencedLookbookDto(ReferencedLookbook referencedLookbook) {
        return new ReferencedLookbookDto(
            referencedLookbook.getCustomer().getEmail(),
            referencedLookbook.getLookbook().getLookbookId()
        );
    }

    public static ReferencedLookbook mapToReferencedLookbook(Customer customerInfo, Lookbook lookbookInfo) {
        return new ReferencedLookbook(
            customerInfo,
            lookbookInfo
        );
    }
}
