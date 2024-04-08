import axios from "axios";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { logout, pwConfirm } from "../store/userSlice";
import { Container, Row, Col, Form, Button } from 'react-bootstrap';


function PwConfirm(props) {

    let dispatch = useDispatch();
    let { userInfo, isLoggedIn } = useSelector((state) => state.user);

    let navigate = useNavigate();

    let [ pw, setPw ] = useState('');

    let handlePwChange = (e) => {
        setPw(e.target.value);
    }

    let onClickPwConfirm = () => {
        axios.get(`http://localhost:8080/customers/${userInfo.email_id}/${pw}`)
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

    useEffect(() => {
        const handleEnterPress = (event) => {
          if (event.key === 'Enter') {
            event.preventDefault(); // 폼 제출 기본 이벤트 방지
            onClickPwConfirm();
          }
        };
      
        document.addEventListener('keydown', handleEnterPress);
        return () => {
          document.removeEventListener('keydown', handleEnterPress);
        };
      }, [onClickPwConfirm]);
      
    return (
        <div>
            <div style={{ fontSize: '15px', fontWeight: '500', textAlign: 'left' }}>
                회원님은 현재 {userInfo != null ? userInfo.email_id : ''}로 로그인하셨습니다.<br></br>
                개인정보보호를 위해 비밀번호를 입력해주세요.

                <Form>
                    <Form.Group className="mb-3 text-start" controlId="formBasicEmail">
                        <Form.Control type="password" name="pwConfirm" value={pw} onChange={handlePwChange} controlId="formPw"
                            placeholder="비밀번호를 입력하세요."
                        />
                    </Form.Group>

                    <Button onClick={onClickPwConfirm} variant="primary" className='login-Button'>
                        {/* type="submit"  */}
                        비밀번호 확인
                    </Button>
                </Form>
            </div>
        </div>
    )
}

export default PwConfirm;