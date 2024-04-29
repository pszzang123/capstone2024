package com.example.mapper;

import com.example.demo.dto.LookbookDto;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Lookbook;

public class LookbookMapper {
    public static LookbookDto mapToLookbookDto(Lookbook lookbook) {
        return new LookbookDto(
            lookbook.getLookbookId(),
            lookbook.getCustomer().getEmail(),
            lookbook.getLookbookName()
        );
    }

    public static Lookbook mapToLookbook(LookbookDto lookbookDto, Customer customer) {
        return new Lookbook(
            lookbookDto.getLookbookId(),
            customer,
            lookbookDto.getLookbookName()
        );
    }
}
