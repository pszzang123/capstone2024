import React, { useEffect, useState } from 'react';
import { useLocation, useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';
import { Container, Row, Col, Card, Badge } from 'react-bootstrap';
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
  &:disabled {
    background-color: #ccc; /* 비활성화 시 회색 */
  }
`;


function OrderDetails() {
    const navigate = useNavigate();
    const location = useLocation();
    const queryParams = new URLSearchParams(location.search);
    const date = queryParams.get('date');
    const status = parseInt(queryParams.get('status'), 10);
    // const { date, status } = location.state; // 넘어온 데이터 사용
    const { receiptId } = useParams();
    const [orderDetails, setOrderDetails] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [totalAmount, setTotalAmount] = useState(0);  // 총 주문 금액 상태 추가
    const [customerDetails, setCustomerDetails] = useState({});

    useEffect(() => {
        const fetchOrderDetails = async () => {
            try {
                const orderResponse = await axios.get(`${process.env.REACT_APP_API_URL}/receipt_detail/${receiptId}`);
                setOrderDetails(orderResponse.data);

                const customerResponse = await axios.get(`${process.env.REACT_APP_API_URL}/customers/${orderResponse.data[0].customerEmail}`);
                setCustomerDetails(customerResponse.data);

                // 총액 계산
                const total = orderResponse.data.reduce((sum, item) => sum + (item.price * item.quantity), 0);
                setTotalAmount(total);

                setLoading(false);
            } catch (err) {
                setError('주문 정보를 불러오는 데 실패했습니다.');
                setLoading(false);
                console.error(err);
            }
        };

        fetchOrderDetails();
    }, [receiptId]);

    // 반품 처리 함수
    const handleReturn = async () => {
        if (status === 4 || status === 5) {
            alert('이미 반품 신청되었거나 처리된 주문입니다.');
        } else {
            try {
                // API로 상태 업데이트 요청
                axios.put(`${process.env.REACT_APP_API_URL}/receipt/${receiptId}/4`)
                    .then(() => {
                        alert('반품 신청이 완료되었습니다.');
                        navigate('/mypage/orderdeliverystatus');
                    })
            } catch (err) {
                console.error('반품 처리 중 오류가 발생했습니다.', err);
            }
        }
    };

    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;

    // 주문 상태 코드를 문자열로 매핑
    const statusLabels = {
        0: "상품 준비",
        1: "배송 준비",
        2: "배송 중",
        3: "배송 완료",
        4: "반품 신청",
        5: "반품 완료"
    };

    const isReturnDisabled = status === 4 || status === 5;

    return (
        <Container>
            <Row>
                <Col>
                    <h1 style={{ fontSize: '30px', fontWeight: '700', marginBottom: '60px' }}>주문 상세 정보</h1>
                </Col>
            </Row>
            <Row className="mb-4">
                <Col md={4}>
                    <div><strong>주문 번호:</strong> {receiptId}</div>
                </Col>
                <Col md={4}>
                    <div><strong>주문일:</strong> {new Date(date).toLocaleDateString()}</div>
                </Col>
                <Col md={4}>
                    <div><strong>주문 상태:</strong> {statusLabels[status]}</div>
                </Col>
            </Row>
            <Row className="mt-3">
                {orderDetails.map((item, index) => (
                    <Card className="mb-3" key={index} style={{ fontSize: '18px', fontWeight: '600' }}>
                        <Row className="no-gutters align-items-center">
                        <Col md={4} style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
                                <Card.Img src={item.imageUrl || 'default-image.jpg'} alt={item.name}
                                    style={{
                                        width: "100%", // 이미지의 너비를 카드에 맞춤
                                        height: "200px", // 고정된 높이 설정
                                        objectFit: "cover" // 이미지가 비율을 유지하며 지정된 영역을 채우도록 함
                                    }} />
                            </Col>
                            <Col md={8}>
                                <Card.Body>
                                    <Card.Title>{item.name}</Card.Title>
                                    <Card.Text>
                                        색상: {item.color}<br />
                                        사이즈: {item.size}<br />
                                        {item.price.toLocaleString()}원<br />
                                        수량: {item.quantity}개
                                    </Card.Text>
                                    <Card.Text>
                                        <strong>합계: ₩{(item.price * item.quantity).toLocaleString()}</strong>
                                    </Card.Text>
                                </Card.Body>
                            </Col>
                        </Row>
                    </Card>
                ))}
            </Row>

            <Row>
                <Col xs={12} md={{ span: 1, offset: 9 }} style={{ textAlign: 'right', fontSize: '17px', fontWeight: '700', whiteSpace: 'nowrap' }}>
                    총 주문금액 {totalAmount.toLocaleString()}원
                </Col>
            </Row>






            <Row>
                <Col>
                    <h1 style={{ fontSize: '20px', fontWeight: '700', marginBottom: '10px', marginTop: '50px' }}>받는사람</h1>
                </Col>
            </Row>

            <Row>
                <Col>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 5, offset: 1 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'left' }}>받는사람</Col>
                <Col md={{ span: 4 }} xs={{ span: 5 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right' }}>{customerDetails.name}</Col>
            </Row>
            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 5, offset: 1 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'left' }}>연락처</Col>
                <Col md={{ span: 4 }} xs={{ span: 5 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right', whiteSpace: 'nowrap' }}>{customerDetails.phone}</Col>
            </Row>

            <Row>
                <Col md={{ span: 4, offset: 2 }} xs={{ span: 5, offset: 1 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'left' }}>받는주소</Col>
                <Col md={{ span: 4 }} xs={{ span: 5 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right' }}>{customerDetails.streetAddress}</Col>
            </Row>
            <Row>
                <Col md={{ span: 1, offset: 9 }} xs={{ span: 5, offset: 6 }} style={{ fontSize: '15px', fontWeight: '600', marginBottom: '5px', textAlign: 'right' }}>{customerDetails.detailAddress}</Col>
            </Row>
            <Row>
                <Col>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>
            <Row style={{ marginTop: '50px' }}>
                <Col md={{ span: 3, offset: 3 }} xs={6}>
                    <StyledButton style={{ background: '#808080' }} onClick={() => window.history.back()}><div style={{ whiteSpace: 'nowrap' }}>뒤로가기</div></StyledButton>
                </Col>
                <Col md={{ span: 3 }} xs={6}>
                    <StyledButton onClick={handleReturn} disabled={isReturnDisabled}><div style={{ whiteSpace: 'nowrap' }}>{isReturnDisabled ? "반품 신청됨" : "반품하기"}</div></StyledButton>
                </Col>
            </Row>
            <br></br>

        </Container>
    );
}

export default OrderDetails;
