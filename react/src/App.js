import { lazy, Suspense, useEffect, useState } from "react";
import { Button, Navbar, Container, Nav, Row, Col, Form, FormControl } from 'react-bootstrap';
import './App.css';
import { Routes, Route, useNavigate, Outlet, Link } from 'react-router-dom';
import axios from 'axios'
import { useQuery } from "react-query";
import Main from "./pages/Main.js";
import ItemList from "./pages/ItemList.js";
import Login from "./pages/Login.js";
import Join from "./pages/Join.js";
import Mypage from "./pages/Mypage.js";
import About from "./pages/About.js";
import ProductRegistration from "./pages/ProductRegistration.js";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSearch, faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons';
import DeleteCustomer from "./pages/DeleteCustomer.js";
import { useDispatch, useSelector } from "react-redux";
import { logout } from "./store/userSlice.js";
import Badge from 'react-bootstrap/Badge';
import { FaShoppingCart } from 'react-icons/fa';
import { BsCart2 } from "react-icons/bs";
import { FaUser } from "react-icons/fa";
import styled from 'styled-components';
import ProductEdit from "./pages/ProductEdit.js";
import UpdateCustomer from "./pages/UpdateCustomer.js";
import PwConfirm from "./pages/PwConfirm.js";



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
  background-color: #1263CE; // 배경색은 원하는 대로 설정
  color: white; // 숫자 색상
  font-size: 14px; // 숫자 크기
  font-weight: 500;
  padding: 0px 15px; // 안쪽 여백
  border-radius: 50%; // 원형 모양
  display: flex;
  justify-content: center;
  align-items: center;
`;

const Cart = lazy(() => import('./pages/Cart.js'));
const Detail = lazy(() => import('./pages/Detail.js'));

function App() {

  // 최근 본 상품 초기화
  useEffect(() => {
    let a = JSON.parse(localStorage.getItem('watched'))

    if (a == null || a.length === 0) {
      localStorage.setItem('watched', JSON.stringify([]))
    }

  }, [])

  let recentItemId = JSON.parse(localStorage.getItem('watched'))


  let navigate = useNavigate();

  let dispatch = useDispatch();
  let { userInfo, isLoggedIn } = useSelector((state) => state.user);
  let cartItems = useSelector((state) => state.cart.items);

  let handleSearch = (e) => {
    // 검색 로직을 추가하기
    e.preventDefault();
    console.log('검색 버튼이 클릭되었습니다.');
  };

  return (
    <div className="App" >

      <Navbar bg="light" data-bs-theme="light" >
        <Container>
          <Navbar.Brand onClick={()=>navigate('/')} style={{ fontSize: '24px', fontWeight: '700', color:'#1263CE', cursor: 'pointer' }}>
            HS M<span style={{fontSize: '20px', fontWeight: '600'}}>all</span>
            </Navbar.Brand>
          <Form className="search-form d-flex flex-grow-1" onSubmit={handleSearch}>
            <Form.Control
              type="search"
              placeholder="검색어를 입력하세요"
              className="search-input me-2"
              aria-label="Search"
            />
            <Button type="submit" typevariant="outline-success" className="search-button">
              <FontAwesomeIcon icon={faMagnifyingGlass} />
            </Button>
          </Form>
          <Nav className="ms-auto">
            {/* <Nav.Link onClick={() => { navigate('/about') }}>회사정보</Nav.Link> */}
            {isLoggedIn ? (
              <Badge style={{ marginTop: '10px', marginBottom: '10px' }} bg="dark">{userInfo.email_id}님 환영합니다.</Badge>
              // <div>
              //   {userInfo.email_id}님 환영합니다.
              // </div>
            ) :
              <Badge style={{ marginTop: '10px', marginBottom: '10px' }} bg="dark">로그인하세요!</Badge>
              // <div>로그인하세요!</div>

            }

            <Nav.Link style={{marginRight:'5px'}} onClick={() => {
              if (isLoggedIn) {
                navigate('/cart')
              } else {
                alert('로그인 후 이용해주세요.');
                navigate('/login');
              }
            }}>
              {/* <FontAwesomeIcon icon={faCartShopping} /> */}
              
              <CartIconContainer>
                <FaShoppingCart size={24} />
                <CartItemCount>{cartItems.length}</CartItemCount>
              </CartIconContainer>
            
              {/* <BsCart2 /> */}
            </Nav.Link>
            <Nav.Link style={{marginRight:'20px'}} onClick={() => {
              if (isLoggedIn) {
                navigate('/mypage')
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

      {/* <Navbar bg="dark" data-bs-theme="dark">
        <Container>
          <Nav className="me-auto">
            <Nav.Link onClick={() => { navigate('/itemlist') }}>여성</Nav.Link>
            <Nav.Link onClick={() => { navigate('/itemlist') }}>남성</Nav.Link>
            <Nav.Link onClick={() => { navigate('/itemlist') }}>키즈</Nav.Link>
            <Nav.Link onClick={() => { navigate('/itemlist') }}>슈즈</Nav.Link>
          </Nav>
          <Nav className="ms-auto">
            <Nav.Link onClick={() => { navigate('/login') }}>로그인</Nav.Link>
            <Nav.Link onClick={() => { navigate('/join') }}>회원가입</Nav.Link>
          </Nav>
        </Container>
      </Navbar>


      <div style={{ color: 'gray', display: 'flex', alignItems: 'center', margin: '10px 130px' }}>
        <Link to="/" style={{ color: 'gray', textDecoration: 'none', marginRight: '5px' }}>홈</Link>
        <span>&gt;</span>
        <Link to="/detail" style={{ color: 'gray', textDecoration: 'none', margin: '0 5px' }}>여성</Link>
        <span>&gt;</span>
        <Link to="/detail" style={{ color: 'gray', textDecoration: 'none', margin: '0 5px' }}>티셔츠</Link>
      </div> */}

      <Navbar bg="dark" data-bs-theme="dark" >
        <Container>
          <Row className="w-100">
            <Col xs={8} md={8}>
              <Nav className="me-auto">
                <Nav.Link onClick={() => { navigate('/itemlist') }}>여성</Nav.Link>
                <Nav.Link onClick={() => { navigate('/itemlist') }}>남성</Nav.Link>
                <Nav.Link onClick={() => { navigate('/itemlist') }}>키즈</Nav.Link>
                <Nav.Link onClick={() => { navigate('/itemlist') }}>슈즈</Nav.Link>
              </Nav>
            </Col>
            <Col xs={4} md={4} className="d-flex justify-content-end">
              <Nav className="ms-auto">
                {isLoggedIn ?
                  <Nav.Link onClick={() => {
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






      <Suspense fallback={<div>로딩중.......</div>}>
        <Routes>
          <Route path="/" element={<Main />} />
          <Route path="/detail/:id" element={<Detail />} />
          <Route path="*" element={<div>없는 페이지입니다.</div>} />
          <Route path="/about" element={<About />} >
            <Route path="member" element={<div> 멤버 페이지입니다. </div>} />
            <Route path="location" element={<div> 위치정보 페이지입니다. </div>} />
          </Route>
          <Route path="itemlist" element={<ItemList />} />
          <Route path="/cart" element={<Cart />} />
          <Route path="/login" element={<Login />} />
          <Route path="/Join" element={<Join />} />
          <Route path="/ProductRegistration" element={<ProductRegistration />} />
          <Route path="/ProductEdit" element={<ProductEdit />} />
          <Route path="/mypage" element={<Mypage />} >
            <Route path="deleteCustomer" element={<DeleteCustomer />} />
            <Route path="updateCustomer" element={<UpdateCustomer />} />
            <Route path="PwConfirm" element={<PwConfirm />} />
          </Route>
        </Routes>
      </Suspense>

      {/* <div className="col-md-3 recent-items">
        <h5>최근 본 상품</h5>
        {recentItemId && recentItemId.length > 0 ? (
          <div>
            {recentItemId.map(function (a, i) {
              return (
                <div key={i}>
                  <img src={process.env.PUBLIC_URL + '/img/shoes' + (recentItemId[i] + 1) + '.jpg'} alt={`Shoe ${recentItemId[i] + 1}`} style={{ width: '100%', cursor: 'pointer' }}
                    onClick={() => {
                      navigate(`/detail/${recentItemId[i]}`)
                    }} />
                </div>
              );
            })}
          </div>
        ) : (
          <p>최근 본 상품이 없습니다.</p>
        )}
      </div> */}
    </div>
  );
}

// function About() {
//   return (
//     <div>
//       <h4>회사 정보 페이지입니다.</h4>
//       <Outlet></Outlet>
//     </div>
//   )
// }



export default App;
