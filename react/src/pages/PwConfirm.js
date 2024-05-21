import axios from "axios";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { pwConfirm } from "../store/userSlice";
import { Container, Row, Col, Form, Button } from 'react-bootstrap';


function PwConfirm(props) {

    let dispatch = useDispatch();
    let { userInfo, isLoggedIn } = useSelector((state) => state.user);

    let navigate = useNavigate();

    let [pw, setPw] = useState('');

    let handlePwChange = (e) => {
        setPw(e.target.value);
    }

    let onClickPwConfirm = () => {
        axios.get(`${process.env.REACT_APP_API_URL}/customers/${userInfo.email_id}/${pw}`)
            .then((result) => {
                if (result.data == true) {

                    dispatch(pwConfirm());

                    alert('비밀번호 확인 완료');

                    navigate("/Mypage/UpdateCustomer");
                } else {
                    alert('비밀번호를 확인하세요.');
                }
            })
            .catch(() => {
                console.log('로그인 실패');
                alert('아이디를 확인하세요.');
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

    useEffect(() => {
        const handleEnterPress = (event) => {
            if (event.key === 'Enter') {
                event.preventDefault(); 
                onClickPwConfirm();
            }
        };

        document.addEventListener('keydown', handleEnterPress);
        return () => {
            document.removeEventListener('keydown', handleEnterPress);
        };
    }, [onClickPwConfirm]);

    return (
        <Container>
            <Row>
                <Col md={{ span: 8, offset: 1 }} xs={12}>
                    <h1 style={{ fontSize: '30px', fontWeight: '700' }}>비밀번호 확인</h1>
                    <br /><br />
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 8, offset: 1 }} xs={12}>

                    <div style={{ fontSize: '15px', fontWeight: '500', textAlign: 'left' }}>
                        <div style={{ marginBottom: '10px', textAlign: 'center' }}>
                            <strong>
                                회원님은 현재 {userInfo != null ? userInfo.email_id : ''}로 로그인하셨습니다.<br></br>
                                개인정보보호를 위해 비밀번호를 입력해주세요.</strong>
                        </div>
                        <Form>
                            <Form.Group className="mb-3 text-start" controlId="formBasicEmail">
                                <Form.Control type="password" name="pwConfirm" value={pw} onChange={handlePwChange} controlId="formPw"
                                    style={{ fontFamily: 'serif' }}
                                    placeholder="비밀번호를 입력하세요."
                                />
                            </Form.Group>

                            <Button onClick={onClickPwConfirm} variant="secondary" className='login-Button'>
                                비밀번호 확인
                            </Button>
                        </Form>

                    </div>
                </Col>
            </Row>
        </Container>
    )
}

export default PwConfirm;