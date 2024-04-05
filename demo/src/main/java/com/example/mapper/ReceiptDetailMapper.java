package com.example.mapper;

import com.example.demo.dto.ReceiptDetailDto;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;
import com.example.demo.vo.ReceiptDetailVo;

public class ReceiptDetailMapper {
    public static ReceiptDetailDto mapToReceiptDetailDto(ReceiptDetail receiptDetail) {
        return new ReceiptDetailDto(
            receiptDetail.getReceipt().getReceiptId(),
            receiptDetail.getClothesDetail().getDetailId(),
            receiptDetail.getQuantity()
        );
    }

    public static ReceiptDetailVo mapToReceiptDetailVo(ReceiptDetail receiptDetail, String imageUrl) {
        ClothesDetail clothesInfo = receiptDetail.getClothesDetail();
        return new ReceiptDetailVo(
            receiptDetail.getReceipt().getCustomer().getEmail(),
            clothesInfo.getDetailId(),
            clothesInfo.getClothes().getName(),
            clothesInfo.getColor(),
            clothesInfo.getSize(),
            clothesInfo.getClothes().getPrice(),
            imageUrl,
            receiptDetail.getQuantity()
        );
    }

    public static ReceiptDetail mapToReceiptDetail(ReceiptDetailDto receiptDetailDto, Receipt receipt, ClothesDetail clothesDetail) {
        return new ReceiptDetail(
            receipt,
            clothesDetail,
            receiptDetailDto.getQuantity()
        );
    }
}
