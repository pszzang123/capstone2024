import axios from "axios";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { pwConfirmReset } from "../store/userSlice";
import { Form, Button, Container, Row, Col } from 'react-bootstrap';
import DaumPostcode from 'react-daum-postcode';
import Modal from 'react-bootstrap/Modal';

function UpdateCustomer(props) {

    let dispatch = useDispatch();
    let navigate = useNavigate();

    let { userInfo, isLoggedIn, isPwConfirm } = useSelector((state) => state.user);


    let [name, setName] = useState('');
    let [address, setAddress] = useState('');
    let [zoneCode, setZoneCode] = useState('');
    let [detailAddress, setDetailAddress] = useState('');
    let [showPostcode, setShowPostcode] = useState(false);
    let [phone1, setPhone1] = useState('');
    let [phone2, setPhone2] = useState('');
    let [phone3, setPhone3] = useState('');
    let [pw, setPw] = useState('');
    let [pwConfirm, setPwConfirm] = useState('');

    let [pwValid, setPwValid] = useState(false);
    let [pwConfirmValid, setPwConfirmValid] = useState(false);
    let [notAllow, setNotAllow] = useState(true);

    // 우편번호 검색 후 실행될 콜백 함수
    const handleComplete = (data) => {
        let fullAddress = data.address;
        let extraAddress = '';

        if (data.addressType === 'R') {
            if (data.bname !== '') {
                extraAddress += data.bname;
            }
            if (data.buildingName !== '') {
                extraAddress += (extraAddress !== '' ? `, ${data.buildingName}` : data.buildingName);
            }
            fullAddress += (extraAddress !== '' ? ` (${extraAddress})` : '');
        }

        setZoneCode(data.zonecode);
        setAddress(fullAddress);
        setDetailAddress('');
        setShowPostcode(false);
    };


    // 주소 검색 팝업을 띄우는 함수
    const handlePostcode = () => {
        setShowPostcode(true);
    };


    let handleName = (e) => {
        setName(e.target.value);
    }

    let handleAddress = (e) => {
        setAddress(e.target.value);
    }

    // 숫자만 입력을 허용하는 함수
    const handleNumericInput = (e, setterFunction) => {
        const value = e.target.value;
        // 숫자만 있는지 확인하는 정규식
        const numericOnly = value.replace(/[^0-9]/g, '');
        // 입력값이 숫자일 때만 상태를 업데이트
        setterFunction(numericOnly);
    };

    let handlePhone1Change = (e) => {
        // 변경된 로직으로 숫자만 입력받기
        handleNumericInput(e, setPhone1);
        if (e.target.value.length === 3) {
            document.getElementById('phone2').focus();
        }
    }

    let handlePhone2Change = (e) => {
        // 변경된 로직으로 숫자만 입력받기
        handleNumericInput(e, setPhone2);
        if (e.target.value.length === 4) {
            document.getElementById('phone3').focus();
        }
    }

    let handlePhone3Change = (e) => {
        // 변경된 로직으로 숫자만 입력받기
        handleNumericInput(e, setPhone3);
    }

    let handlePw = (e) => {
        setPw(e.target.value);
        let regex =
            /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+])(?!.*[^a-zA-z0-9$`~!@$!%*#^?&\\(\\)\-_=+]).{8,20}$/;
        if (regex.test(e.target.value)) {
            setPwValid(true);
        } else {
            setPwValid(false);
        }
    }

    let handlePwConfirm = (e) => {
        setPwConfirm(e.target.value);
    }

    let onClickConfirmButton = () => {
        axios.put(`${process.env.REACT_APP_API_URL}/customers/${userInfo.email_id}`, { streetAddress: address, detailAddress: detailAddress, zipCode: zoneCode, name: name, password: pw, phone: phone1 + '-' + phone2 + '-' + phone3 })
            .then((result) => {
                alert('회원정보 수정 완료');
                dispatch(pwConfirmReset());
                navigate("/")
            })
            .catch(() => {
                console.log('회원정보 수정 실패')
            })
    }

    // 비밀번호 확인을 하지 않은 상태라면 비밀번호 확인 페이지로 리디렉션
    useEffect(() => {
        if (!isLoggedIn || !userInfo) {
            return; 
        }
        if (!isLoggedIn) {
            // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
            alert('로그인 후 이용해주세요.')
            navigate('/login');
        }

        axios.get(`${process.env.REACT_APP_API_URL}/customers/${userInfo.email_id}`)
            .then(response => {
                const userData = response.data;
                setName(userData.name);
                setAddress(userData.streetAddress);
                setDetailAddress(userData.detailAddress);
                setZoneCode(userData.zipCode.toString());
                const phoneNumbers = userData.phone.split('-');
                setPhone1(phoneNumbers[0]);
                setPhone2(phoneNumbers[1]);
                setPhone3(phoneNumbers[2]);
            })
            .catch(error => {
                console.error("사용자 정보 불러오기 실패", error);
            });


    }, [isLoggedIn, userInfo]);

    useEffect(() => {
        if (name.trim() !== '' && address.trim() !== '' && detailAddress.trim() !== '' && zoneCode.trim() !== '' && phone1.trim() !== '' && phone2.trim() !== '' && phone3.trim() !== '' && pwValid && pwConfirmValid) {
            setNotAllow(false);
            return;
        }
        setNotAllow(true);
    }, [name, address, detailAddress, zoneCode, phone1, phone2, phone3, pwValid, pwConfirmValid]);


    useEffect(() => {
        if (pw === pwConfirm) {
            setPwConfirmValid(true);
        } else {
            setPwConfirmValid(false);
        }
    }, [pw, pwConfirm])

    // 언마운트 시 isPwConfirm 초기화
    useEffect(() => {
        return () => {
            dispatch(pwConfirmReset());
        };
    }, [dispatch]);

    // 엔터 누를 시 확인
    useEffect(() => {
        const handleEnterPress = (event) => {
            if (event.key === 'Enter') {
                event.preventDefault(); // 폼 제출 기본 이벤트 방지
                onClickConfirmButton();
            }
        };

        document.addEventListener('keydown', handleEnterPress);
        return () => {
            document.removeEventListener('keydown', handleEnterPress);
        };
    }, [onClickConfirmButton]);


    return (
        <div>
            <Container>
                <Row>
                    <Col md={{ span: 8, offset: 1 }} xs={12}>
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>회원정보 수정</h1>
                        <br /><br />
                    </Col>
                </Row>
                <Row>
                    <Col>
                        <Form className='login-ContentWrap'>
                            <Form.Group className="mb-3 text-start" controlId="formBasicName">
                                <Form.Label className='login-InputTitle'>이름</Form.Label>
                                <div className='login-InputWrap'>
                                    <Form.Control
                                        value={name}
                                        onChange={handleName}
                                        type="text"
                                        placeholder="이름을 입력하세요."
                                        className='login-Input' />
                                </div>
                            </Form.Group>

                            <Form.Group className="mb-3 text-start" controlId="formBasicZoneCode">
                                <Form.Label className='login-InputTitle'>주소</Form.Label>
                                <div className="address-container">
                                    <span className='login-InputWrapAddr'>
                                        <Form.Control
                                            value={zoneCode}
                                            onChange={(e) => setZoneCode(e.target.value)}
                                            type="text"
                                            placeholder="우편번호"
                                            className='login-InputAddr'
                                            readOnly
                                        />
                                    </span>
                                    <Button onClick={handlePostcode} variant="secondary" className="address-search-button">
                                        주소찾기
                                    </Button>
                                </div>
                            </Form.Group>

                            <Form.Group className="mb-3 text-start" controlId="formBasicAddress">

                                <div className='login-InputWrap'>
                                    <Form.Control
                                        value={address}
                                        onChange={(e) => setAddress(e.target.value)}
                                        type="text"
                                        placeholder="주소"
                                        className='login-Input'
                                        readOnly
                                    />
                                </div>

                            </Form.Group>

                            <Form.Group className="mb-3 text-start" controlId="formBasicDetailAddress">
                                <div className='login-InputWrap'>
                                    <Form.Control
                                        value={detailAddress}
                                        onChange={(e) => setDetailAddress(e.target.value)}
                                        type="text"
                                        placeholder="상세주소 입력"
                                        className='login-Input'
                                    />
                                </div>
                                <Form.Text className="login-ErrorMessageWrap">
                                    {
                                        address.length > 0 && detailAddress.length == 0 && (
                                            <div>상세주소를 입력해주세요.</div>
                                        )
                                    }
                                </Form.Text>
                            </Form.Group>


                            <Modal show={showPostcode} onHide={() => setShowPostcode(false)} centered>
                                <Modal.Header closeButton>
                                    <Modal.Title>주소 검색</Modal.Title>
                                </Modal.Header>
                                <Modal.Body>
                                    <DaumPostcode onComplete={handleComplete} />
                                </Modal.Body>
                            </Modal>


                            <Form.Group className="mb-3 text-start" controlId="formBasicPhone">
                                <Form.Label className='login-InputTitle'>전화번호</Form.Label>
                                <div className='login-InputWrapPhone' style={{ display: 'flex', gap: '10px' }}>
                                    <Form.Control
                                        id="phone1"
                                        value={phone1}
                                        onChange={handlePhone1Change}
                                        type="tel"
                                        maxLength="3"
                                        placeholder="000"
                                        className='login-InputPhone' />
                                    <Form.Control
                                        id="phone2"
                                        value={phone2}
                                        onChange={handlePhone2Change}
                                        type="tel"
                                        maxLength="4"
                                        placeholder="0000"
                                        className='login-InputPhone' />
                                    <Form.Control
                                        id="phone3"
                                        value={phone3}
                                        onChange={handlePhone3Change}
                                        type="tel"
                                        maxLength="4"
                                        placeholder="0000"
                                        className='login-InputPhone' />
                                </div>
                            </Form.Group>

                            <Form.Group className="mb-3 text-start" controlId="formBasicPassword">
                                <Form.Label className='login-InputTitle'>비밀번호</Form.Label>
                                <div className='login-InputWrap'>
                                    <Form.Control
                                        value={pw}
                                        onChange={handlePw}
                                        type="password" placeholder="비밀번호를 입력하세요." className='login-Input' />
                                </div>
                                <Form.Text className="login-ErrorMessageWrap">
                                    {
                                        !pwValid && pw.length > 0 && (
                                            <div>영문, 숫자, 특수문자 포함 8자 이상 입력해주세요.</div>
                                        )
                                    }
                                </Form.Text>
                            </Form.Group>

                            <Form.Group className="mb-3 text-start" controlId="formBasicPassword">
                                <Form.Label className='login-InputTitle'>비밀번호 확인</Form.Label>
                                <div className='login-InputWrap'>
                                    <Form.Control
                                        value={pwConfirm}
                                        onChange={handlePwConfirm}
                                        type="password" placeholder="비밀번호를 입력하세요." className='login-Input' />
                                </div>
                                <Form.Text className="login-ErrorMessageWrap">
                                    {
                                        !pwConfirmValid && pwConfirm.length > 0 && (
                                            <div>비밀번호가 일치하지 않습니다.</div>
                                        )
                                    }
                                </Form.Text>
                            </Form.Group>

                            <Button onClick={onClickConfirmButton} disabled={notAllow} variant="primary" className='login-Button' style={{ marginBottom: '10px' }}>
                                회원정보수정
                            </Button>
                        </Form>
                    </Col>
                </Row>
            </Container>
        </div>
    )
}

export default UpdateCustomer;