package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ReceiptDetailDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.ClothesImagesRepository;
import com.example.demo.repository.ReceiptDetailRepository;
import com.example.demo.repository.ReceiptRepository;
import com.example.demo.service.ReceiptDetailService;
import com.example.demo.vo.ReceiptDetailVo;
import com.example.mapper.ReceiptDetailMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ReceiptDetailServiceImpl implements ReceiptDetailService {
    private ClothesDetailRepository clothesDetailRepository;
    private ClothesImagesRepository clothesImagesRepository;
    private ReceiptRepository receiptRepository;
    private ReceiptDetailRepository receiptDetailRepository;

    @Override
    public ReceiptDetailDto createReceiptDetail(ReceiptDetailDto receiptDetailDto) {
        Receipt receipt_info = receiptRepository.findById(receiptDetailDto.getReceiptId()).orElseThrow(() ->
            new ResourceNotFoundException("Receipt is not exist with given id : " + receiptDetailDto.getReceiptId())
        );
        ClothesDetail clothesDetail_info = clothesDetailRepository.findById(receiptDetailDto.getDetailId()).orElseThrow(() ->
            new ResourceNotFoundException("Clothes Detail is not exist with given id : " + receiptDetailDto.getDetailId())
        );

        ReceiptDetail receiptDetail = ReceiptDetailMapper.mapToReceiptDetail(receiptDetailDto, receipt_info, clothesDetail_info);
        ReceiptDetail savedReceiptDetail = receiptDetailRepository.save(receiptDetail);
        return ReceiptDetailMapper.mapToReceiptDetailDto(savedReceiptDetail);
    }

    @Override
    public List<ReceiptDetailVo> getReceiptDetailByReceiptId(Long receiptId) {
        List<ReceiptDetail> receiptDetails = null;
        try{
            Receipt receiptInfo = receiptRepository.findById(receiptId).orElseThrow(() -> 
                new ResourceNotFoundException("Receipt is not exist with given id : " + receiptId)
            );
            receiptDetails = receiptDetailRepository.findAllByReceipt(receiptInfo);
        } catch (Exception e) {
            new ResourceNotFoundException("Receipt is not exists with given id : " + receiptId);
            return null;
        }

        List<ReceiptDetailVo> receiptDetailVos = receiptDetails.stream().map((receiptDetail) -> {
            String imageUrl = "";
            Clothes clothesInfo = receiptDetail.getClothesDetail().getClothes();
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothesInfo);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ReceiptDetailMapper.mapToReceiptDetailVo(receiptDetail, imageUrl);
        }).collect(Collectors.toList());
        
        return receiptDetailVos;
    }

    @Override
    public List<ReceiptDetailDto> getAllReceiptDetail() {
        List<ReceiptDetail> receiptDetails = receiptDetailRepository.findAll();
        return receiptDetails.stream().map((receiptDetail) -> ReceiptDetailMapper.mapToReceiptDetailDto(receiptDetail)).collect(Collectors.toList());
    }

    @Override
    public void deleteReceiptDetailByReceiptId(Long receiptId) {
        List<ReceiptDetail> receiptDetails = null;
        try{
            Receipt receiptInfo = receiptRepository.findById(receiptId).orElseThrow(() -> 
                new ResourceNotFoundException("Receipt is not exist with given id : " + receiptId)
            );
            receiptDetails = receiptDetailRepository.findAllByReceipt(receiptInfo);
        } catch (Exception e) {
            new ResourceNotFoundException("Receipt is not exists with given id : " + receiptId);
            return;
        }
        
        receiptDetails.forEach((receiptDetail) -> receiptDetailRepository.delete(receiptDetail));
    }
}
