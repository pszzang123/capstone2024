package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClothesDto {
    private Long clothesId;
    private String name;
    private Long value;
    private String size;
    private String color;
    private String detail;
    private Long remaining;
    private String sellerEmail;
}
