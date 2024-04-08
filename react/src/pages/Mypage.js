import Image from 'react-bootstrap/Image';
import Button from 'react-bootstrap/Button';
import axios from 'axios';
import { useEffect, useState } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import { Outlet, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';


function Mypage(props) {

  let [userData, setUserData] = useState('호날두');

  let dispatch = useDispatch()
  let navigate = useNavigate();
  let { userInfo, isLoggedIn } = useSelector((state) => state.user);
  let [currentPage, setCurrentPage] = useState('마이페이지');


  // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
  useEffect(() => {
    if (!isLoggedIn) {
      // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
      alert('로그인 후 이용해주세요.')
      navigate('/login');
    }
  });

  return (
    <div>

      <br /> <br />
      {/* <hr style={{ border: '0', height: '2px', backgroundColor: '#333'}} /> */}

      <Container>
        <Row>
          <Col><h1 style={{ fontSize: '30px', fontWeight: '700' }}>{currentPage}</h1>
            <br /><br /></Col>
        </Row>
        <Row>
          <Col xs={2} md={2}>
            {/* <table style={{border:'none', fontSize: '18px', fontWeight: '500' }}>
                  <tr>
                    <td>주문/배송 조회</td>
                  </tr>
                  <tr>
                  <td>회원정보 수정</td>
                  </tr>
                  <tr>
                    <td>회원 탈퇴</td>
                  </tr>
                </table> */}
            <ListGroup >
            {/* defaultActiveKey="#link1" */}
              <ListGroup.Item action onClick={() => {
                navigate('/Mypage/orderDeliveryStatus')
                setCurrentPage('주문/배송 조회')
              }}
                href="#link1">
                주문/배송 조회
              </ListGroup.Item>
              <ListGroup.Item action onClick={() => {
                navigate('/mypage/updateCustomer')
                setCurrentPage('회원정보 수정')
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


          </Col>
          <Col xs={10} md={10}>
            {/* <Image src={process.env.PUBLIC_URL + '/img/ronaldo.jpg'} style={{ width: '170px', height: '170px', borderRadius: '50%' }} roundedCircle />
                  <h1 style={{ fontSize: '20px', fontWeight: '500' }}>홍길동 님<br /> qwer@hansung.ac.kr</h1>
                  <br />
                  <h1 style={{ fontSize: '20px', fontWeight: '500' }}>첫 구매하고 포인트 받으세요!</h1>

                  <br />
                  <Button variant="primary">회원정보 수정</Button>{' '}
                  <Button variant="danger">회원탈퇴</Button>{' '} */}
            <Outlet></Outlet>
          </Col>
        </Row>
      </Container>

    </div>
  )
}

export default Mypage;