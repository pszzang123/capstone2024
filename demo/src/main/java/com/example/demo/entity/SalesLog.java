package com.example.demo.entity;

import java.sql.Date;

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
@Table(name = "sales_log")
public class SalesLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long salesLogId;

    @Column(name = "sales_date", nullable = false)
    private Date salesDate;

    @Column(name = "quantity")
    private Long quantity;

    @ManyToOne
    @JoinColumn(name = "clothes_id", referencedColumnName = "clothes_id")
    private Clothes clothes;

    @ManyToOne
    @JoinColumn(name = "customer_email", referencedColumnName = "email_id")
    private Customer customer;
}
