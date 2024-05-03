import Image from 'react-bootstrap/Image';
import Button from 'react-bootstrap/Button';
import axios from 'axios';
import { useEffect, useState } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';


function Mypage(props) {

  let dispatch = useDispatch();
  let navigate = useNavigate();
  let location = useLocation();
  let { userInfo, isLoggedIn, isPwConfirm, isLoading } = useSelector((state) => state.user);
  // let [currentPage, setCurrentPage] = useState('주문/배송 조회'); // 초기 페이지 설정


  // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
  // useEffect(() => {
  //   if (!isLoggedIn || !userInfo) {
  //     return; // 로그인 상태나 sellerInfo가 유효하지 않은 경우 early return을 사용
  //   }
  //   if (!isLoggedIn || !userInfo) {
  //     alert('로그인 후 이용해주세요.');
  //     navigate('/login'); // 로그인 페이지로 리디렉션
  //   }
  // }, [isLoggedIn, userInfo, navigate]);


  // useEffect(() => {
  //   if (!isLoggedIn) {
  //     alert('로그인 후 이용해주세요.');
  //     navigate('/login'); // 로그인 페이지로 리디렉션
  //   }
  // }, [isLoggedIn, navigate]);

  useEffect(() => {
    if (!isLoading && !isLoggedIn) {
      alert('로그인 후 이용해주세요.');
      navigate('/login');
    }
  }, [isLoggedIn, isLoading, navigate]);



  // mypage 루트에 접속했을 때만 OrderDeliveryStatus로 리디렉션
  useEffect(() => {
    if (location.pathname === '/mypage') {
      navigate('/mypage/orderdeliverystatus');
    }
  }, [navigate, location.pathname]);

  return (
    <div>
      <br /> <br />
      <Container>
        <Row>
          <Col md={2} xs={12}>
            <ListGroup className="mt-md-5 pt-md-5" style={{ marginBottom: '20px' }}>
              <ListGroup.Item action onClick={() => {
                navigate('/mypage/orderdeliverystatus')
                // setCurrentPage('주문/배송 조회')
              }}>
                주문/배송 조회
              </ListGroup.Item>
              <ListGroup.Item action onClick={() => {
                if (isPwConfirm) {
                  navigate('/mypage/updateCustomer');
                  // setCurrentPage('회원정보 수정'); // 비밀번호 확인이 완료된 경우만 페이지 제목 업데이트
                } else {
                  navigate('/mypage/pwconfirm');
                  // setCurrentPage('비밀번호 확인'); // 비밀번호 확인이 필요한 경우 페이지 제목 업데이트
                }
              }}>
                회원정보 수정
              </ListGroup.Item>

              <ListGroup.Item action onClick={() => {
                navigate('/mypage/deleteCustomer')
                // setCurrentPage('회원 탈퇴')
              }} style={{ color: 'red' }}>
                회원 탈퇴
              </ListGroup.Item>
            </ListGroup>
          </Col>

          <Col md={10} xs={12}>
            <Outlet></Outlet>
          </Col>

        </Row>

        {/* <Row>
          <Col>
            <h1 style={{ fontSize: '30px', fontWeight: '700' }}>{currentPage}</h1>
            <br /><br />
          </Col>
        </Row>
        <Row>
          <Col xs={12} md={2}>
            <ListGroup style={{ marginBottom: '20px' }}>
              <ListGroup.Item action onClick={() => {
                navigate('/mypage/orderdeliverystatus')
                setCurrentPage('주문/배송 조회')
              }}>
                주문/배송 조회
              </ListGroup.Item>
              <ListGroup.Item action onClick={() => {
                if (isPwConfirm) {
                  navigate('/mypage/updateCustomer');
                  setCurrentPage('회원정보 수정'); // 비밀번호 확인이 완료된 경우만 페이지 제목 업데이트
                } else {
                  navigate('/mypage/pwconfirm');
                  setCurrentPage('비밀번호 확인'); // 비밀번호 확인이 필요한 경우 페이지 제목 업데이트
                }
              }}>
                회원정보 수정
              </ListGroup.Item>

              <ListGroup.Item action onClick={() => {
                navigate('/mypage/deleteCustomer')
                setCurrentPage('회원 탈퇴')
              }} style={{ color: 'red' }}>
                회원 탈퇴
              </ListGroup.Item>
            </ListGroup>
            <div style={{ height: '2px', backgroundColor: 'gray', marginBottom: '20px' }}></div>
          </Col>
          <Col xs={12} md={10}>
            <Outlet />
          </Col>
        </Row> */}
      </Container>
    </div>
  )
}

export default Mypage;