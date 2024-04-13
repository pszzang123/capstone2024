import axios from 'axios';
import { useEffect, useState } from 'react';
import { Form, Button, Row, Col, Container } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import { debounce } from 'lodash';
import DaumPostcode from 'react-daum-postcode';
import Modal from 'react-bootstrap/Modal';



function Join(props) {

  let [name, setName] = useState('');
  // let [address, setAddress] = useState('');
  let [address, setAddress] = useState('');
  let [zoneCode, setZoneCode] = useState('');
  let [fullAddress, setFullAddress] = useState('');
  let [showPostcode, setShowPostcode] = useState(false);
  // let [phone, setPhone] = useState('');
  let [phone1, setPhone1] = useState('');
  let [phone2, setPhone2] = useState('');
  let [phone3, setPhone3] = useState('');

  let [email, setEmail] = useState('');
  let [pw, setPw] = useState('');
  let [pwConfirm, setPwConfirm] = useState('');


  let [emailValid, setEmailValid] = useState(true);
  let [emailDupCheck, setEmailDupCheck] = useState(null);
  let [pwValid, setPwValid] = useState(false);
  let [pwConfirmValid, setPwConfirmValid] = useState(false);
  let [notAllow, setNotAllow] = useState(true);


  let navigate = useNavigate();

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
    // setFullAddress(data.jibunAddress); // 또는 roadAddress 등 필요에 따라 선택
    setShowPostcode(false);
  };

  // 주소 검색 팝업을 띄우는 함수
  const handlePostcode = () => {
    setShowPostcode(true);
  };

  let handleName = (e) => {
    setName(e.target.value);
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


  // let handlePhone1Change = (e) => {
  //   if (e.target.value.length <= 3) {
  //     setPhone1(e.target.value);
  //   }
  //   if (e.target.value.length === 3) {
  //     document.getElementById('phone2').focus();
  //   }
  // }

  // let handlePhone2Change = (e) => {
  //   if (e.target.value.length <= 4) {
  //     setPhone2(e.target.value);
  //   }
  //   if (e.target.value.length === 4) {
  //     document.getElementById('phone3').focus();
  //   }
  // }

  // let handlePhone3Change = (e) => {
  //   if (e.target.value.length <= 4) {
  //     setPhone3(e.target.value);
  //   }
  // }


  let handleEmail = (e) => {
    setEmail(e.target.value);
    let regex =
      /^(([^<>()\[\].,;:\s@"]+(\.[^<>()\[\].,;:\s@"]+)*)|(".+"))@(([^<>()[\].,;:\s@"]+\.)+[^<>()[\].,;:\s@"]{2,})$/i;
    if (regex.test(e.target.value)) {
      setEmailValid(true);
    } else {
      setEmailValid(false);
    }
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
    axios.post(`${process.env.REACT_APP_API_URL}/customers`, { email: email, address: address + ' ' + fullAddress, name: name, password: pw, phone: phone1 + '-' + phone2 + '-' + phone3 })
      .then((result) => {
        alert('회원가입 완료');
        navigate("/login")
      })
      .catch(() => {
        console.log('회원가입 실패')
      })
  }

  useEffect(() => {
    if (name.trim() !== '' && address.trim() !== '' && fullAddress.trim() !== '' && zoneCode.trim() !== '' && phone1.trim() !== '' && phone2.trim() !== '' && phone3.trim() !== '' && emailValid && pwValid && pwConfirmValid) {
      setNotAllow(false);
      return;
    }
    setNotAllow(true);
  }, [name, address, fullAddress, zoneCode, phone1, phone2, phone3, emailValid, pwValid, pwConfirmValid]);

  useEffect(() => {
    if (pw === pwConfirm) {
      setPwConfirmValid(true);
    } else {
      setPwConfirmValid(false);
    }
  }, [pw, pwConfirm])



  // 중복 검사를 수행하는 함수
  let checkEmailDuplication = async () => {
    if (email.trim() === '') {
      setEmailDupCheck(null);
      return;
    }

    try {
      axios.get(`${process.env.REACT_APP_API_URL}/customers/email/${email}`)
        .then((result) => {
          setEmailDupCheck(result.data);
        })
        .catch(() => {
          console.log("사용중인 이메일");
        })
    } catch { }
  };

  // debounce를 사용하여 입력이 멈춘 후 검사 수행
  let debouncedCheckEmailDuplication = debounce(checkEmailDuplication, 500);

  useEffect(() => {
    debouncedCheckEmailDuplication();

    // 컴포넌트가 언마운트될 때 debounce 취소
    return () => {
      debouncedCheckEmailDuplication.cancel();
    };
  }, [email]); // email 상태가 변경될 때마다 실행


  return (
    <div>
      <Container>
        <Row>
          <Col>
            <Form className='login-ContentWrap'>
              <Form.Text className="login-InputTitle">
                회원정보를 입력해주세요
              </Form.Text>

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

              {/* <Form.Group className="mb-3 text-start" controlId="formBasicZoneCode">
      <Form.Label className='login-InputTitle'>주소</Form.Label>
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
          <Button onClick={handlePostcode} variant="secondary">
            주소찾기
          </Button>
      </Form.Group> */}

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
                  <Button onClick={handlePostcode} variant="secondary" className="address-search-button" style={{ whiteSpace: 'nowrap' }}>
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

              <Form.Group className="mb-3 text-start" controlId="formBasicFullAddress">
                <div className='login-InputWrap'>
                  <Form.Control
                    value={fullAddress}
                    onChange={(e) => setFullAddress(e.target.value)}
                    type="text"
                    placeholder="상세주소 입력"
                    className='login-Input'
                  />
                </div>
                <Form.Text className="login-ErrorMessageWrap">
                  {
                    address.length > 0 && fullAddress.length == 0 && (
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

              {/* <Form.Group className="mb-3 text-start" controlId="formBasicPhone">
        <Form.Label className='login-InputTitle'>전화번호</Form.Label>
        <div className='login-InputWrap'>
          <Form.Control
            value={phone}
            onChange={handlePhone}
            type="tel"
            placeholder="전화번호를 입력하세요."
            className='login-Input' />
        </div>
      </Form.Group> */}

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
                {/* <div className='login-InputWrap' style={{ display: 'flex', gap: '10px' }}>
          <Form.Control
            id="phone1"
            value={phone1}
            onChange={handlePhone1Change}
            type="tel"
            maxLength="3"
            placeholder="000"
            className='login-Input' style={{ width: '60px' }} />
          <Form.Control
            id="phone2"
            value={phone2}
            onChange={handlePhone2Change}
            type="tel"
            maxLength="4"
            placeholder="0000"
            className='login-Input' style={{ width: '80px' }} />
          <Form.Control
            id="phone3"
            value={phone3}
            onChange={handlePhone3Change}
            type="tel"
            maxLength="4"
            placeholder="0000"
            className='login-Input' style={{ width: '80px' }} />
        </div> */}
              </Form.Group>


              <Form.Group className="mb-3 text-start" controlId="formBasicEmail" style={{ marginTop: '20px' }}>
                <Form.Label className='login-InputTitle'>아이디(이메일)</Form.Label>
                <div className='login-InputWrap'>
                  <Form.Control
                    value={email}
                    onChange={handleEmail}
                    type="email"
                    placeholder="아이디(이메일)를 입력하세요."
                    className='login-Input' />
                </div>
                <Form.Text className="login-ErrorMessageWrap">
                  {
                    email.length == 0 ? null :
                      (!emailValid ? <div>이메일을 올바르게 입력해주세요.</div> :
                        emailDupCheck ? <div>사용 중인 이메일입니다.</div> :
                          <div style={{ color: 'green' }}>사용 가능한 이메일입니다.</div>)
                  }
                </Form.Text>
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
                {/* type="submit"  */}
                가입하기
              </Button>
            </Form>
          </Col>
        </Row>
      </Container>
    </div>

  )
}

export default Join;