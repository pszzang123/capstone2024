package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.LookbookDto;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Lookbook;
import com.example.demo.entity.LookbookDetail;
import com.example.demo.entity.ReferencedLookbook;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.repository.LookbookDetailRepository;
import com.example.demo.repository.LookbookRepository;
import com.example.demo.repository.ReferencedLookbookRepository;
import com.example.demo.service.LookbookService;
import com.example.mapper.LookbookMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class LookbookServiceImpl implements LookbookService {
    private CustomerRepository customerRepository;
    private LookbookRepository lookbookRepository;
    private LookbookDetailRepository lookbookDetailRepository;
    private ReferencedLookbookRepository referencedLookbookRepository;

    @Override
    public LookbookDto createLookbook(LookbookDto lookbookDto) {
        Customer customer_info = customerRepository.findById(lookbookDto.getCustomerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Customer is not exist with given id : " + lookbookDto.getCustomerEmail())
        );
        Lookbook lookbook = LookbookMapper.mapToLookbook(lookbookDto, customer_info);
        Lookbook savedLookbook = lookbookRepository.save(lookbook);
        return LookbookMapper.mapToLookbookDto(savedLookbook);
    }

    @Override
    public List<LookbookDto> getLookbookByCustomerEmail(String customerEmail) {
        List<Lookbook> lookbooks = null;
        try{
            Customer customer = customerRepository.findById(customerEmail).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exist with given id : " + customerEmail)
            );
            lookbooks = lookbookRepository.findAllByCustomer(customer);
        } catch (Exception e) {
            new ResourceNotFoundException("Clothes are not exists with given id : " + customerEmail);
            return null;
        }
        
        return lookbooks.stream().map((lookbook) -> LookbookMapper.mapToLookbookDto(lookbook)).collect(Collectors.toList());
    }

    @Override
    public List<LookbookDto> getAllLookbooks() {
        List<Lookbook> lookbooks = lookbookRepository.findAll();
        return lookbooks.stream().map((lookbook) -> LookbookMapper.mapToLookbookDto(lookbook)).collect(Collectors.toList());
    }

    public LookbookDto copyLookbook(Long lookbookId, String customerEmail) {
        Customer customer_info = customerRepository.findById(customerEmail).orElseThrow(() ->
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        Lookbook lookbookInfo = lookbookRepository.findById(lookbookId).orElseThrow(
            () -> new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId)
        );

        LookbookDto lookbookDto = new LookbookDto();
        lookbookDto.setCustomerEmail(customerEmail);
        lookbookDto.setLookbookName(lookbookInfo.getLookbookName());

        Lookbook lookbook = LookbookMapper.mapToLookbook(lookbookDto, customer_info);
        Lookbook savedLookbook = lookbookRepository.save(lookbook);

        List<LookbookDetail> lookbookDetails = lookbookDetailRepository.findAllByLookbook(lookbookInfo);
        lookbookDetails.forEach((lookbookDetail) -> {
            LookbookDetail savedLookbookDetail = new LookbookDetail();
            savedLookbookDetail.setClothesDetail(lookbookDetail.getClothesDetail());
            savedLookbookDetail.setLookbook(savedLookbook);
            lookbookDetailRepository.save(savedLookbookDetail);
        });

        return LookbookMapper.mapToLookbookDto(savedLookbook);
    }

    @Override
    public LookbookDto updateLookbook(Long lookbookId, LookbookDto lookbookDto) {
        Lookbook lookbook = lookbookRepository.findById(lookbookId).orElseThrow(
            () -> new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId)
        );

        lookbook.setLookbookName(lookbookDto.getLookbookName());

        Lookbook updatedLookbookObj = lookbookRepository.save(lookbook);

        return LookbookMapper.mapToLookbookDto(updatedLookbookObj);
    }

    @Override
    public void deleteLookbookById(Long lookbookId) {
        List<LookbookDetail> lookbookDetails = null;
        List<ReferencedLookbook> referencedLookbooks = null;
        try{
            Lookbook lookbookInfo = lookbookRepository.findById(lookbookId).orElseThrow(() -> 
                new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId)
            );
            lookbookDetails = lookbookDetailRepository.findAllByLookbook(lookbookInfo);
            referencedLookbooks = referencedLookbookRepository.findAllByLookbook(lookbookInfo);
        } catch (Exception e) {
            new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId);
            return;
        }
        
        lookbookDetails.forEach((lookbookDetail) -> lookbookDetailRepository.delete(lookbookDetail));
        referencedLookbooks.forEach((referencedLookbook) -> referencedLookbookRepository.delete(referencedLookbook));
        
        lookbookRepository.deleteById(lookbookId);
    }
}
