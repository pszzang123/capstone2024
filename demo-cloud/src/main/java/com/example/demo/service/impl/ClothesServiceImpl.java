package com.example.demo.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.ClothesDto;
import com.example.demo.dto.StatisticsDto;
import com.example.demo.entity.Cart;
import com.example.demo.entity.Clothes;
import com.example.demo.entity.ClothesDetail;
import com.example.demo.entity.ClothesImages;
import com.example.demo.entity.MajorCategory;
import com.example.demo.entity.Seller;
import com.example.demo.entity.SubCategory;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CartRepository;
import com.example.demo.repository.ClothesDetailRepository;
import com.example.demo.repository.ClothesImagesRepository;
import com.example.demo.repository.ClothesRepository;
import com.example.demo.repository.MajorCategoryRepository;
import com.example.demo.repository.SellerRepository;
import com.example.demo.repository.SubCategoryRepository;
import com.example.demo.service.ClothesService;
import com.example.demo.vo.ClothesVo;
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
    private MajorCategoryRepository majorCategoryRepository;
    private SubCategoryRepository subCategoryRepository;

    @Override
    public ClothesDto createClothes(ClothesDto clothesDto) {
        Seller seller_info = sellerRepository.findById(clothesDto.getSellerEmail()).orElseThrow(() ->
            new ResourceNotFoundException("Seller is not exist with given id : " + clothesDto.getSellerEmail())
        );
        StatisticsDto statisticsDto = new StatisticsDto(
            0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
        );
        MajorCategory majorCategory_info = majorCategoryRepository.findById(clothesDto.getMajorCategoryId()).orElseThrow(() ->
            new ResourceNotFoundException("Major Category is not exist with given id : " + clothesDto.getMajorCategoryId())
        );
        SubCategory subCategory_info = subCategoryRepository.findById(clothesDto.getSubCategoryId()).orElseThrow(() ->
            new ResourceNotFoundException("Sub Category is not exist with given id : " + clothesDto.getSubCategoryId())
        );

        if (subCategory_info.getMajorCategory().getMajorCategoryId() != majorCategory_info.getMajorCategoryId()) {
            return null;
        }

        Clothes clothes = ClothesMapper.mapToClothes(clothesDto, statisticsDto, majorCategory_info, subCategory_info, seller_info);
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
    public StatisticsDto getStatisticsById(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );
        
        return ClothesMapper.mapToStatisticsDto(clothes);
    }

    @Override
    public List<ClothesDto> getClothesBySeller(Seller seller) {
        List<Clothes> clothes = clothesRepository.findAllBySeller(seller);
        return clothes.stream().map((clothe) -> {
            return ClothesMapper.mapToClothesDto(clothe);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getClothesByGenderCategory(Integer genderCategory) {
        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryOrderByDailyViewDesc(genderCategory);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getClothesByMajorCategory(Long majorCategoryId) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByMajorCategoryOrderByDailyViewDesc(majorCategory);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getClothesBySubCategory(Long subCategoryId) {
        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllBySubCategoryOrderByDailyViewDesc(subCategory);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getClothesByGenderCategoryAndMajorCategory(Integer genderCategory, Long majorCategoryId) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryAndMajorCategoryOrderByDailyViewDesc(genderCategory, majorCategory);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getClothesByGenderCategoryAndSubCategory(Integer genderCategory, Long subCategoryId) {
        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryAndSubCategoryOrderByDailyViewDesc(genderCategory, subCategory);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getClothesByMajorCategoryAndSubCategory(Long majorCategoryId, Long subCategoryId) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByMajorCategoryAndSubCategoryOrderByDailyViewDesc(majorCategory, subCategory);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getClothesByGenderCategoryAndMajorCategoryAndSubCategory(Integer genderCategory, Long majorCategoryId, Long subCategoryId) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(() -> 
            new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryAndMajorCategoryAndSubCategoryOrderByDailyViewDesc(genderCategory, majorCategory, subCategory);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesByName(String name) {
        List<Clothes> clothes = clothesRepository.findAllByNameContainingOrderByDailyViewDesc(name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesByGenderCategoryAndName(Integer genderCategory, String name) {
        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryAndNameContainingOrderByDailyViewDesc(genderCategory, name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesBySubCategoryAndName(Long subCategoryId, String name) {
        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllBySubCategoryAndNameContainingOrderByDailyViewDesc(subCategory, name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesByMajorCategoryAndName(Long majorCategoryId, String name) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByMajorCategoryAndNameContainingOrderByDailyViewDesc(majorCategory, name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesByGenderCategoryAndSubCategoryAndName(Integer genderCategory, Long subCategoryId, String name) {
        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryAndSubCategoryAndNameContainingOrderByDailyViewDesc(genderCategory, subCategory, name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesByGenderCategoryAndMajorCategoryAndName(Integer genderCategory, Long majorCategoryId, String name) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryAndMajorCategoryAndNameContainingOrderByDailyViewDesc(genderCategory, majorCategory, name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesByMajorCategoryAndSubCategoryAndName(Long majorCategoryId, Long subCategoryId, String name) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByMajorCategoryAndSubCategoryAndNameContainingOrderByDailyViewDesc(majorCategory, subCategory, name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> searchClothesByGenderCategoryAndMajorCategoryAndSubCategoryAndName(Integer genderCategory, Long majorCategoryId, Long subCategoryId, String name) {
        MajorCategory majorCategory = majorCategoryRepository.findById(majorCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Major Category is not exist with given id : " + majorCategoryId)
        );

        SubCategory subCategory = subCategoryRepository.findById(subCategoryId).orElseThrow(
            () -> new ResourceNotFoundException("Sub Category is not exist with given id : " + subCategoryId)
        );

        List<Clothes> clothes = clothesRepository.findAllByGenderCategoryAndMajorCategoryAndSubCategoryAndNameContainingOrderByDailyViewDesc(genderCategory, majorCategory, subCategory, name);
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> getAllClothes() {
        List<Clothes> clothes = clothesRepository.findAll();
        return clothes.stream().map((clothe) -> {
            String imageUrl = "";
            List<ClothesImages> clothesImages = clothesImagesRepository.findAllByClothes(clothe);
            for (ClothesImages clothesImage : clothesImages) {
                if (clothesImage.getOrder() == 1) {
                    imageUrl = clothesImage.getImageUrl();
                    break;
                } else {
                    continue;
                }
            }
            return ClothesMapper.mapToClothesVo(clothe, imageUrl);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ClothesVo> sortClothesVos(List<ClothesVo> clothes, Integer sortId) {
        Collections.sort(clothes, (c1, c2) -> {
            Clothes clothes1 = clothesRepository.findById(c1.getClothesId()).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exist with given id : " + c1.getClothesId())
            );
            Clothes clothes2 = clothesRepository.findById(c2.getClothesId()).orElseThrow(() -> 
                new ResourceNotFoundException("Clothes are not exist with given id : " + c2.getClothesId())
            );

            if (sortId == 1) {
                // 인기순 (판매량)
                return (int)(clothes1.getTotalSales() - clothes2.getTotalSales());
            }
            else if (sortId == 2) {
                // 최신순
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDateTime c1_date = LocalDateTime.parse(clothes1.getUpdateDate(), formatter);
                LocalDateTime c2_date = LocalDateTime.parse(clothes2.getUpdateDate(), formatter);
                return c1_date.compareTo(c2_date);
            }
            else if (sortId == 3) {
                // 댓글순
                return (int)(clothes1.getTotalComment() - clothes2.getTotalComment());
            }
            else if (sortId == 4) {
                // 좋아요순
                return (int)(clothes1.getTotalLike() - clothes2.getTotalLike());
            }
            else {
                // 조회수순
                return (int)(clothes1.getTotalView() - clothes2.getTotalView());
            }
        });
        return clothes;
    }

    @Override
    public StatisticsDto viewClothes(Long clothesId) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );

        clothes.setDailyView(clothes.getDailyView() + 1);
        clothes.setMonthlyView(clothes.getMonthlyView() + 1);
        clothes.setTotalView(clothes.getTotalView() + 1);

        Clothes updatedClothesObj = clothesRepository.save(clothes);

        return ClothesMapper.mapToStatisticsDto(updatedClothesObj);
    }

    @Override
    public ClothesDto updateClothes(Long clothesId, ClothesDto updatedClothes) {
        Clothes clothes = clothesRepository.findById(clothesId).orElseThrow(
            () -> new ResourceNotFoundException("Clothes are not exist with given id : " + clothesId)
        );
        MajorCategory majorCategory_info = majorCategoryRepository.findById(updatedClothes.getMajorCategoryId()).orElseThrow(() ->
            new ResourceNotFoundException("Major Category is not exist with given id : " + updatedClothes.getMajorCategoryId())
        );
        SubCategory subCategory_info = subCategoryRepository.findById(updatedClothes.getSubCategoryId()).orElseThrow(() ->
            new ResourceNotFoundException("Sub Category is not exist with given id : " + updatedClothes.getSubCategoryId())
        );

        if (subCategory_info.getMajorCategory().getMajorCategoryId() != majorCategory_info.getMajorCategoryId()) {
            return null;
        }

        clothes.setName(updatedClothes.getName());
        clothes.setDetail(updatedClothes.getDetail());
        clothes.setGenderCategory(updatedClothes.getGenderCategory());
        clothes.setMajorCategory(majorCategory_info);
        clothes.setSubCategory(subCategory_info);
        clothes.setPrice(updatedClothes.getPrice());

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
