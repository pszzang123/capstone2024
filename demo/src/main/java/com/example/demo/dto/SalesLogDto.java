package com.example.demo.dto;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SalesLogDto {
    private Long salesLogId;
    private Date salesDate;
    private Long quantity;
    private Long clothesId;
    private String customerEmail;
}
