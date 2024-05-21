import axios from "axios";
import { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { logout } from "../store/userSlice";
import { Col, Container, Row } from "react-bootstrap";
import styled from 'styled-components';



let StyledButton = styled.button`
  background-color: #d9534f; /* 주의를 요하는 빨간색으로 변경 */
  color: #fff; /* 흰색 텍스트 */
  border: none; /* 테두리 없음 */
  padding: 10px 20px; /* 내부 여백 조정 */
  width: 100%; /* 부모 컨테이너의 가로길이에 맞춤 */
  height: 50px;
  font-size: 1rem; /* 글자 크기 */
  font-weight: bold; /* 글자 굵기 */
  cursor: pointer; /* 마우스 오버시 커서 변경 */
  transition: background-color 0.3s ease, box-shadow 0.3s ease; /* 호버 효과를 위한 전환 */
  &:hover {
    background-color: #c9302c; /* 호버시 더 진한 빨간색으로 변경 */
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.5); /* 호버시 그림자 추가 */
  }
`;

function DeleteCustomer(props) {

    let dispatch = useDispatch();
    let { userInfo, isLoggedIn } = useSelector((state) => state.user);

    let navigate = useNavigate();

    let deleteCustClicked = () => {
        axios.delete(`${process.env.REACT_APP_API_URL}/customers/${userInfo.email_id}`)
            .then((result) => {
                dispatch(logout());
                console.log('회원탈퇴 성공');
                alert('회원탈퇴 성공');
                navigate('/');
            })
            .catch((error) => {
                console.error('회원탈퇴 실패', error);
            })
    }

    // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
    useEffect(() => {
        if (!isLoggedIn || !userInfo) {
            return; 
        }
        if (!isLoggedIn) {
            // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
            alert('로그인 후 이용해주세요.')
            navigate('/login');
        }
    }, [isLoggedIn, userInfo]);

    return (
        <Container>
            <Row>
                <Col md={{ span: 8, offset: 1 }} xs={12}>
                    <h1 style={{ fontSize: '30px', fontWeight: '700' }}>회원 탈퇴</h1>
                    <br /><br />
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 8, offset: 1 }} xs={12}>
                <div>
                    <div style={{ fontSize: '15px', fontWeight: '500', textAlign: 'center' }}>
                        <strong>
                        회원님은 현재 {userInfo != null ? userInfo.email_id : ''}로 로그인하셨습니다.<br></br>
                        정말로 회원 탈퇴하시겠습니까?</strong>
                    </div>
                </div>
                </Col>
            </Row>


            <Row style={{ marginTop: '50px' }}>
                <Col md={{ span: 3, offset: 2 }} xs={6}>
                    <StyledButton style={{ background: '#808080' }} onClick={() => window.history.back()}><div style={{ whiteSpace: 'nowrap' }}>뒤로가기</div></StyledButton>
                </Col>
                <Col md={{ span: 3 }} xs={6}>
                    <StyledButton onClick={deleteCustClicked} ><div style={{ whiteSpace: 'nowrap' }}>회원탈퇴</div></StyledButton>
                </Col>
            </Row>
            <br></br>
        </Container>
    )
}

export default DeleteCustomer;