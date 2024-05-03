import { useNavigate, useParams } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Nav from 'react-bootstrap/Nav';
import { useDispatch, useSelector } from 'react-redux';
import { addToCart, setCartItems } from '../store/cartSlice';
import axios from 'axios';
import { Container, Row, Col, Carousel, FloatingLabel, Form, Button, InputGroup } from 'react-bootstrap';
import { Dropdown } from 'react-bootstrap';
import styled from 'styled-components';
import { FaHeart } from 'react-icons/fa6';


const StyledDropdownToggle = styled(Dropdown.Toggle)`
    background-color: #fff !important; /* 흰색 배경 */
    color: #000 !important; /* 검은색 텍스트 */
    border: 2px solid #000 !important; /* 조금 더 두꺼운 검은색 테두리 */
    border-radius: 4px !important; /* 모서리를 약간 둥글게 */
    font-weight: 500; /* 글자 굵기 조절 */

    &:hover, &:focus {
    background-color: #f8f9fa !important; /* 호버 및 포커스 시 배경색 */
    color: #000 !important; /* 호버 및 포커스 시 텍스트 색상 */
    border-color: #888 !important; /* 호버 및 포커스 시 테두리 색상 변경 */
    }
`;

const StyledDropdownMenu = styled(Dropdown.Menu)`
    background-color: #fff; /* 흰색 배경 */
    color: #000; /* 검은색 텍스트 */
    border-radius: 4px; /* 메뉴의 모서리를 둥글게 */

    .dropdown-item {
    color: #000; /* 옵션 텍스트 색상 */
    font-weight: 400; /* 옵션 글자 굵기 */

    &:hover, &:focus {
        background-color: #f0f0f0; /* 옵션 호버 및 포커스 시 배경색 */
        font-weight: 500; /* 옵션 호버 시 글자 굵기 */
`;

// 스타일 커스텀 버튼 생성
const HeartButton = styled.button`
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 5px;
    width: ${props => props.likeCount > 999 ? '100px' : '80px'};
    height: 45px;
    border: 2px solid #ccc;
    border-radius: 30px;
    background: white;
    color: ${props => props.isLiked ? 'red' : 'gray'};
    font-size: ${props => props.likeCount > 999 ? '22px' : '24px'};
    cursor: pointer;
    transition: all 0.3s ease;

    &:hover, &:focus {
        background: ${props => props.isLiked ? '#ffcccc' : '#f8f8f8'};
        border-color: ${props => props.isLiked ? 'red' : 'gray'};
    }
`;



function Detail(props) {

    let dispatch = useDispatch()
    const { userInfo, isLoggedIn } = useSelector((state) => state.user);
    const [isLiked, setIsLiked] = useState(false);  // 좋아요 여부
    const [likeCount, setLikeCount] = useState(0);  // 좋아요 개수

    let { clothesId } = useParams();    // 옷 ID

    let [clothes, setClothes] = useState({});   // 상품 데이터
    let [details, setDetails] = useState([]);   // 상품 상세 데이터
    let [imgUrls, setImgUrls] = useState([]);   // 이미지

    let [selectedDetail, setSelectedDetail] = useState(null);   // 선택한 상세 옵션
    let [quantity, setQuantity] = useState(1);      // 개수

    // 탭 상태
    let [tab, setTab] = useState(0);

    let navigate = useNavigate();


    let cartItems = useSelector((state) => state.cart.items);



    // fade 애니메이션
    // let [fade1, setFade1] = useState('');

    // 2초 이내 구매
    // let [eventAlert, setEventAlert] = useState(true)



    useEffect(() => {
        // 로그인 상태일 경우 좋아요 여부 불러오기
        if (isLoggedIn) {
            axios.get(`${process.env.REACT_APP_API_URL}/like/${userInfo.email_id}/${clothesId}`)
                .then(response => {
                    if (response.status === 200) {
                        setIsLiked(true);
                    }
                })
                .catch(error => {
                    if (error.response && error.response.status === 404) {
                        setIsLiked(false);
                    }
                });
        }

        // 로그인 상태일 경우 좋아요 여부 불러오기
        axios.get(`${process.env.REACT_APP_API_URL}/like/clothes/${clothesId}`)
            .then(response => {
                setLikeCount(response.data.length); // 좋아요 수 설정
            })
            .catch(error => {
                console.log('좋아요 수 로딩 에러', error);
            })
    }, [userInfo, clothesId, isLoggedIn]);

    // 좋아요 누르면 실행할 함수
    const toggleLike = () => {

        if (!isLoggedIn) {
            alert('로그인 후 이용해주세요.');
            return;
        }

        if (isLiked) {
            axios.delete(`${process.env.REACT_APP_API_URL}/like/${userInfo.email_id}/${clothesId}`)
                .then(() => {
                    setIsLiked(false);
                    setLikeCount(likeCount - 1);  // 좋아요 수 감소
                })
                .catch(error => console.error("좋아요 취소 실패", error));
        } else {
            axios.post(`${process.env.REACT_APP_API_URL}/like`, {
                "customerEmail": userInfo.email_id,
                "clothesId": clothesId
            })
                .then(() => {
                    setIsLiked(true);
                    setLikeCount(likeCount + 1);  // 좋아요 수 증가
                })
                .catch(error => console.error("좋아요 추가 실패", error));
        }

        // 포커스 제거
        if (document.activeElement instanceof HTMLElement) {
            document.activeElement.blur();
        }

    };


    useEffect(() => {
        axios.get(`${process.env.REACT_APP_API_URL}/clothes/${clothesId}`)
            .then(result => {
                setClothes(result.data);
            })
            .catch(error => {
                console.log('상품 데이터 로딩 에러', error);
            })

        axios.get(`${process.env.REACT_APP_API_URL}/detail/clothes/${clothesId}`)
            .then(result => {
                setDetails(result.data);
            })
            .catch(error => {
                console.log('상품 상세 정보 로딩 에러', error);
            })

        axios.get(`${process.env.REACT_APP_API_URL}/clothes_images/${clothesId}`)
            .then(result => {
                setImgUrls(result.data);
            })
            .catch(error => {
                console.log('이미지 로딩 에러', error);
            })
    }, [clothesId])


    // const handleAddToCart = () => {
    //     if (!isLoggedIn) {
    //         alert('로그인 후 이용해주세요.');
    //         return;
    //     }

    //     if (!selectedDetail) {
    //         alert('옵션을 선택해주세요.');
    //         return;
    //     }
    //     const item = {
    //         customerEmail: userInfo.email_id,
    //         detailId: selectedDetail.detailId,
    //         quantity
    //     };

    //     axios.post(`${process.env.REACT_APP_API_URL}/cart`, item)
    //         .then(response => {
    //             dispatch(addToCart(response.data));
    //             alert('장바구니에 추가되었습니다.');
    //         })
    //         .catch(error => console.error("장바구니 담기 실패", error));
    // };
    const handleAddToCart = () => {
        if (!isLoggedIn) {
            alert('로그인 후 이용해주세요.');
            return;
        }

        if (!selectedDetail) {
            alert('옵션을 선택해주세요.');
            return;
        }

        // 기존 장바구니 데이터에서 같은 detailId를 가진 항목 찾기
        const existingItem = cartItems.find(item => item.detailId === selectedDetail.detailId);

        if (existingItem) {
            // 기존 항목의 수량 업데이트
            const updatedQuantity = existingItem.quantity + quantity;

            axios.put(`${process.env.REACT_APP_API_URL}/cart/${userInfo.email_id}/${existingItem.detailId}`, {
                customerEmail: userInfo.email_id,
                detailId: selectedDetail.detailId, // 필요없음.
                quantity: updatedQuantity
            })
                .then(response => {
                    dispatch(addToCart({
                        customerEmail: userInfo.email_id,
                        detailId: selectedDetail.detailId,
                        quantity: quantity
                    })); // Redux 상태 업데이트
                    alert('장바구니 수량이 업데이트되었습니다.');
                })
                .catch(error => console.error("장바구니 업데이트 실패", error));
        } else {
            // 새 항목을 장바구니에 추가
            const newItem = {
                customerEmail: userInfo.email_id,
                detailId: selectedDetail.detailId,
                quantity
            };

            axios.post(`${process.env.REACT_APP_API_URL}/cart`, newItem)
                .then(response => {
                    dispatch(addToCart(newItem));
                    alert('장바구니에 추가되었습니다.');
                })
                .catch(error => console.error("장바구니 담기 실패", error));
        }
    };


    const handleBuyNow = () => {
        if (!isLoggedIn) {
            alert('로그인 후 이용해주세요.');
            return;
        } else if (!selectedDetail) {
            alert('옵션을 선택해주세요.');
            return;
        }
        // navigate('/checkout');

        // 선택된 상품 옵션과 수량을 Checkout 페이지로 전달
        navigate('/checkout', {
            state: {
                items: [{
                    root: 'detail',
                    detailId: selectedDetail.detailId,
                    clothes: clothes,
                    imgUrl: imgUrls.filter(item => item.order === 1)[0]?.imageUrl,
                    selectedDetail: selectedDetail,
                    quantity: quantity,
                }]
            }
        });
    };

    // 최근 본 상품 추가
    // useEffect(() => {
    //     let a = JSON.parse(localStorage.getItem('watched'))
    //     a.push(selectedShoes.id)
    //     a = new Set(a)
    //     a = Array.from(a)
    //     localStorage.setItem('watched', JSON.stringify(a))

    //     setTimeout(() => { setEventAlert(false) }, 2000)

    //     let t = setTimeout(() => { setFade1('end') }, 100)
    //     return () => {
    //         clearTimeout(t)
    //         setFade1('')
    //     }
    // }, [])


    // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
    useEffect(() => {
        if (!isLoggedIn || !userInfo) {
            return; // 로그인 상태나 sellerInfo가 유효하지 않은 경우 early return을 사용
        }

        axios.get(`${process.env.REACT_APP_API_URL}/cart/${userInfo.email_id}`)
            .then(result => {
                dispatch(setCartItems(result.data));
            })
            .catch(error => {
                console.log('장바구니 데이터 불러오기 실패', error);
            })
    }, [isLoggedIn, userInfo]);



    return (
        // <div className={"container start " + fade1}>
        <div>
            <br></br>
            <Container>
                <Row>
                    <Col md={6} xs={12}>
                        {/* <img src={imgUrls.length > 0 ? imgUrls[0].imageUrl : ''} width="100%" /> */}
                        {/* 추후 캐러셀로 변경 예정 */}
                        <Carousel>
                            {
                                imgUrls.map((img, index) => (
                                    <Carousel.Item interval={null} key={index} style={{ height: '500px' }} >
                                        <img
                                            src={img.imageUrl}
                                            alt={`Slide ${index + 1}`}
                                            style={{ width: '100%', height: '500px', objectFit: 'cover' }}
                                        />
                                    </Carousel.Item>
                                ))
                            }
                        </Carousel>
                    </Col>
                    <Col md={6} xs={12} style={{ textAlign: 'left' }}>
                        {/* <div className="pt-5" style={{ fontSize: '25px', fontWeight: '700', marginBottom: '15px' }}>{clothes.name ? clothes.name : '로딩 중...'}</div> */}
                        <div className="pt-5" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                            <div style={{ fontSize: '25px', fontWeight: '700', marginBottom: '15px' }}>
                                {clothes.name ? clothes.name : '로딩 중...'}
                            </div>
                            <HeartButton
                                onClick={toggleLike}
                                isLiked={isLiked}
                                likeCount={likeCount}>
                                <FaHeart />
                                <span>{likeCount > 999 ? '999+' : likeCount}</span>
                            </HeartButton>
                            {/* <HeartButton onClick={toggleLike} isLiked={isLiked}>
                                <FaHeart />
                                <span>{likeCount > 999 ? '999+' : likeCount}</span>
                            </HeartButton> */}
                        </div>

                        {/* <p>{clothes.detail ? clothes.detail : '상세 정보 로딩 중...'}</p> */}
                        <p style={{ fontSize: '22px', fontWeight: '700' }}>{clothes.price ? `${clothes.price}원` : '가격 로딩 중...'}</p>

                        <Dropdown onSelect={(eventKey) => {
                            const selectedDetail = details.find(detail => detail.detailId === parseInt(eventKey, 10));
                            setSelectedDetail(selectedDetail);  // 선택된 상세 정보를 상태로 저장
                            console.log('Selected detail:', selectedDetail);
                        }}>
                            <StyledDropdownToggle variant="outline-secondary" id="dropdown-basic">
                                {selectedDetail ? `${selectedDetail.color} / ${selectedDetail.size}` : "선택하세요"}
                            </StyledDropdownToggle>
                            <StyledDropdownMenu>
                                {details.map((detail, index) => (
                                    <Dropdown.Item key={index} eventKey={detail.detailId}>
                                        {detail.color} / {detail.size}
                                    </Dropdown.Item>
                                ))}
                            </StyledDropdownMenu>
                        </Dropdown>

                        <Row style={{ marginTop: '10px' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                                <div>
                                    <InputGroup className="mb-3">
                                        <Button variant="outline-secondary" onClick={() => setQuantity(Math.max(1, quantity - 1))}>-</Button>
                                        <Form.Control
                                            value={quantity}
                                            onChange={e => setQuantity(Math.max(1, parseInt(e.target.value) || 1))}
                                            type="text"
                                            style={{ width: '50px', textAlign: 'center' }} // 너비 조정 필요
                                            onKeyPress={e => {
                                                if (!/[0-9]/.test(e.key)) {
                                                    e.preventDefault();
                                                }
                                            }}
                                        />
                                        <Button variant="outline-secondary" onClick={() => setQuantity(quantity + 1)}>+</Button>
                                    </InputGroup>
                                </div>
                                <div style={{ fontSize: '22px', fontWeight: '700', textAlign: 'right', marginBottom: '15px' }}>
                                    {clothes.price * quantity} 원
                                </div>
                            </div>
                            {/* <Col md={4} xs={4}>
                                <InputGroup className="mb-3">
                                    <Button variant="outline-secondary" onClick={() => setQuantity(Math.max(1, quantity - 1))}>-</Button>
                                    <Form.Control
                                        value={quantity}
                                        onChange={e => setQuantity(Math.max(1, parseInt(e.target.value) || 1))}
                                        type="text"
                                        style={{ width: '15px' }}
                                        onKeyPress={e => { // 숫자만 입력하도록 처리
                                            if (!/[0-9]/.test(e.key)) {
                                                e.preventDefault();
                                            }
                                        }}
                                    />
                                    <Button variant="outline-secondary" onClick={() => setQuantity(quantity + 1)}>+</Button>
                                </InputGroup>
                            </Col>
                            <Col md={8} xs={8} style={{ fontSize: '22px', fontWeight: '700', textAlign: 'right' }}>
                                {clothes.price * quantity} 원
                            </Col> */}
                        </Row>
                        <Row>
                            <Col md={6} xs={6}>
                                <Button
                                    variant="light"
                                    onClick={handleAddToCart}
                                    style={{
                                        width: '100%',
                                        borderColor: '#007bff',  // Bootstrap의 기본 'primary' 색상
                                        borderWidth: '1px',
                                        borderStyle: 'solid',
                                        color: '#007bff',
                                        fontWeight: '700',
                                        height: '42px'
                                    }}
                                >
                                    장바구니
                                </Button>
                            </Col>
                            <Col md={6} xs={6}>
                                <Button variant="primary" onClick={handleBuyNow} style={{ width: '100%', fontWeight: '700', height: '42px' }}>바로구매</Button>
                            </Col>
                        </Row>
                    </Col>
                </Row>

                {/* <button onClick={() => {
                    setLikeCount(999);
                }}>SETLIKECOUNT 999</button>
                <button onClick={() => {
                    setLikeCount(1000);
                }}>SETLIKECOUNT 1000</button> */}

                <Row>
                    <Col>
                        <Nav variant="tabs" defaultActiveKey="link0" className="mt-3">
                            <Nav.Item>
                                <Nav.Link eventKey="link0" onClick={() => { setTab(0) }}>상품 정보</Nav.Link>
                            </Nav.Item>
                            <Nav.Item>
                                <Nav.Link eventKey="link1" onClick={() => { setTab(1) }}>판매자 정보</Nav.Link>
                            </Nav.Item>
                            <Nav.Item>
                                <Nav.Link eventKey="link2" onClick={() => { setTab(2) }}>상품 리뷰</Nav.Link>
                            </Nav.Item>
                        </Nav>
                        <TabContent tab={tab} imgUrls={imgUrls} clothesId={clothesId} />
                    </Col>
                </Row>
            </Container>
        </div>
    )
}


function TabContent({ tab, imgUrls, clothesId }) {

    let [fade2, setFade2] = useState('')
    useEffect(() => {
        let a = setTimeout(() => { setFade2('end') }, 100)

        return () => {
            clearTimeout(a)
            setFade2('')
        }
    }, [tab])

    // Function to render images vertically
    const renderImages = () => {
        return imgUrls.map((img, index) => (
            <Row>
                <Col md={{ offset: 2, span: 8 }} xs={12}>
                    <img key={index} src={img.imageUrl} alt={`Clothes Image ${index + 1}`}
                        style={{ width: '100%', marginBottom: '10px', display: 'block', marginLeft: 'auto', marginRight: 'auto' }}
                    loading='lazy'/>
                </Col>
            </Row >

        ));
    };

    return (
        <div className={"start " + fade2}>
            {[
                <div>{renderImages()}</div>,
                <div>내용1</div>,
                <CommentsSection clothesId={clothesId} />
            ][tab]}
        </div>
    )
}



function CommentsSection({ clothesId }) {
    const { userInfo, isLoggedIn } = useSelector((state) => state.user);

    const [comments, setComments] = useState([]);
    const [commentText, setCommentText] = useState('');

    useEffect(() => {
        axios.get(`${process.env.REACT_APP_API_URL}/comment/clothes/${clothesId}`)
            .then(response => {
                setComments(response.data);
            })
            .catch(error => console.error("댓글 로딩 실패", error));
    }, []);

    const submitComment = () => {
        if (!isLoggedIn) return;

        const newComment = {
            customerEmail: userInfo.email_id,
            comment: commentText,
            clothesId
        };

        axios.post(`${process.env.REACT_APP_API_URL}/comment`, newComment)
            .then(() => {
                setComments([...comments, newComment]);  // 선택적으로 댓글을 다시 가져올 수도 있습니다
                setCommentText('');
            })
            .catch(error => console.error("댓글 게시 실패", error));
    };

    return (
        <div>
            <Container>
                <Row>
                    <Col md={10} xs={12} style={{ marginTop: '10px' }}>
                        <FloatingLabel controlId="floatingTextarea2" label={isLoggedIn ? "상품 리뷰 작성하기" : "로그인 후 작성해주세요."}>
                            <Form.Control
                                as="textarea"
                                placeholder="Leave a comment here"
                                style={{ height: '80px' }}
                                value={commentText}
                                onChange={(e) => setCommentText(e.target.value)}
                                disabled={!isLoggedIn}
                            />
                        </FloatingLabel>
                    </Col>
                    <Col md={2} xs={12}>
                        <button onClick={submitComment} className="btn btn-primary mt-2" style={{ fontSize: '16px', fontWeight: '700', width: '100%', height: '100%' }}>리뷰 작성 완료</button>
                    </Col>
                </Row>
                <br></br>

                {comments.map((comment, index) => (
                    <Row key={index}>
                        <p style={{ textAlign: 'left', fontSize: '18px', fontWeight: '700' }}>{comment.customerEmail}</p>
                        <p style={{ textAlign: 'left' }}>{comment.comment}</p>
                        <div style={{ height: '1px', backgroundColor: 'gray', marginBottom: '5px' }}></div>
                    </Row>
                ))}
            </Container>
        </div >
    );
}



export default Detail;