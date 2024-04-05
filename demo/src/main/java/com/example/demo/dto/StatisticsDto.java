package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StatisticsDto {
    private Long dailySales;
    private Long monthlySales;
    private Long totalSales;

    private Long dailyView;
    private Long monthlyView;
    private Long totalView;

    private Long dailyComment;
    private Long monthlyComment;
    private Long totalComment;

    private Long dailyLike;
    private Long monthlyLike;
    private Long totalLike;

    private String updateDate;
}
