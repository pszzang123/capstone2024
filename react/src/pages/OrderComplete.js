import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { Container, Row, Col } from 'react-bootstrap';
import styled from 'styled-components';

let StyledButton = styled.button`
  background-color: #000; /* 검은색 배경 */
  color: #fff; /* 흰색 텍스트 */
  border: none; /* 테두리 없음 */
  padding: 10px 20px; /* 내부 여백 조정 */
  width: 100%; /* 부모 컨테이너의 가로길이에 맞춤 */
  height: 50px;
  font-size: 1rem; /* 글자 크기 */
  font-weight: bold; /* 글자 굵기 */
  cursor: pointer; /* 마우스 오버시 커서 변경 */
  transition: background-color 0.3s ease; /* 호버 효과를 위한 전환 */
  &:hover {
    background-color: #333; /* 호버시 배경색 변경 */
  }
`;



function OrderCompleteItem(props) {

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

function OrderComplete() {
    const location = useLocation();
    const { address, detailAddress, orderNumber, amount, items } = location.state || {};

    let navigate = useNavigate();

    return (
        <Container>
            <br></br><br></br>
            <Row>
                <Col>
                    <h1 style={{ fontSize: '30px', fontWeight: '700', marginBottom: '50px', textAlign: 'center' }}>구매완료</h1>
                </Col>
            </Row>

            <Row>
                <Col>
                    <p style={{ fontSize: '20px', fontWeight: '700' }}>주문이 완료되었습니다!</p>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 10, offset: 1 }} xs={12}>
                    <div style={{ height: '2px', backgroundColor: 'gray', marginBottom: '20px' }}></div>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 5, offset: 1 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'left' }}>주문 번호</Col>
                <Col md={{ span: 4 }} xs={{ span: 5 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right' }}>{orderNumber}</Col>
            </Row>
            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 5, offset: 1 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'left' }}>배송지</Col>
                <Col md={{ span: 4 }} xs={{ span: 5 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right' }}>{address}</Col>
            </Row>
            <Row>
                <Col md={{ span: 1, offset: 9 }} xs={{ span: 5, offset: 6 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right' }}>{detailAddress}</Col>
            </Row>
            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 5, offset: 1 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'left' }}>주문 금액</Col>
                <Col md={{ span: 4 }} xs={{ span: 5 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right', whiteSpace: 'nowrap' }}>{amount.toLocaleString()}원</Col>
            </Row>

            <Row>
                <Col md={{ span: 10, offset: 1 }} xs={12}>
                    <div style={{ height: '2px', backgroundColor: 'gray', marginBottom: '20px', marginTop: '15px' }}></div>
                </Col>
            </Row>

            <Row>
                <Col>
                    <h1 style={{ fontSize: '20px', fontWeight: '700', marginBottom: '10px', marginTop: '50px' }}>주문상품정보</h1>
                </Col>
            </Row>

            <Row>
                <Col md={{ span: 10, offset: 1 }} xs={12}>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>
            <Row>
                {items.map((item, index) => (
                    <OrderCompleteItem
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

            {/* <Row>
                <Col>배송지:</Col>
                <Col>{address}</Col>
            </Row>
            <Row>
                <Col>주문 금액:</Col>
                <Col>{amount.toLocaleString()}원</Col>
            </Row> */}

            <Row style={{ marginTop: '100px' }}>
                <Col md={{span: 3, offset: 3}} xs={6}>
                    <StyledButton style={{ background: '#808080' }} onClick={()=>{navigate('/')}}><div style={{whiteSpace: 'nowrap'}}>홈으로</div></StyledButton>
                </Col>
                <Col md={{span: 3}} xs={6}>
                    <StyledButton onClick={()=>{navigate('/mypage/orderdeliverystatus')}}><div style={{whiteSpace: 'nowrap'}}>주문내역</div></StyledButton>
                </Col>
            </Row>
            <br></br>


        </Container>
    );
}

export default OrderComplete;
