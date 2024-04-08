import axios from 'axios';
import React, { useEffect, useState } from 'react';
import "firebase/firestore";
import { storage } from "../firebaseConfig.js";
import { ref, uploadBytes, getDownloadURL, uploadString } from "firebase/storage";
import { Container, Row, Col, Form, Button } from 'react-bootstrap';
import { FaPlusCircle } from "react-icons/fa";
import styled from 'styled-components';

let StyledButton = styled.button`
  
  background-color: #000; /* 검은색 배경 */
  color: #fff; /* 흰색 텍스트 */
  border: none; /* 테두리 없음 */
  padding: 10px 100px; /* 내부 여백 */
  height: 50px;
  font-size: 1rem; /* 글자 크기 */
  font-weight: bold; /* 글자 굵기 */
  cursor: pointer; /* 마우스 오버시 커서 변경 */
//   border-radius: 5px; /* 모서리 둥글게 */
  transition: background-color 0.3s ease; /* 호버 효과를 위한 전환 */
  margin-bottom: 10px;

  &:hover {
    background-color: #333; /* 호버시 배경색 변경 */
  }
`;

// 상품 신규 등록
function ProductRegistration() {
    const [category, setCategory] = useState({
        name: '',
        detail: '',
        price: 0,
        genderCategory: 0,
        // categoryNumber: '',
        majorCategory: '',
        subCategory: '',
        sellerEmail: ''
    });

    const [productDetails, setProductDetails] = useState([{
        color: '',
        size: '',
        remaining: 0,
        clothesId: 0
    }]);

    // 가정: 대분류 카테고리 데이터
    const majorCategories = [
        { id: '01', name: '아우터' },
        { id: '02', name: '정장' },
        { id: '03', name: '팬츠' },
    ];

    // 가정: 소분류 카테고리 데이터 (실제로는 largeCategory에 따라 필터링 필요)
    const subCategories = {
        '01': [{ id: '01', name: '점퍼' }, { id: '02', name: '코트' }],
        '02': [{ id: '01', name: '정장재킷' }, { id: '02', name: '정장팬츠' }],
        '03': [{ id: '01', name: '치노' }, { id: '02', name: '슬랙스' }],
    };



    const handleCategoryChange = e => {
        const { name, value } = e.target;
        setCategory(prevState => ({
            ...prevState,
            [name]: value
        }));
    };

    // 대분류 변경 이벤트 핸들러
    const handleMajorCategoryChange = (e) => {
        setCategory(prevState => ({
            ...prevState,
            majorCategory: e.target.value,
            subCategory: '', // 대분류가 변경될 때 소분류 초기화
        }));
    };

    // 소분류 변경 이벤트 핸들러
    const handleSubCategoryChange = (e) => {
        setCategory(prevState => ({
            ...prevState,
            subCategory: e.target.value,
        }));
    };

    const handleProductDetailChange = (e, index) => {
        const { name, value } = e.target;
        const list = [...productDetails];
        list[index][name] = value;
        setProductDetails(list);
    };

    // 상품 상세 정보 추가
    const handleAddProductDetail = () => {
        setProductDetails([...productDetails, { color: '', size: '', remaining: 0, clothesId: 0 }]);
    };

    // 상품 상세 정보 제거
    const handleRemoveProductDetail = index => {
        const list = [...productDetails];
        list.splice(index, 1);
        setProductDetails(list);
    };


    const handleUploadImages = async (files) => {
        // FileList 객체를 배열로 변환
        const filesArray = Array.from(files);

        const uploadPromises = filesArray.map((file, index) => {
            const now = new Date();
            const timestamp = now.getTime();
            const fileName = `${timestamp}-${index}-${file.name}`;
            const firebasePath = ref(storage, `images/${fileName}`);

            return uploadBytes(firebasePath, file)
                .then(uploadResult => getDownloadURL(uploadResult.ref));
        });

        // 파일 업로드를 동시에 처리하고, 모든 URL을 반환
        return Promise.all(uploadPromises);
    };


    // 제출 처리
    const handleSubmit = async (e) => {
        e.preventDefault();

        const files = document.querySelector('#image').files;
        if (files.length === 0) {
            alert('이미지 파일을 선택해 주세요.');
            return;
        }
        try {
            // 이미지 업로드 및 URL들을 얻음
            const imageUrls = await handleUploadImages(files);

            // Category 정보를 서버로 전송하고 응답을 받음
            const categoryResponse = await axios.post('http://localhost:8080/clothes', category);
            console.log('Category Response:', categoryResponse.data);

            // 상품의 category 등록에 성공한 후, 각 detail 등록
            for (let detail of productDetails) {
                // // 이미지 URL을 detail 객체에 추가
                // detail.imageUrl = imageUrls.shift(); // 가정: 각 detail마다 이미지 URL이 1개씩 할당됨

                // 서버에 detail 정보 등록
                const detailResponse = await axios.post('http://localhost:8080/detail', {
                    ...detail,
                    clothesId: categoryResponse.data.clothesId // 서버로부터 받은 clothesId 사용
                });

                console.log('Detail Response:', detailResponse.data);
            }

            // 이미지 URL들을 서버로 POST 요청
            await Promise.all(imageUrls.map((imageUrl, index) => {
                return axios.post('http://localhost:8080/clothes_images', {
                    clothesId: categoryResponse.data.clothesId,
                    imageUrl: imageUrl,
                    order: index + 1 // 이미지 순서 지정 (1부터 시작)
                });
            }));

            alert('상품 등록에 성공했습니다.');
        } catch (error) {
            console.error('Submitting error:', error);
            alert('상품 등록에 실패했습니다.');
        }

        // // 파일 업로드 함수 호출
        // handleUploadImages(files);

        // axios.put('http://localhost:8080/clothes', category)
        //   .then(categoryResult => {
        //     console.log('Category Response:', categoryResult.data);

        //     setProductDetail(prevState => ({
        //       ...prevState,
        //       clothesId: categoryResult.data.clothesId // categoryResult.data.clothesId를 적절한 값으로 교체
        //     }));




        //     axios.put('http://localhost:8080/detail', productDetail)
        //       .then(detailResult => {
        //         console.log('Detail Response:', detailResult.data);

        //         try {
        //           let upload = firebasePath.put(file);
        //           let imageUrl = upload.ref.getDownloadURL(); // 업로드된 파일의 URL을 가져옵니다.

        //           // 이미지 URL을 상태에 저장하거나 서버로 전송하는 로직 추가
        //           // console.log(imageUrl); // 처리 예: 이미지 URL 출력
        //           axios.post('http://localhost:8080/clothes_images', { clothesId: productDetail.clothesId, imageUrl: imageUrl, order: 1 })
        //             .then(result => {
        //               console.log('이미지 업로드 성공');
        //             })
        //             .catch(error => {
        //               console.log('이미지 DB 업로드 실패', error);
        //             })

        //         } catch (error) {
        //           console.error('이미지 업로드 중 오류 발생:', error);
        //           alert('이미지 업로드에 실패했습니다.');
        //         }
        //       })
        //       .catch(error => {
        //         console.error('Submitting error:', error);
        //         alert('상품 등록에 실패했습니다.');
        //       })
        //   })
        //   .catch(error => {
        //     console.error('Submitting error:', error);
        //     alert('상품 등록에 실패했습니다.');
        //   })




        // // 이미지 파일 처리
        // let file = document.querySelector('#image').files[0];
        // if (!file) {
        //   alert('이미지 파일을 선택해 주세요.');
        //   return;
        // }

        // // 파일 이름에 현재 날짜와 시간을 포함시켜 고유하게 만듭니다.
        // const now = new Date();
        // const timestamp = now.getTime(); // 현재 시간을 밀리초로
        // const fileName = `${timestamp}-${file.name}`; // 파일 이름 생성

        // let storageRef = storage.ref();
        // let firebasePath = storageRef.child(`images/${fileName}`);

        // axios.post('http://localhost:8080/clothes', category)
        //   .then(categoryResult => {
        //     console.log('Category Response:', categoryResult.data);

        //     setProductDetail(prevState => ({
        //       ...prevState,
        //       clothesId: categoryResult.data.clothesId // categoryResult.data.clothesId를 적절한 값으로 교체
        //     }));



        //     axios.post('http://localhost:8080/detail', productDetail)
        //       .then(detailResult => {
        //         console.log('Detail Response:', detailResult.data);

        //         try {
        //           let upload = firebasePath.put(file);
        //           let imageUrl = upload.ref.getDownloadURL(); // 업로드된 파일의 URL을 가져옵니다.

        //           // 이미지 URL을 상태에 저장하거나 서버로 전송하는 로직 추가
        //           // console.log(imageUrl); // 처리 예: 이미지 URL 출력
        //           axios.post('http://localhost:8080/clothes_images', { clothesId: productDetail.clothesId, imageUrl: imageUrl, order: 1 })
        //             .then(result => {
        //               console.log('이미지 업로드 성공');
        //             })
        //             .catch(error => {
        //               console.log('이미지 DB 업로드 실패', error);
        //             })

        //         } catch (error) {
        //           console.error('이미지 업로드 중 오류 발생:', error);
        //           alert('이미지 업로드에 실패했습니다.');
        //         }
        //       })
        //       .catch(error => {
        //         console.error('Submitting error:', error);
        //         alert('상품 등록에 실패했습니다.');
        //       })
        //   })
        //   .catch(error => {
        //     console.error('Submitting error:', error);
        //     alert('상품 등록에 실패했습니다.');
        //   })

    };

    // let file = document.querySelector('#image').files[0];
    // let storageRef = storage.ref();
    // let 저장할경로 = storageRef.child('image/' + '파일명');
    // let 업로드작업 = 저장할경로.put(file)

    // const now = new Date();

    // const year = now.getFullYear();
    // const month = (now.getMonth() + 1).toString().padStart(2, '0');
    // const day = now.getDate().toString().padStart(2, '0');
    // const hours = now.getHours().toString().padStart(2, '0');
    // const minutes = now.getMinutes().toString().padStart(2, '0');

    // const dateTime = `${year}${month}${day}${hours}${minutes}`;

    return (

        <form onSubmit={handleSubmit}>
            <br />
            <h1>상품 신규 등록</h1>



            <Container>
                <Row className="mb-3">
                    <Form.Group as={Row} controlId="formProductName">
                        <Form.Label column sm="2">이름</Form.Label>
                        <Col sm="10">
                            <Form.Control type="text" name="name" value={category.name} onChange={handleCategoryChange} />
                        </Col>
                    </Form.Group>
                </Row>
                {/* 상세 설명 */}
                <Row className="mb-3">
                    <Form.Group as={Row} controlId="formProductDetail">
                        <Form.Label column sm="2">상세 설명</Form.Label>
                        <Col sm="10">
                            <Form.Control type="text" name="detail" value={category.detail} onChange={handleCategoryChange} />
                        </Col>
                    </Form.Group>
                </Row>

                {/* 가격 */}
                <Row className="mb-3">
                    <Form.Group as={Row} controlId="formPrice">
                        <Form.Label column sm="2">가격</Form.Label>
                        <Col sm="10">
                            <Form.Control type="number" name="price" value={category.price} onChange={handleCategoryChange} />
                        </Col>
                    </Form.Group>
                </Row>

                <Row className="mb-3">
                    <Form.Group as={Row} controlId="formGenderCategory">
                        <Form.Label column sm="2">성별 카테고리</Form.Label>
                        <Col sm="10">
                            <Form.Select
                                name="genderCategory"
                                value={category.genderCategory}
                                onChange={handleCategoryChange}
                            >
                                <option value="">성별 선택</option>
                                <option value="0">남자</option>
                                <option value="1">여자</option>
                                <option value="2">성별무관</option>
                            </Form.Select>
                        </Col>
                    </Form.Group>
                </Row>


                {/* 대분류 선택 */}
                <Row className="mb-3">
                    <Form.Group as={Row} controlId="formMajorCategory">
                        <Form.Label column sm="2">대분류</Form.Label>
                        <Col sm="10">
                            <Form.Select
                                value={category.majorCategory} onChange={handleMajorCategoryChange}>
                                <option value="">대분류 선택</option>
                                {majorCategories.map((cat) => (
                                    <option key={cat.id} value={cat.id}>{cat.name}</option>
                                ))}
                            </Form.Select>
                        </Col>
                    </Form.Group>
                </Row>

                {/* 소분류 선택 */}
                <Row className="mb-3">
                    <Form.Group as={Row} controlId="formSubCategory">
                        <Form.Label column sm="2">소분류</Form.Label>
                        <Col sm="10">
                            <Form.Select
                                value={category.subCategory} onChange={handleSubCategoryChange} disabled={!category.majorCategory} >
                                <option value="">소분류 선택</option>
                                {category.majorCategory && subCategories[category.majorCategory]?.map((cat) => (
                                    <option key={cat.id} value={cat.id}>{cat.name}</option>
                                ))}
                            </Form.Select>
                        </Col>
                    </Form.Group>
                </Row>

                {/* 판매자 이메일, 추후 로그인한 판매자 이메일이 자동으로 들어가도록 수정 예정 */}
                <Row className="mb-3">
                    <Form.Group as={Row} controlId="formSellerEmail">
                        <Form.Label column sm="2">판매자 이메일</Form.Label>
                        <Col sm="10">
                            <Form.Control type="email" name="sellerEmail" value={category.sellerEmail} onChange={handleCategoryChange} />
                        </Col>
                    </Form.Group>
                </Row>
                <Row>
                    <Col md={{ offset: 11, span: 1 }}>
                        <button type="button" style={{ background: 'white', border: '0px' }} onClick={handleAddProductDetail}>
                            <FaPlusCircle size={30} />
                        </button>
                    </Col>
                </Row>
            </Container>

            {productDetails.map((productDetail, index) => (
                <Container key={index} className="mb-3">
                    <Row>
                        <Col md={4}>
                            <Form.Group controlId={`color-${index}`}>
                                <Form.Label>색상</Form.Label>
                                <Form.Control
                                    type="text"
                                    name="color"
                                    value={productDetail.color}
                                    onChange={(e) => handleProductDetailChange(e, index)} />
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group controlId={`size-${index}`}>
                                <Form.Label>사이즈</Form.Label>
                                <Form.Control
                                    type="text"
                                    name="size"
                                    value={productDetail.size}
                                    onChange={(e) => handleProductDetailChange(e, index)} />
                            </Form.Group>
                        </Col>
                        <Col md={3}>
                            <Form.Group controlId={`remaining-${index}`}>
                                <Form.Label>재고</Form.Label>
                                <Form.Control
                                    type="number"
                                    name="remaining"
                                    value={productDetail.remaining}
                                    onChange={(e) => handleProductDetailChange(e, index)} />
                            </Form.Group>
                        </Col>
                        <Col md={1} className="align-self-center">
                            {productDetails.length > 1 && (
                                <Button variant="danger" onClick={() => handleRemoveProductDetail(index)}>&#x2715;</Button>
                            )}
                        </Col>
                    </Row>
                </Container>
            ))}

            {/* 상품 이미지 등록
       <input class="form-control mt-2" type="file" id="image" /> */}
            <input className="form-control mt-2" type="file" id="image" style={{ width: '500px', marginLeft: '150px' }} multiple />
            <br></br>
            <StyledButton type="submit">상품 등록하기</StyledButton>
        </form > 


    );
}

export default ProductRegistration;
