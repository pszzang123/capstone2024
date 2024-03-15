package com.example.demo.entity;

import java.sql.Date;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
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
@Table(name = "statistics")
public class Statistics {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long clothesId;

    @OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "clothes_id", referencedColumnName = "clothes_id")
    private Clothes clothes;

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
    private Date updateDate;
}
