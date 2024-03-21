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
    private String detail;
    private Integer genderCategory;
    private Integer largeCategory;
    private Integer smallCategory;
    private String sellerEmail;
}
