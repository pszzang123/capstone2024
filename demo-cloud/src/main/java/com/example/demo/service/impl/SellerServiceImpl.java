package com.example.demo.service.impl;

import java.util.List;
import java.util.Optional;
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
        Optional<Seller> seller_check = sellerRepository.findById(sellerDto.getEmail());
        if (!seller_check.isPresent()) {
            Seller seller = SellerMapper.mapToSeller(sellerDto);
            Seller savedSeller = sellerRepository.save(seller);
            return SellerMapper.mapToSellerDto(savedSeller);
        }
        else {
            return null;
        }
    }

    @Override
    public SellerDto getSellerByEmail(String email) {
        Seller seller = sellerRepository.findById(email).orElseThrow(() -> 
            new ResourceNotFoundException("Seller is not exists with given id : " + email)
        );
        
        return SellerMapper.mapToSellerDto(seller);
    }

    @Override
    public List<SellerDto> getAllSellers() {
        List<Seller> sellers = sellerRepository.findAll();
        return sellers.stream().map((seller) -> SellerMapper.mapToSellerDto(seller)).collect(Collectors.toList());
    }

    @Override
    public SellerDto updateSeller(String email, SellerDto updatedSeller) {
        Seller seller = sellerRepository.findById(email).orElseThrow(() -> 
            new ResourceNotFoundException("Seller is not exists with given id : " + email)
        );

        seller.setPassword(updatedSeller.getPassword());
        seller.setName(updatedSeller.getName());
        seller.setStreetAddress(updatedSeller.getStreetAddress());
        seller.setDetailAddress(updatedSeller.getDetailAddress());
        seller.setZipCode(updatedSeller.getZipCode());
        seller.setPhone(updatedSeller.getPhone());
        seller.setCompanyName(updatedSeller.getCompanyName());

        Seller updatedSellerObj = sellerRepository.save(seller);

        return SellerMapper.mapToSellerDto(updatedSellerObj);
    }

    @Override
    public void deleteSeller(String email) {
        Seller seller = sellerRepository.findById(email).orElseThrow(() -> 
            new ResourceNotFoundException("Seller is not exists with given id : " + email)
        );

        List<Clothes> clothes = clothesRepository.findAllBySeller(seller);
        clothes.forEach(cloth -> clothesService.deleteClothes(cloth.getClothesId()));
        
        sellerRepository.deleteById(email);
    }
}
