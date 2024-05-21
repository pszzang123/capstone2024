import React, { useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { Container, Row, Col, Form } from 'react-bootstrap';
import { Hidden } from 'react-grid-system';
import styled from 'styled-components';
import { useDispatch, useSelector } from 'react-redux';
import axios from 'axios';


let StyledButton = styled.button`
  
  background-color: #000; /* 검은색 배경 */
  color: #fff; /* 흰색 텍스트 */
  border: none; /* 테두리 없음 */
  padding: 10px 100px; /* 내부 여백 */
  height: 50px;
  font-size: 1rem; /* 글자 크기 */
  font-weight: bold; /* 글자 굵기 */
  cursor: pointer; /* 마우스 오버시 커서 변경 */
//   border-radius: 5px; /* 모서리 둥글게 */
  transition: background-color 0.3s ease; /* 호버 효과를 위한 전환 */

  &:hover {
    background-color: #333; /* 호버시 배경색 변경 */
  }
`;


function CheckoutItem(props) {

    return (
        <div style={{ fontSize: '18px', fontWeight: '600' }}>
            <Row>
                <Col md={{ span: 1, offset: 1 }} xs={2}>
                    <img style={{ width: '100px', height: '132px' }} src={props.item.imageUrl} alt={props.item.name} />
                </Col>
                <Col xs={7} md={7} style={{ marginTop: '12px', marginBottom: '12px' }}>
                    <div>
                        <div>{props.item.name}</div>
                        <div> {props.item.color + ' / ' + props.item.size} </div>
                        <div> {props.item.price}원 </div>
                        <div> {props.item.quantity}개 </div>
                    </div>
                </Col>
                <Col xs={3} md={2} style={{
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'center',
                    marginTop: '12px',
                    marginBottom: '12px',
                    whiteSpace: 'nowrap',
                    fontSize: '17px',
                    fontWeight: '700'
                }}
                >
                    <p style={{ margin: '12px 0' }}>{(props.item.price * props.item.quantity).toLocaleString()}원</p>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 10, offset: 1 }} xs={12}>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>
        </div>
    )
}



function Checkout(props) {
    const dispatch = useDispatch();
    const navigate = useNavigate();
    const location = useLocation();
    const { items } = location.state || { items: [] }; 


    const { userInfo, isLoggedIn } = useSelector(state => state.user);

    const [name, setName] = useState('');
    let [phone, setPhone] = useState('');
    let [address, setAddress] = useState('');
    let [zoneCode, setZoneCode] = useState('');
    let [detailAddress, setDetailAddress] = useState('');
    const [paymentMethod, setPaymentMethod] = useState('');

    const handleSubmit = () => {
        axios.post(`${process.env.REACT_APP_API_URL}/receipt`, {
            customerEmail: userInfo.email_id,
            status: 0 
        })
            .then(response1 => {
                const receiptId = response1.data.receiptId;

                items.forEach(item => {
                    axios.post(`${process.env.REACT_APP_API_URL}/receipt_detail`, {
                        receiptId: receiptId,
                        detailId: item.detailId,
                        quantity: item.quantity,
                        status: 0
                    })
                        .then(response2 => {
                            console.log(`영수증 세부정보 생성 완료: ${response2.data.detailId}`);
                            if (item.root === 'cart') {
                                removeItemFromCart(userInfo.email_id, item.detailId); 
                            }
                        })
                        .catch(error => {
                            console.error('영수증 세부정보 생성 실패', error);
                        });
                });

                navigate('/ordercomplete', {
                    state: {
                        address: address,
                        detailAddress: detailAddress,
                        orderNumber: receiptId,
                        amount: totalAmount,
                        items: items
                    }
                });

            })
            .catch(error => {
                console.error('영수증 생성 실패', error);
            });
    };

    const removeItemFromCart = (email, detailId) => {
        axios.delete(`${process.env.REACT_APP_API_URL}/cart/${email}/${detailId}`)
            .then(response => {
                console.log(`장바구니에서 상품 제거 성공: ${detailId}`);
            })
            .catch(error => {
                console.error(`장바구니에서 상품 제거 실패: ${detailId}`, error);
            });
    };



    const totalAmount = items.reduce((acc, item) => acc + (item.clothes.price * item.quantity), 0);

    // 비밀번호 확인을 하지 않은 상태라면 비밀번호 확인 페이지로 리디렉션
    useEffect(() => {
        if (!isLoggedIn || !userInfo) {
            return; 
        }
        if (!isLoggedIn) {
            alert('로그인 후 이용해주세요.')
            navigate('/login');
        } else {
            axios.get(`${process.env.REACT_APP_API_URL}/customers/${userInfo.email_id}`)
                .then(response => {
                    const userData = response.data;
                    setName(userData.name);
                    setAddress(userData.streetAddress);
                    setDetailAddress(userData.detailAddress);
                    setZoneCode(userData.zipCode.toString());
                    setPhone(userData.phone);
                })
                .catch(error => {
                    console.error("사용자 정보 불러오기 실패", error);
                });
        }

    }, [navigate, isLoggedIn, userInfo]);

    // 아이템 없이 구매화면 들어오면 홈으로 이동
    useEffect(() => {
        if (items.length === 0) {
            navigate('/');
        }
    }, [navigate, items]);

    return (
        <Container>
            <br></br><br></br>
            <Row>
                <Col> <h1 style={{ fontSize: '30px', fontWeight: '700', marginBottom: '50px', textAlign: 'center' }}>주문/결제</h1></Col>
            </Row>
            <Row>
                <Col md={{ span: 2, offset: 1 }} xs={12}>
                    <h1 style={{ fontSize: '20px', fontWeight: '700', marginBottom: '30px', textAlign: 'left' }}>구매 상품</h1>
                </Col>
            </Row>

            <Row>
                <Hidden xs sm>
                    <Col md={{ span: 7, offset: 2 }} style={{ fontSize: '14px', fontWeight: '700' }}>
                        상품정보
                    </Col>
                </Hidden>
                <Hidden xs sm>
                    <Col md={2} style={{ whiteSpace: 'nowrap', fontSize: '14px', fontWeight: '700' }}>
                        주문금액
                    </Col>
                </Hidden>
            </Row>
            <Row>
                <Col md={{ span: 10, offset: 1 }} xs={12}>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>
            <Row>
                {items.map((item, index) => (
                    <CheckoutItem
                        key={index}
                        item={{
                            name: item.clothes.name,
                            imageUrl: item.imgUrl,
                            color: item.selectedDetail.color,
                            size: item.selectedDetail.size,
                            price: item.clothes.price,
                            quantity: item.quantity
                        }}
                    />
                ))}
            </Row>
            <Row>
                <Col xs={12} md={{ span: 1, offset: 9 }} style={{ textAlign: 'right', fontSize: '17px', fontWeight: '700', whiteSpace: 'nowrap' }}>
                    총 결제금액 {totalAmount.toLocaleString()}원
                </Col>
            </Row>
            <Row>
                <Col xs={12} md={{ span: 10, offset: 1 }}>
                    <div style={{ height: '2px', backgroundColor: 'gray', marginTop: '100px' }}></div>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 2, offset: 1 }} xs={12}>
                    <h1 style={{ fontSize: '20px', fontWeight: '700', marginTop: '30px', marginBottom: '30px', textAlign: 'left' }}>배송지 정보</h1>
                </Col>
            </Row>

            <Row>
                <Col md={{ span: 1, offset: 1 }} xs={3} style={{ textAlign: 'left' }}>
                    이름
                </Col>
                <Col md={4} xs={9} style={{ textAlign: 'left' }}>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Control type="text" value={name} readOnly />
                        </Form.Group>
                    </Form>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 1, offset: 1 }} xs={3} style={{ textAlign: 'left' }}>
                    휴대폰
                </Col>
                <Col md={4} xs={9} style={{ textAlign: 'left' }}>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Control type="text" value={phone} readOnly />
                        </Form.Group>
                    </Form>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 1, offset: 1 }} xs={3} style={{ textAlign: 'left' }}>
                    배송 주소
                </Col>
                <Col md={4} xs={9} style={{ textAlign: 'left' }}>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Control type="text" value={zoneCode} readOnly />
                        </Form.Group>
                    </Form>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 9, offset: 3 }} style={{ textAlign: 'left' }}>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Control type="text" value={address} readOnly />
                        </Form.Group>
                    </Form>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 9, offset: 3 }} style={{ textAlign: 'left' }}>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Control type="text" value={detailAddress} readOnly />
                        </Form.Group>
                    </Form>
                </Col>
            </Row>

            <Row>
                <Col md={{ span: 10, offset: 1 }} xs={12}>
                    <div style={{ height: '2px', backgroundColor: 'gray', marginTop: '100px' }}></div>
                </Col>
            </Row>

            <Row>
                <Col md={{ span: 2, offset: 1 }} xs={12}>
                    <h1 style={{ fontSize: '20px', fontWeight: '700', marginBottom: '30px', marginTop: '30px', textAlign: 'left' }}>결제 수단</h1>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 5, offset: 1 }} xs={12}>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Select onChange={(e) => setPaymentMethod(e.target.value)}>
                                <option>결제 방법 선택</option>
                                <option value="credit_card">신용/체크카드</option>
                                <option value="bank_transfer">계좌이체/무통장입금</option>
                                <option value="mobile_payment">휴대폰</option>
                            </Form.Select>
                        </Form.Group>

                    </Form>
                </Col>
            </Row>
            <Row style={{ marginTop: '100px' }}>
                <Col>
                    <StyledButton onClick={handleSubmit}>결제하기</StyledButton>
                </Col>
            </Row>
            <br></br>
        </Container >
    );
}

export default Checkout;
