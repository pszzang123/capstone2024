package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.SellerDto;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.Seller;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.repository.SellerRepository;
import com.example.demo.service.ClothesService;
import com.example.demo.service.SellerService;
import com.example.mapper.SellerMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class SellerServiceImpl implements SellerService {
    private SellerRepository sellerRepository;
    private ClothesRepository clothesRepository;
    private ClothesService clothesService;

    @Override
    public SellerDto createSeller(SellerDto sellerDto) {
        Seller seller = SellerMapper.mapToSeller(sellerDto);
        Seller savedSeller = sellerRepository.save(seller);
        return SellerMapper.mapToSellerDto(savedSeller);
    }

    @Override
    public SellerDto getSellerByEmail(String customerEmail) {
        Seller seller = sellerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Seller is not exists with given id : " + customerEmail)
        );
        
        return SellerMapper.mapToSellerDto(seller);
    }

    @Override
    public List<SellerDto> getAllSellers() {
        List<Seller> sellers = sellerRepository.findAll();
        return sellers.stream().map((seller) -> SellerMapper.mapToSellerDto(seller)).collect(Collectors.toList());
    }

    @Override
    public SellerDto updateSeller(String customerEmail, SellerDto updatedSeller) {
        Seller seller = sellerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Seller is not exists with given id : " + customerEmail)
        );
        
        seller.setSellerEmail(updatedSeller.getSellerEmail());
        seller.setName(updatedSeller.getName());

        Seller updatedSellerObj = sellerRepository.save(seller);

        return SellerMapper.mapToSellerDto(updatedSellerObj);
    }

    @Override
    public void deleteSeller(String customerEmail) {
        Seller seller = sellerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Seller is not exists with given id : " + customerEmail)
        );

        List<Clothes> clothes = clothesRepository.findAllBySeller(seller);
        clothes.forEach(cloth -> clothesService.deleteClothes(cloth.getClothesId()));
        
        sellerRepository.deleteById(customerEmail);
    }
}
