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
@Table(name = "lookbook")
public class Lookbook {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "lookbook_id")
    private Long lookbookId;

    @ManyToOne
    @JoinColumn(name = "customer_email", referencedColumnName = "email_id")
    private Customer customer;

    @Column(name = "lookbook_name")
    private String lookbookName;
}
