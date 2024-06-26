package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CustomerDto {
    private String email;
    private String password;
    private String name;
    private String streetAddress;
    private String detailAddress;
    private Integer zipCode;
    private String phone;
}
