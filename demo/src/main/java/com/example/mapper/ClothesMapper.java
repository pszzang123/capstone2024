package com.example.mapper;

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Seller;

public class ClothesMapper {
    public static ClothesDto mapToClothesDto(Clothes clothes) {
        return new ClothesDto(
            clothes.getClothesId(),
            clothes.getName(),
            clothes.getDetail(),
            clothes.getGenderCategory(),
            clothes.getLargeCategory() * 100 + clothes.getSmallCategory(),
            clothes.getPrice(),
            clothes.getSeller().getEmail()
        );
    }

    public static StatisticsDto mapToStatisticsDto(Clothes clothes) {
        return new StatisticsDto(
            clothes.getDailySales(),
            clothes.getMonthlySales(),
            clothes.getTotalSales(),
            clothes.getDailyView(),
            clothes.getMonthlyView(),
            clothes.getTotalView(),
            clothes.getDailyComment(),
            clothes.getMonthlyComment(),
            clothes.getTotalComment(),
            clothes.getDailyLike(),
            clothes.getMonthlyLike(),
            clothes.getTotalLike(),
            clothes.getUpdateDate()
        );
    }

    public static Clothes mapToClothes(ClothesDto clothesDto, StatisticsDto statisticsDto, Seller sellerInfo) {
        return new Clothes(
            clothesDto.getClothesId(),
            clothesDto.getName(),
            clothesDto.getDetail(),
            clothesDto.getGenderCategory(),
            clothesDto.getCategoryNumber() / 100,
            clothesDto.getCategoryNumber(),
            clothesDto.getPrice(),
            sellerInfo,
            statisticsDto.getDailySales(),
            statisticsDto.getMonthlySales(),
            statisticsDto.getTotalSales(),
            statisticsDto.getDailyView(),
            statisticsDto.getMonthlyView(),
            statisticsDto.getTotalView(),
            statisticsDto.getDailyComment(),
            statisticsDto.getMonthlyComment(),
            statisticsDto.getTotalComment(),
            statisticsDto.getDailyLike(),
            statisticsDto.getMonthlyLike(),
            statisticsDto.getTotalLike(),
            statisticsDto.getUpdateDate()
        );
    }
}
