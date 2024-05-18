import { useEffect } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useSelector } from 'react-redux';


function Mypage(props) {

  let navigate = useNavigate();
  let location = useLocation();
  let { userInfo, isLoggedIn, isPwConfirm, isLoading } = useSelector((state) => state.user);

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
              }}>
                주문/배송 조회
              </ListGroup.Item>
              <ListGroup.Item action onClick={() => {
                if (isPwConfirm) {
                  navigate('/mypage/updateCustomer');
                } else {
                  navigate('/mypage/pwconfirm');
                }
              }}>
                회원정보 수정
              </ListGroup.Item>
              <ListGroup.Item action onClick={() => {navigate('/mypage/comments')}}>
                작성댓글 확인
              </ListGroup.Item>
              <ListGroup.Item action onClick={() => {
                navigate('/mypage/deleteCustomer')
              }} style={{ color: 'red' }}>
                회원 탈퇴
              </ListGroup.Item>
            </ListGroup>
          </Col>

          <Col md={10} xs={12}>
            <Outlet></Outlet>
          </Col>

        </Row>

      </Container>
    </div>
  )
}

export default Mypage;