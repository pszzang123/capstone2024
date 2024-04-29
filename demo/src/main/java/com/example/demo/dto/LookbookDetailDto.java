package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LookbookDetailDto {
    private Long lookbookDetailId;
    private Long lookbookId;
    private Long detailId;
}
