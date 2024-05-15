package com.example.mapper;

import com.example.demo.dto.ReceiptDetailDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;
import com.example.demo.vo.ReceiptDetailVo;

public class ReceiptDetailMapper {
    public static ReceiptDetailDto mapToReceiptDetailDto(ReceiptDetail receiptDetail) {
        return new ReceiptDetailDto(
            receiptDetail.getReceiptDetailId(),
            receiptDetail.getReceipt().getReceiptId(),
            receiptDetail.getClothesDetail().getDetailId(),
            receiptDetail.getQuantity(),
            receiptDetail.getStatus()
        );
    }

    public static ReceiptDetailVo mapToReceiptDetailVo(ReceiptDetail receiptDetail, String imageUrl) {
        return new ReceiptDetailVo(
            receiptDetail.getReceiptDetailId(),
            receiptDetail.getReceipt().getCustomer().getEmail(),
            receiptDetail.getClothesDetail().getClothes().getClothesId(),
            receiptDetail.getName(),
            receiptDetail.getColor(),
            receiptDetail.getSize(),
            receiptDetail.getPrice(),
            imageUrl,
            receiptDetail.getQuantity(),
            receiptDetail.getStatus(),
            receiptDetail.getReceipt().getDate()
        );
    }

    public static ReceiptDetail mapToReceiptDetail(ReceiptDetailDto receiptDetailDto, Receipt receipt, ClothesDetail clothesDetail) {
        Clothes clothes = clothesDetail.getClothes();
        return new ReceiptDetail(
            receiptDetailDto.getReceiptDetailId(),
            receipt,
            clothesDetail,
            receipt.getCustomer(),
            clothes.getName(),
            clothesDetail.getColor(),
            clothesDetail.getSize(),
            clothes.getPrice() * receiptDetailDto.getQuantity(),
            receiptDetailDto.getQuantity(),
            receiptDetailDto.getStatus()
        );
    }
}
