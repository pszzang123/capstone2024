package com.example.demo.dto;

import com.example.demo.entity.Category;
import com.example.demo.entity.Clothes;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClothesCategoriesDto {
    private Clothes clothes;
    private Category category;
}
