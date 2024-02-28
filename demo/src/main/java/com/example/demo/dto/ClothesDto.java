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
public class ClothesDto {
    private Long clothes_id;
    private String name;
    private Long value;
    private String size;
    private String color;
    private Customer seller;
}
