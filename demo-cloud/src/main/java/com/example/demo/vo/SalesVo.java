package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SalesVo {
    private Long receiptId;
    private String customerEmail;
    private String name;
    private String color;
    private String size;
    private Long price;
    private Long quantity;
    private String date;
}
