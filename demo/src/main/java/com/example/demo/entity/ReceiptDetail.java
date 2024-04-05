package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "receipt_detail")
@IdClass(ReceiptDetailId.class)
public class ReceiptDetail {
    @Id
    @ManyToOne
    @JoinColumn(name = "receipt_id")
    private Receipt receipt;

    @Id
    @ManyToOne
    @JoinColumn(name = "detail_id")
    private ClothesDetail clothesDetail;

    @Column(name = "quantity")
    private Long quantity;
}
