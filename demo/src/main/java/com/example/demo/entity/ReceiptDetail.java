package com.example.demo.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "receipt_detail")
public class ReceiptDetail {
    @Id
    @ManyToOne
    @JoinColumn(name = "email_id", referencedColumnName = "email_id")
    private Long receiptId;

    @ManyToOne
    @JoinColumn(name = "email_id", referencedColumnName = "email_id")
    private ClothesDetail clothesDetail;
    
    private OrderStatus orderStatus;
}
