package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReceiptDetailDto {
    private Long receiptDetailId;
    private Long receiptId;
    private Long detailId;
    private Long quantity;
    private Integer status;
}
