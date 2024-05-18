import { Button, Col, Container, Nav, NavLink, Navbar, Row } from "react-bootstrap";
import styled from 'styled-components';
import { Outlet, useLocation, useNavigate } from "react-router-dom";
import { NavLink as ReactRouterNavLink } from 'react-router-dom';
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { sellerLogout } from "../store/sellerSlice";
import { FaShirt, FaCartShopping, FaChartPie, FaList, FaCircleUser } from "react-icons/fa6";


const StyledNavLink = styled(ReactRouterNavLink)`
  display: flex;
  justify-content: flex-start;  // 왼쪽 정렬
  align-items: center;
  margin: 10px 0;
  color: white;
  font-weight: 700;
  font-size: 18px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-decoration: none;

  &:hover {
    color: lightgray;
  }

  @media (max-width: 768px) {
    font-size: 16px;
  }

  svg {
    margin-right: 8px;
  }
`;


function SellerLayout(props) {

    const location = useLocation();
    let navigate = useNavigate();
    const [isOpen, setIsOpen] = useState(true);
    const [sidebarStyle, setSidebarStyle] = useState({ minHeight: '100vh' });

    let dispatch = useDispatch();
    let { sellerInfo, isLoggedIn } = useSelector((state) => state.seller);

    const toggleSidebar = () => setIsOpen(!isOpen);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if(isLoggedIn) {
            navigate('/seller/statisticsanalysis');
        }
    },[])

    useEffect(() => {
        function handleResize() {
            setIsOpen(window.innerWidth >= 768);
            if (window.innerWidth < 768) {
                setSidebarStyle({ minHeight: 'auto' });  // xs 사이즈에서 내용에 맞춰 높이 조정
            } else {
                setSidebarStyle({ minHeight: '100vh' });  // 그 외 사이즈에서는 전체 높이 유지
            }
        }

        // 이벤트 리스너 등록
        window.addEventListener('resize', handleResize);
        // 초기 실행
        handleResize();

        // 컴포넌트 언마운트 시 이벤트 리스너 제거
        return () => window.removeEventListener('resize', handleResize);
    }, []);


    useEffect(() => {

       if (!loading && !isLoggedIn && location.pathname !== '/seller/login' && location.pathname !== '/seller/sellerjoin') {
            navigate('/seller/login');
        }
    }, [loading, isLoggedIn, location.pathname, navigate]);

    return (
        <div>
            <div className="App" style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
                <div className="content" style={{ flex: 1 }}>

                    <Navbar bg="light" data-bs-theme="light" style={{ position:'fixed', width:'100%', zIndex: 1000 }} >
                        <Button style={{ background: '#343A40', marginLeft: '20px' }} onClick={toggleSidebar}>☰</Button>
                        <Navbar.Brand onClick={() => navigate('/seller/statisticsanalysis')} style={{ cursor: 'pointer', marginLeft: '10px' }}>
                            <img src={process.env.PUBLIC_URL + '/img/logo2.png'} style={{ height:'28px' }} alt="Logo"></img>
                        </Navbar.Brand>
                    </Navbar>

                    {/* <Container fluid style={{ paddingLeft: '0', paddingRight: '0' }}> */}
                    <Container style={{ maxWidth: '100%', paddingLeft: '0px', paddingRight: '15px' }}>
                        <Row>
                            <Col xs={isOpen ? 12 : 0} md={isOpen ? 2 : 0} className="sidebar" style={{ paddingTop: '56px', backgroundColor: '#343A40' }}>
                                <div style={{ display: isOpen ? 'block' : 'none' }}>
                                    <ul className="nav flex-column" style={{ backgroundColor: '#343A40', minHeight: '100vh', ...sidebarStyle, padding: '1rem' }}>
                                        <li className="nav-item">
                                            <StyledNavLink to="/seller/ordermanagement"><FaCartShopping /> 주문 관리</StyledNavLink>
                                        </li>
                                        <li className="nav-item">
                                            <StyledNavLink to="/seller/productregistration"><FaShirt /> 상품 등록</StyledNavLink>
                                        </li>
                                        <li className="nav-item">
                                            <StyledNavLink to="/seller/productlist"><FaList /> 상품 목록</StyledNavLink>
                                        </li>
                                        <li className="nav-item">
                                            <StyledNavLink to="/seller/statisticsanalysis"><FaChartPie /> 통계 분석</StyledNavLink>
                                        </li>
                                        <li className="nav-item">
                                            {isLoggedIn ? <StyledNavLink onClick={() => {
                                                localStorage.removeItem('sellerIsLoggedIn');
                                                localStorage.removeItem('sellerLoginTime');
                                                localStorage.removeItem('sellerData');
                                                dispatch(sellerLogout());
                                                alert('로그아웃되었습니다.');
                                            }}><FaCircleUser /> 로그아웃</StyledNavLink> : <StyledNavLink to="/seller/login"><FaCircleUser /> 로그인</StyledNavLink>}
                                        </li>
                                    </ul>
                                </div>
                            </Col>
                            <Col xs={12} md={isOpen ? 10 : 12} style={{ paddingTop: '56px' }}>
                                <Outlet></Outlet>
                            </Col>
                        </Row>
                    </Container>
                </div>


                <Navbar bg="light" data-bs-theme="light" style={{ width: '100%', zIndex: 1000 }}>
                    <Container>
                        <Nav className="me-auto">
                            <Nav.Link href="/" style={{ fontWeight: '700' }}>구매자 페이지</Nav.Link>
                        </Nav>
                    </Container>
                </Navbar>
            </div>
        </div>
    )
}

export default SellerLayout;