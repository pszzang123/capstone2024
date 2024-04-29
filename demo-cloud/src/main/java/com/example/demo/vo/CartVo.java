package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CartVo {
    private String customerEmail;
    private Long detailId;
    private String name;
    private String color;
    private String size;
    private Long price;
    private String imageUrl;
    private Long quantity;
}
