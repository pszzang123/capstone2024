package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "clothes")
public class Clothes {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "clothes_id")
    private Long clothesId;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "detail")
    private String detail;

    @Column(name = "gender_category")
    private Integer genderCategory;

    @ManyToOne
    @JoinColumn(name = "major_category_id", referencedColumnName = "major_category_id")
    private MajorCategory majorCategory;

    @ManyToOne
    @JoinColumn(name = "sub_category_id", referencedColumnName = "sub_category_id")
    private SubCategory subCategory;

    @Column(name = "price")
    private Long price;

    @ManyToOne
    @JoinColumn(name = "seller_email", referencedColumnName = "email_id")
    private Seller seller;

    // Statistics
    @Column(name = "daily_sales")
    private Long dailySales;

    @Column(name = "monthly_sales")
    private Long monthlySales;

    @Column(name = "total_sales")
    private Long totalSales;

    @Column(name = "daily_view")
    private Long dailyView;

    @Column(name = "monthly_view")
    private Long monthlyView;

    @Column(name = "total_view")
    private Long totalView;

    @Column(name = "daily_comment")
    private Long dailyComment;

    @Column(name = "monthly_comment")
    private Long monthlyComment;

    @Column(name = "total_comment")
    private Long totalComment;

    @Column(name = "daily_like")
    private Long dailyLike;

    @Column(name = "monthly_like")
    private Long monthlyLike;

    @Column(name = "total_like")
    private Long totalLike;

    @Column(name = "update_date", nullable = false)
    private String updateDate;
}
