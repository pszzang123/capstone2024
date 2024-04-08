package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClothesVo {
    private Long clothesId;
    private String name;
    private String detail;
    private Integer genderCategory;
    private Long majorCategoryId;
    private Long subCategoryId;
    private Long price;
    private String sellerEmail;
    private String sellerName;
    private String imageUrl;
}
