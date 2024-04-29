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
    private Long price;
    private String companyName;
    private String imageUrl;
}
