import { Button, Navbar, Container, Nav, Row, Col, Form } from 'react-bootstrap';
import '../App.css';
import { useNavigate, Outlet } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons';
import { logout } from "../store/userSlice.js";
import { FaShoppingCart } from 'react-icons/fa';
import { FaUser } from "react-icons/fa";
import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import styled from 'styled-components';
import axios from 'axios';
import { setCartItems } from '../store/cartSlice.js';
import { FaHeart } from 'react-icons/fa6';



// 스타일링된 컨테이너 정의
const CartIconContainer = styled.div`
  position: relative;
  display: inline-block;
`;

// 스타일링된 숫자 표시 정의
const CartItemCount = styled.span`
  position: absolute;
  top: -8px; // 숫자의 위치를 조정하세요
  right: -24px; // 숫자의 위치를 조정하세요
  background-color: #000000; // 배경색은 원하는 대로 설정
  color: #ffffff; // 숫자 색상
  font-size: 14px; // 숫자 크기
  font-weight: 500;
  padding: 0px 15px; // 안쪽 여백
  border-radius: 50%; // 원형 모양
  display: flex;
  justify-content: center;
  align-items: center;
`;

const BrandLogo = styled.img`
  max-height: 28px;
  content: ${props => `url(${props.logo})`};
`;

function UserLayout(props) {

    const dispatch = useDispatch();

    let navigate = useNavigate();

    let { userInfo, isLoggedIn } = useSelector((state) => state.user);
    let cartItems = useSelector((state) => state.cart.items);

    const [logo, setLogo] = useState(`${process.env.PUBLIC_URL}/img/logo1.png`);

    useEffect(() => {
        const handleResize = () => {
            if (window.innerWidth <= 768) {
                setLogo(`${process.env.PUBLIC_URL}/img/logo3.png`);
            } else {
                setLogo(`${process.env.PUBLIC_URL}/img/logo1.png`);
            }
        };

        window.addEventListener('resize', handleResize);
        handleResize(); // Call it initially to set the right logo

        return () => {
            window.removeEventListener('resize', handleResize);
        };
    }, []);

    let handleSearch = (e) => {
        e.preventDefault();
        const searchQuery = e.target.elements.search.value; // Assuming the input field's name is 'search'
        if (searchQuery.trim()) {
            navigate(`/search/${searchQuery}`);
        }
    };

    // 장바구니 데이터 불러오기 (장바구니 개수)
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
        <div className="App" >

            <div className="App" style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
                <div className="content" style={{ flex: 1 }}>

                    <Navbar bg="light" data-bs-theme="light" >
                        <Container>

                            <Navbar.Brand onClick={() => navigate('/')} style={{ fontSize: '24px', fontWeight: '700', color: '#1263CE', cursor: 'pointer' }}>
                                <BrandLogo logo={logo} alt="logo" />
                            </Navbar.Brand>
                            <Form className="search-form d-flex flex-grow-1" onSubmit={handleSearch}>
                                <Form.Control
                                    type="search"
                                    placeholder="검색어를 입력하세요"
                                    className="search-input me-2"
                                    aria-label="Search"
                                    name="search"  // Name attribute to easily retrieve the input value
                                />

                                <Button type="submit" typevariant="outline-success" className="search-button">
                                    <FontAwesomeIcon icon={faMagnifyingGlass} />
                                </Button>
                            </Form>
                            <Nav className="ms-auto">
                                        <Nav.Link style={{ marginRight: '5px' }} onClick={() => {
                                    if (isLoggedIn) {
                                        navigate('/likespage')
                                    } else {
                                        alert('로그인 후 이용해주세요.');
                                        navigate('/login');
                                    }
                                }}>
                                    <FaHeart size={24} />
                                </Nav.Link>


                                <Nav.Link style={{ marginRight: '5px' }} onClick={() => {
                                    if (isLoggedIn) {
                                        navigate('/cart')
                                    } else {
                                        alert('로그인 후 이용해주세요.');
                                        navigate('/login');
                                    }
                                }}>

                                    <CartIconContainer>
                                        <FaShoppingCart size={24} />
                                        <CartItemCount>{cartItems.length}</CartItemCount>
                                    </CartIconContainer>

                                    {/* <BsCart2 /> */}
                                </Nav.Link>
                                <Nav.Link style={{ marginRight: '20px' }} onClick={() => {
                                    if (isLoggedIn) {
                                        navigate('/mypage/orderdeliverystatus')
                                    } else {
                                        alert('로그인 후 이용해주세요.');
                                        navigate('/login');
                                    }
                                }}>
                                    <FaUser size={24} />


                                </Nav.Link>
                            </Nav>

                        </Container>
                    </Navbar>

                    <Navbar bg="dark" data-bs-theme="dark" >
                        <Container>
                            <Row className="w-100">
                                <Col xs={8} md={8}>
                                    <Nav className="me-auto">
                                        <Nav.Link onClick={() => { navigate('/itemlist/male') }}>남성 의류</Nav.Link>
                                        <Nav.Link onClick={() => { navigate('/itemlist/female') }}>여성 의류</Nav.Link>
                                    </Nav>
                                </Col>
                                <Col xs={4} md={4} className="d-flex justify-content-end">
                                    <Nav className="ms-auto">
                                        {isLoggedIn ?
                                            <Nav.Link onClick={() => {
                                                localStorage.removeItem('userIsLoggedIn');
                                                localStorage.removeItem('userLoginTime');
                                                localStorage.removeItem('userData');
                                                dispatch(logout());
                                                alert('로그아웃되었습니다.');
                                                navigate('/');
                                            }} className="text-nowrap">로그아웃</Nav.Link> :
                                            <Nav.Link onClick={() => { navigate('/login') }} className="text-nowrap">로그인</Nav.Link>}
                                        {isLoggedIn ?
                                            null :
                                            <Nav.Link onClick={() => { navigate('/join') }} className="text-nowrap">회원가입</Nav.Link>
                                        }

                                    </Nav>
                                </Col>
                            </Row>
                        </Container>
                    </Navbar>



                    <Outlet></Outlet>
                    <RecentItems></RecentItems>
                </div>
                <Navbar bg="light" data-bs-theme="light" style={{ width: '100%' }}>
                    <Container>
                        <Nav className="me-auto">
                            <Nav.Link href="/seller/productlist" style={{ fontWeight: '700' }}>판매자 페이지</Nav.Link>
                        </Nav>
                    </Container>
                </Navbar>
            </div>

        </div>
    )
}

function RecentItems() {
    const [recentItems, setRecentItems] = useState([]);
    const navigate = useNavigate();

    useEffect(() => {
        const handleUpdate = () => {
            let watchedItems = JSON.parse(sessionStorage.getItem('watched') || '[]');
            // 최근 본 상품이 3개를 초과할 경우 가장 오래된 것부터 제거
            if (watchedItems.length > 3) {
                watchedItems = watchedItems.slice(-3); // 가장 최근 3개만 유지
            }
            setRecentItems(watchedItems);
        };

        window.addEventListener('recent-items-updated', handleUpdate);

        // 초기 로드 시 항목 설정
        handleUpdate();

        return () => {
            window.removeEventListener('recent-items-updated', handleUpdate);
        };
    }, []);

    if (recentItems.length === 0) {
        return <p></p>;
    }

    return (
        <div className="col-md-3 recent-items">
            <div style={{ whiteSpace: 'nowrap', marginBottom: '5px' }}>최근 본 상품</div>
            {recentItems.map((item, index) => (
                <div key={index}>
                    <img src={item.imageUrl} alt={`상품 ${item.id}`} style={{ width: '100%', cursor: 'pointer' }}
                        onClick={() => navigate(`/detail/${item.id}`)} />
                </div>
            ))}
        </div>
    );
}


export default UserLayout;