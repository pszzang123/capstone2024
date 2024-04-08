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
    private Long majorCategoryId;
    private Long subCategoryId;
    private Long price;
    private String sellerEmail;
}
