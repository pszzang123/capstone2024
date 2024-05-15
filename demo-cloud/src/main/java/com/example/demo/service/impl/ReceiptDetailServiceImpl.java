package com.example.demo.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ReceiptDetailDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.ClothesImagesRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.repository.CustomerRepository;
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
    private ClothesRepository clothesRepository;
    private CustomerRepository customerRepository;
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

        Clothes clothes_info = clothesDetail_info.getClothes();
        clothes_info.setDailySales(clothes_info.getDailySales() + 1);
        clothes_info.setMonthlySales(clothes_info.getMonthlySales() + 1);
        clothes_info.setTotalSales(clothes_info.getTotalSales() + 1);
        clothesRepository.save(clothes_info);

        ReceiptDetail receiptDetail = ReceiptDetailMapper.mapToReceiptDetail(receiptDetailDto, receipt_info, clothesDetail_info);
        ReceiptDetail savedReceiptDetail = receiptDetailRepository.save(receiptDetail);
        return ReceiptDetailMapper.mapToReceiptDetailDto(savedReceiptDetail);
    }

    @Override
    public List<ReceiptDetailVo> getReceiptDetailByCustomerEmail(String customerEmail) {
        Customer customerInfo = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        List<ReceiptDetail> receiptDetails = receiptDetailRepository.findAllByCustomer(customerInfo);

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
    public List<ReceiptDetailVo> getReceiptDetailByClothesId(Long clothesId) {
        Clothes clothesInfo = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        String imageUrl = "";
        List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothesInfo);
        for (ClothesImages clothesImage : clothesImages) {
            if (clothesImage.getOrder() == 1) {
                imageUrl = clothesImage.getImageUrl();
                break;
            } else {
                continue;
            }
        }

        List<ClothesDetail> clothesDetails = clothesDetailRepository.findAllByClothes(clothesInfo);

        List<ReceiptDetailVo> receiptVos = new ArrayList<>();
        for (ClothesDetail clothesDetail : clothesDetails) {
            List<ReceiptDetail> receiptDetails = receiptDetailRepository.findAllByClothesDetail(clothesDetail);
            for(ReceiptDetail receiptDetail : receiptDetails) {
                ReceiptDetailVo receiptDetailVo = ReceiptDetailMapper.mapToReceiptDetailVo(receiptDetail, imageUrl);
                receiptVos.add(receiptDetailVo);
            }
        };

        return receiptVos;
    }

    @Override
    public List<ReceiptDetailDto> getAllReceiptDetail() {
        List<ReceiptDetail> receiptDetails = receiptDetailRepository.findAll();
        return receiptDetails.stream().map((receiptDetail) -> ReceiptDetailMapper.mapToReceiptDetailDto(receiptDetail)).collect(Collectors.toList());
    }

    @Override
    public ReceiptDetailDto updateReceiptDetailStatus(Long detailId, Integer status) {
        ReceiptDetail receiptDetail = receiptDetailRepository.findById(detailId).orElseThrow(
            () -> new ResourceNotFoundException("Receipt Detail is not exist with given id : " + detailId)
        );

        receiptDetail.setStatus(status);

        Receipt receipt = receiptDetail.getReceipt();
        List<ReceiptDetail> receiptDetails = receiptDetailRepository.findAllByReceipt(receipt);
        Boolean isStatusSame = false;
        Boolean isReturnExist = false;
        for (ReceiptDetail rd : receiptDetails) {
            if (status == rd.getStatus()) {
                isStatusSame = true;
                continue;
            } else {
                isStatusSame = false;
                if (rd.getStatus() == 4 || rd.getStatus() == 5) {
                    isReturnExist = true;
                    status = 4;
                }
                if (rd.getStatus() == 6) {
                    isReturnExist = true;
                    status = 6;
                }
                break;
            }
        }

        if (isStatusSame && !isReturnExist) {
            if (status == 6) {
                status = 7;
            }
        }

        if (isStatusSame || isReturnExist) {
            receipt.setStatus(status);
            receiptRepository.save(receipt);
        }

        ReceiptDetail updatedReceiptDetailObj = receiptDetailRepository.save(receiptDetail);

        return ReceiptDetailMapper.mapToReceiptDetailDto(updatedReceiptDetailObj);
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
        
        receiptDetails.forEach((receiptDetail) -> {
            Clothes clothes_info = receiptDetail.getClothesDetail().getClothes();
            Receipt receipt_info = receiptDetail.getReceipt();
            LocalDateTime dateTime = LocalDateTime.parse(receipt_info.getDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            LocalDateTime now = LocalDateTime.now();
            if (dateTime.getYear() == now.getYear()) {
                if (dateTime.getMonth() == now.getMonth()) {
                    clothes_info.setMonthlySales(clothes_info.getMonthlySales() - 1);
                }
                if (dateTime.getDayOfYear() == now.getDayOfYear()) {
                    clothes_info.setDailySales(clothes_info.getDailySales() - 1);
                }
            }
            clothes_info.setTotalSales(clothes_info.getTotalSales() - 1);

            receiptDetailRepository.delete(receiptDetail);
        });
    }
}
