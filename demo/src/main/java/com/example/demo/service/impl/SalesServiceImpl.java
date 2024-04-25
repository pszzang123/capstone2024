package com.example.demo.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.repository.ReceiptDetailRepository;
import com.example.demo.service.SalesService;
import com.example.demo.vo.SalesVo;
import com.example.mapper.ReceiptDetailMapper;
import com.example.mapper.ReceiptMapper;
import com.example.mapper.SalesMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class SalesServiceImpl implements SalesService {
    private ClothesDetailRepository clothesDetailRepository;
    private ClothesRepository clothesRepository;
    private CustomerRepository customerRepository;
    private ReceiptDetailRepository receiptDetailRepository;

    @Override
    public List<SalesVo> getSalesByCustomerEmail(String customerEmail) {
        Customer customerInfo = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        List<ReceiptDetail> receiptDetails = receiptDetailRepository.findAllByCustomer(customerInfo);

        List<SalesVo> sales = new ArrayList<>();
        receiptDetails.forEach((receiptDetail) -> {
            Receipt receiptInfo = receiptDetail.getReceipt();
            SalesVo sale = SalesMapper.mapToSalesVo(ReceiptMapper.mapToReceiptVo(receiptInfo), ReceiptDetailMapper.mapToReceiptDetailVo(receiptDetail, customerEmail));
            sales.add(sale);
        });
        
        return sales;
    }

    @Override
    public List<SalesVo> getSalesByClothesId(Long clothesId) {
        Clothes clothesInfo = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        List<ClothesDetail> clothesDetails = clothesDetailRepository.findAllByClothes(clothesInfo);

        List<SalesVo> sales = new ArrayList<>();
        clothesDetails.forEach((clothesDetail) -> {
            List<ReceiptDetail> receiptDetails = receiptDetailRepository.findAllByClothesDetail(clothesDetail);
            receiptDetails.forEach((receiptDetail) -> {
                Receipt receiptInfo = receiptDetail.getReceipt();
                SalesVo sale = SalesMapper.mapToSalesVo(ReceiptMapper.mapToReceiptVo(receiptInfo), ReceiptDetailMapper.mapToReceiptDetailVo(receiptDetail, receiptDetail.getCustomer().getEmail()));
                sales.add(sale);
            });
        });
        
        return sales;
    }
}
