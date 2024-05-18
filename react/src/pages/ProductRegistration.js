import axios from 'axios';
import React, { useEffect, useState } from 'react';
import "firebase/firestore";
import { storage } from "../firebaseConfig.js";
import { ref, uploadBytes, getDownloadURL, uploadString } from "firebase/storage";
import { Container, Row, Col, Form, Button, Spinner } from 'react-bootstrap';
import { FaPlusCircle } from "react-icons/fa";
import styled from 'styled-components';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';

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

    let navigate = useNavigate();
    let dispatch = useDispatch();
    let { sellerInfo, isLoggedIn } = useSelector((state) => state.seller);

    const [loading, setLoading] = useState(false);  // 로딩 상태 관리

    const [category, setCategory] = useState({
        name: '',
        detail: '',
        price: 0,
        genderCategory: 0,
        majorCategoryId: '',
        subCategoryId: '',
        sellerEmail: ''
    });
    const [displayPrice, setDisplayPrice] = useState('');

    const [productDetails, setProductDetails] = useState([{
        color: '',
        size: '',
        remaining: 0,
        clothesId: 0
    }]);

    const [majorCategories, setMajorCategories] = useState([]);
    const [subCategories, setSubCategories] = useState([]);

    // 대분류 카테고리 데이터를 서버에서 가져오기
    useEffect(() => {
        axios.get(`${process.env.REACT_APP_API_URL}/major_category`)
            .then(response => {
                setMajorCategories(response.data);
            })
            .catch(error => {
                console.error('Major categories fetching error:', error);
            });
    }, []);

    // 대분류 카테고리 선택 시 소분류 카테고리 데이터 가져오기
    useEffect(() => {
        if (category.majorCategoryId) {
            axios.get(`${process.env.REACT_APP_API_URL}/sub_category/major_category/${category.majorCategoryId}`)
                .then(response => {
                    setSubCategories(response.data);
                })
                .catch(error => {
                    console.error('Sub categories fetching error:', error);
                });
        }
    }, [category.majorCategoryId]);



    const handleCategoryChange = e => {
        const { name, value } = e.target;
        setCategory(prevState => ({
            ...prevState,
            [name]: value
        }));
    };

    const handlePriceChange = (e) => {
        const value = e.target.value.replace(/\D/g, ''); // 숫자가 아닌 모든 문자 제거
        const formattedValue = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        setDisplayPrice(formattedValue); // 화면에 보여줄 값 업데이트
        setCategory(prevState => ({
            ...prevState,
            price: parseInt(value, 10) || 0  // 실제 저장될 숫자 값 업데이트
        }));
    };
    
    // 대분류 변경 이벤트 핸들러
    const handleMajorCategoryChange = (e) => {
        setCategory(prevState => ({
            ...prevState,
            majorCategoryId: e.target.value,
            subCategoryId: '', // 대분류가 변경될 때 소분류 초기화
        }));
    };

    // 소분류 변경 이벤트 핸들러
    const handleSubCategoryChange = (e) => {
        setCategory(prevState => ({
            ...prevState,
            subCategoryId: e.target.value,
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
        const filesArray = files instanceof FileList ? Array.from(files) : [files];

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
        setLoading(true);  // 제출 시작시 로딩 상태를 true로 설정

        // 썸네일 이미지 파일과 추가 이미지 파일들
        const thumbnailFile = document.querySelector('#thumbnailImage').files[0];
        const additionalFiles = document.querySelector('#additionalImages').files;

        if (!thumbnailFile) {
            alert('썸네일 이미지 파일을 선택해 주세요.');
            setLoading(false);
            return;
        }
        if (additionalFiles.length === 0) {
            alert('상품 이미지 파일을 선택해 주세요.');
            setLoading(false);
            return;
        }

        try {
            // 이미지 업로드 및 URL들을 얻음
            const [thumbnailImageUrl] = await handleUploadImages(thumbnailFile);
            const additionalImageUrls = additionalFiles.length > 0 ? await handleUploadImages(additionalFiles) : [];

            // Category 정보를 서버로 전송하고 응답을 받음
            const categoryResponse = await axios.post(`${process.env.REACT_APP_API_URL}/clothes`, {
                ...category,
                sellerEmail: sellerInfo.email_id
            });

            console.log('Category Response:', categoryResponse.data);

            // 상품의 category 등록에 성공한 후, 각 detail 등록
            for (let detail of productDetails) {
                // // 이미지 URL을 detail 객체에 추가
                // detail.imageUrl = imageUrls.shift(); // 가정: 각 detail마다 이미지 URL이 1개씩 할당됨

                // 서버에 detail 정보 등록
                const detailResponse = await axios.post(`${process.env.REACT_APP_API_URL}/detail`, {
                    ...detail,
                    clothesId: categoryResponse.data.clothesId // 서버로부터 받은 clothesId 사용
                });

                console.log('Detail Response:', detailResponse.data);
            }

            // 이미지 URL들을 서버로 POST 요청. 첫 번째 이미지는 썸네일로, 나머지는 추가 이미지로 처리
            await axios.post(`${process.env.REACT_APP_API_URL}/clothes_images`, {
                clothesId: categoryResponse.data.clothesId,
                imageUrl: thumbnailImageUrl, // 첫 번째 이미지 URL
                order: 1 // 썸네일 이미지로 설정
            });

            // 나머지 이미지들 처리
            await Promise.all(additionalImageUrls.map((imageUrl, index) => {
                return axios.post(`${process.env.REACT_APP_API_URL}/clothes_images`, {
                    clothesId: categoryResponse.data.clothesId,
                    imageUrl: imageUrl,
                    order: index + 2 // 추가 이미지들에 대해 순서 설정 (2부터 시작)
                });
            }));

            const clothesId = categoryResponse.data.clothesId; // 응답에서 clothesId 추출

            // 이제 `clothesId`를 사용하여 수정 페이지로 리디렉션
            navigate(`/seller/productedit/${clothesId}`);

            // 상품 등록에 성공했습니다 알림을 나중에 표시
            alert('상품 등록에 성공했습니다.');

        } catch (error) {
            console.error('Submitting error:', error);
            alert('상품 등록에 실패했습니다.');
            setLoading(false);
        }

        setLoading(false);
    };


    return (

        <form onSubmit={handleSubmit}>
           

            <Container>
                <Row>
                    <Col>
                        <br /> <br />
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>상품 신규 등록</h1>
                        <br /><br />
                    </Col>
                </Row>
                <Row className="mb-3 justify-content-center">
                    <Form.Group as={Row} controlId="formProductName">
                        <Form.Label column sm="2">이름</Form.Label>
                        <Col sm="10">
                            <Form.Control type="text" name="name" value={category.name} onChange={handleCategoryChange} />
                        </Col>
                    </Form.Group>
                </Row>
                {/* 상세 설명 */}
                <Row className="mb-3 justify-content-center">
                    <Form.Group as={Row} controlId="formProductDetail">
                        <Form.Label column sm="2">상세 설명</Form.Label>
                        <Col sm="10">
                            <Form.Control type="text" name="detail" value={category.detail} onChange={handleCategoryChange} />
                        </Col>
                    </Form.Group>
                </Row>

                {/* 가격 */}
                <Row className="mb-3 justify-content-center">
                    <Form.Group as={Row} controlId="formPrice">
                        <Form.Label column sm="2">가격</Form.Label>
                        <Col sm="10">
                            <Form.Control type="text" name="price" value={displayPrice} onChange={handlePriceChange} />
                        </Col>
                    </Form.Group>
                </Row>

                <Row className="mb-3 justify-content-center">
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
                <Row className="mb-3 justify-content-center">
                    <Form.Group as={Row} controlId="formMajorCategory">
                        <Form.Label column sm="2">대분류</Form.Label>
                        <Col sm="10">
                            <Form.Select
                                value={category.majorCategoryId} onChange={handleMajorCategoryChange}>
                                <option value="">대분류 선택</option>
                                {majorCategories.map((cat) => (
                                    <option key={cat.majorCategoryId} value={cat.majorCategoryId}>{cat.name}</option>
                                ))}
                            </Form.Select>
                        </Col>
                    </Form.Group>
                </Row>

                {/* 소분류 선택 */}
                <Row className="mb-3 justify-content-center">
                    <Form.Group as={Row} controlId="formSubCategory">
                        <Form.Label column sm="2">소분류</Form.Label>
                        <Col sm="10">
                            <Form.Select
                                value={category.subCategoryId} onChange={handleSubCategoryChange} disabled={!category.majorCategoryId}>
                                <option value="">소분류 선택</option>
                                {subCategories.map((cat) => (
                                    <option key={cat.subCategoryId} value={cat.subCategoryId}>{cat.name}</option>
                                ))}
                            </Form.Select>
                        </Col>
                    </Form.Group>
                </Row>

                <Row>
                    <Col md={{ offset: 11, span: 1 }} xs={{ offset: 10, span: 2 }}>
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
                        <Col md={1} className="align-self-center" style={{ marginTop: '30px' }}>
                            {productDetails.length > 1 && (
                                <Button variant="danger" onClick={() => handleRemoveProductDetail(index)}>&#x2715;</Button>
                            )}
                        </Col>
                    </Row>

                </Container>
            ))}
            <br></br><br></br>
            <Container>
                <Row>
                    <Col md={6}><label htmlFor="thumbnailImage" style={{ fontSize: '20px', fontWeight: '600', marginBottom: '5px' }}>썸네일 이미지 등록</label>
                        <input type="file" className="form-control" id="thumbnailImage" /></Col>
                    <Col md={6}><label htmlFor="additionalImages" style={{ fontSize: '20px', fontWeight: '600', marginBottom: '5px' }}>추가 이미지 등록</label>
                        <input type="file" className="form-control" id="additionalImages" multiple /></Col>
                </Row>
                <Row>
                    <Col style={{ display: 'flex', justifyContent: 'center', marginTop: '20px' }}>
                        <StyledButton onClick={() => { console.log(category) }} type="submit">
                            {loading ? (
                                <span>
                                    <Spinner
                                        as="span"
                                        animation="border"
                                        size="sm"
                                        role="status"
                                        aria-hidden="true"
                                        style={{ marginRight: '5px' }}
                                    />
                                    등록 중...
                                </span>
                            ) : '상품 등록하기'}
                        </StyledButton>
                    </Col>
                </Row>
            </Container>

            <br></br>

        </form >


    );
}

export default ProductRegistration;
