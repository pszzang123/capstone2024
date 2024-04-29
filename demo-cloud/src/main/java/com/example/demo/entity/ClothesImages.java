package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
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
@Table(name = "clothes_images")
@IdClass(ClothesImagesId.class)
public class ClothesImages {
    @Id
    @ManyToOne
    @JoinColumn(name = "clothes_id", nullable = false)
    private Clothes clothes;

    @Id
    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @Column(name = "image_order")
    private Long order;
}
