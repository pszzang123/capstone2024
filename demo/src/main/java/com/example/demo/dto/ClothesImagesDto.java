package com.example.demo.dto;

import com.example.demo.entity.Clothes;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClothesImagesDto {
    private Clothes clothes;
    private String imageUrl;
}
