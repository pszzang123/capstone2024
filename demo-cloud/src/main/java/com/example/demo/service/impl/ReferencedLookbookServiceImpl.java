package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.LookbookDto;
import com.example.demo.dto.ReferencedLookbookDto;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Lookbook;
import com.example.demo.entity.ReferencedLookbook;
import com.example.demo.entity.ReferencedLookbookId;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.repository.LookbookRepository;
import com.example.demo.repository.ReferencedLookbookRepository;
import com.example.demo.service.ReferencedLookbookService;
import com.example.mapper.LookbookMapper;
import com.example.mapper.ReferencedLookbookMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ReferencedLookbookServiceImpl implements ReferencedLookbookService {
    private CustomerRepository customerRepository;
    private LookbookRepository lookbookRepository;
    private ReferencedLookbookRepository referencedLookbookRepository;

    @Override
    public ReferencedLookbookDto createReferencedLookbook(ReferencedLookbookDto referencedLookbookDto) {
        Customer customer_info = customerRepository.findById(referencedLookbookDto.getCustomerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Customer is not exist with given id : " + referencedLookbookDto.getCustomerEmail())
        );
        Lookbook lookbook = lookbookRepository.findById(referencedLookbookDto.getLookbookId()).orElseThrow(() ->
            new ResourceNotFoundException("Lookbook is not exist with given id : " + referencedLookbookDto.getLookbookId())
        );

        ReferencedLookbook referencedLookbook = ReferencedLookbookMapper.mapToReferencedLookbook(customer_info, lookbook);
        ReferencedLookbook savedReferencedLookbook = referencedLookbookRepository.save(referencedLookbook);

        return ReferencedLookbookMapper.mapToReferencedLookbookDto(savedReferencedLookbook);
    }

    @Override
    public List<LookbookDto> getReferencedLookbookByCustomerEmail(String customerEmail) {
        Customer cusomter = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );

        List<ReferencedLookbook> referencedLookbooks = referencedLookbookRepository.findAllByCustomer(cusomter);
        return referencedLookbooks.stream().map((referencedLookbook) -> LookbookMapper.mapToLookbookDto(referencedLookbook.getLookbook())).collect(Collectors.toList());
    }

    @Override
    public List<ReferencedLookbookDto> getAllReferencedLookbook() {
        List<ReferencedLookbook> referencedLookbooks = referencedLookbookRepository.findAll();
        return referencedLookbooks.stream().map((referencedLookbook) -> ReferencedLookbookMapper.mapToReferencedLookbookDto(referencedLookbook)).collect(Collectors.toList());
    }

    @Override
    public void deleteReferencedLookbookById(String customerEmail, Long lookbookId) {
        Customer customer = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exist with given id : " + customerEmail)
        );
        Lookbook lookbook = lookbookRepository.findById(lookbookId).orElseThrow(() -> 
            new ResourceNotFoundException("Lookbook is not exist with given id : " + lookbookId)
        );
        ReferencedLookbookId referencedLookbookId = new ReferencedLookbookId(customer, lookbook);

        ReferencedLookbook referencedLookbook = referencedLookbookRepository.findById(referencedLookbookId).orElseThrow(() -> 
            new ResourceNotFoundException("Referenced Lookbook is not exist with given id : " + customerEmail + ", " + lookbookId)
        );
        
        referencedLookbookRepository.delete(referencedLookbook);
    }
}
