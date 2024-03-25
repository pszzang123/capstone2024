package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ClothesDto;
import com.example.demo.entity.Cart;
import com.example.demo.entity.CartId;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.ClothesImagesId;
import com.example.demo.entity.Seller;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CartRepository;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.ClothesImagesRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.repository.SellerRepository;
import com.example.demo.service.ClothesService;
import com.example.mapper.ClothesMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ClothesServiceImpl implements ClothesService {
    private ClothesRepository clothesRepository;
    private ClothesImagesRepository clothesImagesRepository;
    private ClothesDetailRepository clothesDetailRepository;
    private SellerRepository sellerRepository;
    private CartRepository cartRepository;

    @Override
    public ClothesDto createClothes(ClothesDto clothesDto) {
        Seller seller_info = sellerRepository.findById(clothesDto.getSellerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Seller is not exist with given id : " + clothesDto.getSellerEmail())
        );
        Clothes clothes = ClothesMapper.mapToClothes(clothesDto, seller_info);
        Clothes savedClothes = clothesRepository.save(clothes);
        return ClothesMapper.mapToClothesDto(savedClothes);
    }

    @Override
    public ClothesDto getClothesById(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );
        
        return ClothesMapper.mapToClothesDto(clothes);
    }

    @Override
    public List<ClothesDto> getClothesBySeller(Seller seller) {
        List<Clothes> clothes = clothesRepository.findAllBySeller(seller);
        return clothes.stream().map((clothe) -> ClothesMapper.mapToClothesDto(clothe)).collect(Collectors.toList());
    }

    @Override
    public List<ClothesDto> getAllClothes() {
        List<Clothes> clothes = clothesRepository.findAll();
        return clothes.stream().map((clothe) -> ClothesMapper.mapToClothesDto(clothe)).collect(Collectors.toList());
    }

    @Override
    public ClothesDto updateClothes(Long clothesId, ClothesDto updatedClothes) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        clothes.setName(updatedClothes.getName());
        clothes.setDetail(updatedClothes.getDetail());
        clothes.setGenderCategory(updatedClothes.getGenderCategory());
        clothes.setLargeCategory(updatedClothes.getLargeCategory());
        clothes.setSmallCategory(updatedClothes.getSmallCategory());

        Clothes updatedClothesObj = clothesRepository.save(clothes);

        return ClothesMapper.mapToClothesDto(updatedClothesObj);
    }

    @Override
    public void deleteClothes(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exists with given id : " + clothesId)
        );

        List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothes);
        clothesImages.forEach(clothesImage -> {
            clothesImagesRepository.delete(clothesImage);
        });
        
        List<ClothesDetail> clothesDetails = clothesDetailRepository.findAllByClothes(clothes);
        clothesDetails.forEach(clothesDetail -> {
            List<Cart> carts = null;
            carts = cartRepository.findAllByClothesDetail(clothesDetail);
            if (carts != null) {
                carts.forEach((cart) -> {
                    cartRepository.delete(cart);
                });
            }
            clothesDetailRepository.delete(clothesDetail);
        });
        
        clothesRepository.deleteById(clothesId);
    }
}
