import axios from "axios";
import { useEffect, useState } from "react";
import Button from 'react-bootstrap/Button';
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { logout } from "../store/userSlice";
import { Col, Container, Row } from "react-bootstrap";


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
            return; // 로그인 상태나 sellerInfo가 유효하지 않은 경우 early return을 사용
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
                <div>
                    <div style={{ fontSize: '15px', fontWeight: '500', textAlign: 'left' }}>
                        회원님은 현재 {userInfo != null ? userInfo.email_id : ''}로 로그인하셨습니다.<br></br>
                        정말로 회원 탈퇴하시겠습니까?
                    </div>
                    <div style={{ textAlign: 'left' }}>
                        <Button variant="danger" onClick={deleteCustClicked}>회원탈퇴</Button>
                    </div>
                </div>
            </Row>
        </Container>
    )
}

export default DeleteCustomer;