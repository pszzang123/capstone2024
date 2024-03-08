package com.example.demo.dto;

import com.example.demo.entity.Customer;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SellerDto {
    private Customer seller;
    private String sellerEmail;
    private String name;
}
