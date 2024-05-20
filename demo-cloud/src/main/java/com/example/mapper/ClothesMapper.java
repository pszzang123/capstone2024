package com.example.mapper;

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.Seller;
import com.example.demo.entity.SubCategory;
import com.example.demo.vo.ClothesPageVo;
import com.example.demo.vo.ClothesVo;

public class ClothesMapper {
    public static ClothesDto mapToClothesDto(Clothes clothes) {
        return new ClothesDto(
            clothes.getClothesId(),
            clothes.getName(),
            clothes.getDetail(),
            clothes.getGenderCategory(),
            clothes.getMajorCategory().getMajorCategoryId(),
            clothes.getSubCategory().getSubCategoryId(),
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

    public static ClothesPageVo mapToClothesPageVo(Clothes clothes) {
        return new ClothesPageVo(
            clothes.getClothesId(),
            clothes.getName(),
            clothes.getDetail(),
            clothes.getGenderCategory(),
            clothes.getMajorCategory().getMajorCategoryId(),
            clothes.getSubCategory().getSubCategoryId(),
            clothes.getPrice(),
            clothes.getSeller().getEmail(),
            clothes.getSeller().getCompanyName()
        );
    }

    public static ClothesVo mapToClothesVo(Clothes clothes, String imageUrl) {
        return new ClothesVo(
            clothes.getClothesId(),
            clothes.getName(),
            clothes.getPrice(),
            clothes.getSeller().getCompanyName(),
            imageUrl
        );
    }

    public static Clothes mapToClothes(ClothesDto clothesDto, StatisticsDto statisticsDto, MajorCategory majorCategory, SubCategory subCategory, Seller sellerInfo) {
        return new Clothes(
            clothesDto.getClothesId(),
            clothesDto.getName(),
            clothesDto.getDetail(),
            clothesDto.getGenderCategory(),
            majorCategory,
            subCategory,
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
