import axios from "axios";
import { deleteObject, getStorage, ref } from "firebase/storage";
import { useEffect, useState } from "react";
import { Button, Col, Container, Row } from "react-bootstrap";
import { Hidden } from "react-grid-system";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import styled from 'styled-components';
import { FaHeart } from 'react-icons/fa6';
import { LazyLoadImage } from 'react-lazy-load-image-component';
import 'react-lazy-load-image-component/src/effects/blur.css'; // 필요한 CSS 효과

// 스타일 커스텀 버튼 생성
const HeartButton = styled.button`
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 5px;
    width: ${props => props.likeCount > 999 ? '100px' : '80px'};
    height: 35px;
    border: 2px solid #ccc;
    border-radius: 30px;
    background: white;
    color: red;
    font-size: ${props => props.likeCount > 999 ? '22px' : '24px'};
    cursor: pointer;
    transition: all 0.3s ease;
`;

function ProductItem(props) {


    const handleDelete = () => {
        const confirmDelete = window.confirm("상품을 제거하시겠습니까?");
        if (confirmDelete) {
            // 먼저 상품 데이터 삭제 요청
            axios.delete(`${process.env.REACT_APP_API_URL}/clothes/${props.item.clothesId}`)
                .then(result => {
                    // 상품 삭제가 성공한 후, 이미지 URL을 가져온다.
                    axios.get(`${process.env.REACT_APP_API_URL}/clothes_images/${props.item.clothesId}`)
                        .then(response => {
                            const imageDeletions = response.data.map(image => {
                                const storage = getStorage();
                                const imageRef = ref(storage, image.imageUrl);

                                // Firebase Storage에서 각 이미지 삭제
                                return deleteObject(imageRef)
                                    .then(() => console.log(`Deleted image ${image.imageUrl}`))
                                    .catch(error => {
                                        console.error(`Failed to delete image ${image.imageUrl}:`, error);
                                    });
                            });

                            // 모든 이미지 삭제를 처리
                            Promise.all(imageDeletions)
                                .then(() => {
                                    alert('상품이 성공적으로 제거되었습니다.');
                                    props.onDelete(props.item.clothesId); // 인터페이스 업데이트
                                })
                                .catch(error => {
                                    console.error('Some images may not have been deleted:', error);
                                    // alert('Failed to delete some images. Please check the logs.');
                                });
                        })
                        .catch(error => {
                            console.error('Failed to retrieve image data:', error);
                            // alert('Failed to retrieve image data. Please try again.');
                        });
                })
                .catch(error => {
                    console.error('Failed to delete the product:', error);
                    alert('Failed to delete the product. Please try again.');
                });
        }
    };

    return (
        <div style={{ fontSize: '18px', fontWeight: '600' }}>
            <Row>
                <Col md={{ span: 1, offset: 1 }}>
                    <LazyLoadImage
                        alt={props.item.name}
                        height={132}
                        src={props.item.imageUrl} // 사용하려는 이미지 URL
                        width={100}
                        effect="blur" // 이미지 로딩 동안 흐린 효과
                        style={{ width: '100px', height: '132px' }}
                    />
                </Col>
                <Col md={7}>
                    <div>
                        <div>{props.item.name}</div>
                        {props.item.genderCategory == 0 ? <div>성별 : 남자</div> :
                            props.item.genderCategory == 1 ? <div>성별 : 여자</div> :
                                <div>성별 : 성별무관</div>}
                        <div> 대분류 : {props.categories.majors[props.item.majorCategoryId] || 'Loading...'} </div>
                        <div> 소분류 : {props.categories.subs[props.item.subCategoryId] || 'Loading...'} </div>
                    </div>
                </Col>
                <Col md={1} style={{ marginTop: '12px', whiteSpace: 'nowrap', fontSize: '17px', fontWeight: '700' }}  >
                    <p>{props.item.price ? props.item.price.toLocaleString() : '0'}원</p>
                    <p style={{ display: 'flex', justifyContent: 'center' }}>
                        <HeartButton>
                            <FaHeart />
                            <span>{props.item.likesCount}</span>
                        </HeartButton>
                    </p>
                </Col>
                <Col md={1} style={{ marginTop: '12px', whiteSpace: 'nowrap', fontSize: '17px', fontWeight: '700' }}  >
                    <div><Button variant="dark" style={{ fontWeight: '700' }} onClick={() => { props.navigate(`/seller/productedit/${props.item.clothesId}`) }}>상품 수정</Button></div>
                    <div style={{ marginTop: '10px' }}><Button variant="danger" style={{ fontWeight: '700' }} onClick={handleDelete}>상품 삭제</Button></div>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 10, offset: 1 }}>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>
        </div>
    )
}

function ProductList(props) {

    let navigate = useNavigate();
    let dispatch = useDispatch();
    let { sellerInfo, isLoggedIn } = useSelector((state) => state.seller);
    let [productItems, setProductItems] = useState([]);

    const [categories, setCategories] = useState({ majors: {}, subs: {} }); // 모든 카테고리 정보 저장.

    function handleDelete(clothesId) {
        setProductItems(currentItems => currentItems.filter(item => item.clothesId !== clothesId));
    }

    useEffect(() => {

        if (!isLoggedIn || !sellerInfo) {
            return; // 로그인 상태나 sellerInfo가 유효하지 않은 경우 early return을 사용
        }

        // 카테고리 정보를 가져오기
        axios.get(`${process.env.REACT_APP_API_URL}/major_category`)
            .then(response => {
                const majorCategories = {};
                response.data.forEach(cat => {
                    majorCategories[cat.majorCategoryId] = cat.name;
                });
                setCategories(prev => ({ ...prev, majors: majorCategories }));
            });

        // 카테고리 정보를 가져오기
        axios.get(`${process.env.REACT_APP_API_URL}/sub_category`)
            .then(response => {
                const subCategories = {};
                response.data.forEach(cat => {
                    subCategories[cat.subCategoryId] = cat.name;
                });
                setCategories(prev => ({ ...prev, subs: subCategories }));
            });

        // 상품 목록을 가져오기
        axios.get(`${process.env.REACT_APP_API_URL}/clothes/seller/${sellerInfo.email_id}`)
            .then(result => {
                const itemsWithLikes = result.data.map(item => ({
                    ...item,
                    likesCount: 0, // 좋아요 수 초기값 설정
                    imageUrl: 'Loading...', // 초기 이미지 URL 설정
                    loadingError: false // 이미지 로딩 에러 추적을 위한 초기값 설정
                }));

                itemsWithLikes.forEach(item => {
                    loadImage(item);
                });

                setProductItems(itemsWithLikes); // 초기 상품 목록 설정
            })
            .catch(error => {
                console.error('등록 상품 불러오기 실패', error);
            });

    }, [isLoggedIn, sellerInfo, navigate]); // 의존성 배열에 isLoggedIn, sellerInfo 추가

    const loadImage = (item) => {
        axios.get(`${process.env.REACT_APP_API_URL}/clothes_images/${item.clothesId}`)
            .then(imageResult => {
                const image = imageResult.data.find(img => img.order === 1);
                setProductItems(currentItems => currentItems.map(currItem =>
                    currItem.clothesId === item.clothesId ? { ...currItem, imageUrl: image ? image.imageUrl : 'Error', loadingError: !image } : currItem
                ));
            })
            .catch(() => {
                setProductItems(currentItems => currentItems.map(currItem =>
                    currItem.clothesId === item.clothesId ? { ...currItem, loadingError: true } : currItem
                ));
                setTimeout(() => loadImage(item), 5000); // 5초 후 재시도
            });
    };

    return (
        <div>


            <Container>
                <Row>
                    <Col>
                        <br /> <br />
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>등록 상품</h1>
                        <br /><br />
                    </Col>
                </Row>
                <Row>
                    <Hidden xs sm>
                        <Col md={{ span: 7, offset: 2 }} style={{ fontSize: '20px', fontWeight: '700' }}>
                            상품 정보
                        </Col>
                    </Hidden>
                    <Hidden xs sm>
                        <Col md={1} style={{ whiteSpace: 'nowrap', fontSize: '20px', fontWeight: '700' }}>
                            상품 가격
                        </Col>
                    </Hidden>
                </Row>
                <Row>
                    <Col xs={12} md={{ span: 10, offset: 1 }}>
                        <hr style={{ border: 0, height: '2px', background: '#000000' }} />
                    </Col>
                </Row>



                <Row>
                    {productItems.map(item => (
                        <ProductItem
                            key={item.clothesId}
                            item={item}
                            categories={categories}
                            navigate={navigate}
                            onDelete={handleDelete}
                        />

                    ))}

                </Row>
                <br></br>
                <br></br>
            </Container>
        </div >
    )
}

export default ProductList;