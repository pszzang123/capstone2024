package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClothesDetailDto {
    private Long detailId;
    private String color;
    private String size;
    private Long remaining;
    private Long value;
    private Long clothesId;
}
