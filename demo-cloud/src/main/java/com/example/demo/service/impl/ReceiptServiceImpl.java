package com.example.demo.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ReceiptDto;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Receipt;
import com.example.demo.entity.ReceiptDetail;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.repository.ReceiptDetailRepository;
import com.example.demo.repository.ReceiptRepository;
import com.example.demo.service.ReceiptService;
import com.example.demo.vo.ReceiptVo;
import com.example.mapper.ReceiptMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ReceiptServiceImpl implements ReceiptService {
    private CustomerRepository customerRepository;
    private ReceiptRepository receiptRepository;
    private ReceiptDetailRepository receiptDetailRepository;

    @Override
    public ReceiptDto createReceipt(ReceiptDto receiptDto) {
        Customer customer_info = customerRepository.findById(receiptDto.getCustomerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Customer is not exist with given id : " + receiptDto.getCustomerEmail())
        );
        Receipt receipt = ReceiptMapper.mapToReceipt(receiptDto, customer_info, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        Receipt savedReceipt = receiptRepository.save(receipt);
        return ReceiptMapper.mapToReceiptDto(savedReceipt);
    }

    @Override
    public List<ReceiptVo> getReceiptByCustomerEmail(String customerEmail) {
        List<Receipt> receipts = null;
        try{
            Customer customer = customerRepository.findById(customerEmail).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exist with given id : " + customerEmail)
            );
            receipts = receiptRepository.findAllByCustomer(customer);
        } catch (Exception e) {
            new ResourceNotFoundException("Clothes are not exists with given id : " + customerEmail);
            return null;
        }
        
        return receipts.stream().map((receipt) -> ReceiptMapper.mapToReceiptVo(receipt)).collect(Collectors.toList());
    }

    @Override
    public List<ReceiptDto> getAllReceipts() {
        List<Receipt> receipts = receiptRepository.findAll();
        return receipts.stream().map((receipt) -> ReceiptMapper.mapToReceiptDto(receipt)).collect(Collectors.toList());
    }

    @Override
    public ReceiptDto updateReceiptStatis(Long receiptId, Integer status) {
        Receipt receipt = receiptRepository.findById(receiptId).orElseThrow(
            () -> new ResourceNotFoundException("Receipt is not exist with given id : " + receiptId)
        );

        receipt.setStatus(status);

        Receipt updatedReceiptObj = receiptRepository.save(receipt);

        return ReceiptMapper.mapToReceiptDto(updatedReceiptObj);
    }

    @Override
    public void deleteReceiptById(Long receiptId) {
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
        
        receiptRepository.deleteById(receiptId);
    }
}
