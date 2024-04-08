import { useDispatch, useSelector } from 'react-redux';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import { useNavigate } from 'react-router-dom';
import { useEffect, useState } from 'react';
import axios from 'axios';
import { removeFromCart, setCartItems, updateItemQuantity } from '../store/cartSlice.js';
import { Hidden } from 'react-grid-system';
import styled from 'styled-components';
import { Dropdown } from 'react-bootstrap';
import { FaCheck } from "react-icons/fa";

const CheckboxContainer = styled.div`
  display: inline-block;
  vertical-align: middle;
`;

const Icon = styled(FaCheck)`
  position: absolute;
  top: 50%;
  left: 50%;
  width: 16px; // 크기 조정
  height: 16px; // 크기 조정
  color: ${props => props.checked ? '#fff' : '#ccc'};
  transform: translate(-50%, -50%); // 위치 조정
`;

const HiddenCheckbox = styled.input.attrs({ type: 'checkbox' })`
  border: 0;
  clip: rect(0 0 0 0);
  clippath: inset(50%);
  height: 1px;
  margin: -1px;
  overflow: hidden;
  padding: 0;
  position: absolute;
  white-space: nowrap;
  width: 1px;
`;

const StyledCheckbox = styled.div`
  display: inline-block;
  width: 24px; // 아이콘 크기에 맞추어 조정
  height: 24px; // 아이콘 크기에 맞추어 조정
  background: ${props => props.checked ? '#000' : '#fff'};
  border-radius: 3px;
  transition: all 150ms;
  border: 2px solid ${props => props.checked ? '#000' : '#ccc'};
  position: relative;

  ${HiddenCheckbox}:focus + & {
    box-shadow: 0 0 0 3px pink;
  }
`;

// CustomCheckbox 컴포넌트
const CustomCheckbox = ({ className, checked, onChange, ...props }) => (
    <CheckboxContainer className={className} onClick={onChange}>
        <HiddenCheckbox checked={checked} {...props} />
        <StyledCheckbox checked={checked}>
            <Icon />
        </StyledCheckbox>
    </CheckboxContainer>
);

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

const CloseButton = styled.button`
  background-color: transparent;
  border: none;
  cursor: pointer;
  font-size: 24px; // 크기 조정 가능
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  &:hover {
    opacity: 0.7;
  }
`;

const StyledDropdownToggle = styled(Dropdown.Toggle)`
    background-color: #fff !important; /* 흰색 배경 */
    color: #000 !important; /* 검은색 텍스트 */
    border: 2px solid #000 !important; /* 조금 더 두꺼운 검은색 테두리 */
    border-radius: 4px !important; /* 모서리를 약간 둥글게 */
    font-weight: 500; /* 글자 굵기 조절 */

    &:hover, &:focus {
    background-color: #f8f9fa !important; /* 호버 및 포커스 시 배경색 */
    color: #000 !important; /* 호버 및 포커스 시 텍스트 색상 */
    border-color: #888 !important; /* 호버 및 포커스 시 테두리 색상 변경 */
    }
`;

const StyledDropdownMenu = styled(Dropdown.Menu)`
    background-color: #fff; /* 흰색 배경 */
    color: #000; /* 검은색 텍스트 */
    border-radius: 4px; /* 메뉴의 모서리를 둥글게 */

    .dropdown-item {
    color: #000; /* 옵션 텍스트 색상 */
    font-weight: 400; /* 옵션 글자 굵기 */

    &:hover, &:focus {
        background-color: #f0f0f0; /* 옵션 호버 및 포커스 시 배경색 */
        font-weight: 500; /* 옵션 호버 시 글자 굵기 */
`;


function CartItem(props) {

    let dispatch = useDispatch();
    let { userInfo, isLoggedIn } = useSelector((state) => state.user);

    return (
        <div>
            <Row>
                <Col xs={1} md={{ span: 1, offset: 1 }}>
                    <CustomCheckbox
                        checked={props.isChecked}
                        onChange={(e) => props.onCheckboxChange(props.item.detailId, !props.isChecked)} // 체크 상태를 토글
                    />
                </Col>

                <Col xs={4} md={2}>
                <img style={{width:'100px', height:'132px'}} src='https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/IMIM/24/03/06/GM0024030654386_0_THNAIL_ORGINL_20240312205132208.jpg' alt={props.item.name} />
                    {/* <img src={props.item.imageUrl} alt={props.item.name} /> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */}
                    {/* <img style={{width:'100px', height:'132px'}} src={props.item.} alt={props.item.name} /> */}
                </Col>
                <Col xs={7} md={4}>
                    <div>
                        <div>{props.item.name}</div>
                        <div>{props.item.color} / {props.item.size}</div>
                        <div>{props.item.price.toLocaleString()}원</div>
                    </div>
                </Col>
                <Col xs={5} md={1} style={{ marginTop: '12px' }}>
                    <Dropdown onSelect={(eventKey) => {
                        const newQuantity = parseInt(eventKey, 10);
                        axios.put(`http://localhost:8080/cart/${userInfo.email_id}/${props.item.detailId}`, { quantity: newQuantity })
                            .then(result => {
                                // 장바구니 상태 업데이트
                                dispatch(updateItemQuantity({ detailId: props.item.detailId, quantity: newQuantity }));
                            })
                            .catch(error => {
                                console.log('수량 변경 실패', error);
                            });
                    }}>
                        <StyledDropdownToggle variant="outline-secondary" id="dropdown-basic">
                            {props.item.quantity}개
                        </StyledDropdownToggle>

                        <StyledDropdownMenu>
                            {[...Array(10).keys()].map((number) => (
                                <Dropdown.Item key={number + 1} eventKey={number + 1}>
                                    {number + 1}개
                                </Dropdown.Item>
                            ))}
                        </StyledDropdownMenu>
                    </Dropdown>
                </Col>
                <Col xs={5} md={1} style={{ marginTop: '12px', whiteSpace: 'nowrap', fontSize: '17px', fontWeight: '700' }}  >
                    <span>{(props.item.quantity * props.item.price).toLocaleString()}원</span>
                </Col>
                <Col xs={2} md={1}>
                    <CloseButton onClick={() => {
                        axios.delete(`http://localhost:8080/cart/${userInfo.email_id}/${props.item.detailId}`)
                            .then(result => {
                                dispatch(removeFromCart(props.item));
                            })
                            .catch(error => {
                                console.log('장바구니 상품 제거 실패', error);
                            })
                    }}>&#x2715;</CloseButton>
                </Col>
            </Row>
            <Row>
                <Col xs={12} md={{ span: 10, offset: 1 }}>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>

        </div>
    )
}

function Cart(props) {

    let navigate = useNavigate();

    let dispatch = useDispatch();
    let { userInfo, isLoggedIn } = useSelector((state) => state.user);
    let cartItems = useSelector((state) => state.cart.items);

    // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
    useEffect(() => {
        if (!isLoggedIn) {
            // 로그인하지 않은 상태라면 로그인 페이지로 리디렉션
            alert('로그인 후 이용해주세요.')
            navigate('/login');
        } else {
            axios.get(`http://localhost:8080/cart/${userInfo.email_id}`)
                .then(result => {
                    dispatch(setCartItems(result.data));
                })
                .catch(error => {
                    console.log('장바구니 데이터 불러오기 실패', error);
                })
        }
    }, [isLoggedIn]);

    const initialSelectedItems = cartItems.reduce((items, item) => {
        items[item.detailId] = true; // 모든 상품을 선택된 상태(true)로 초기화
        return items;
    }, {});

    const [selectedItems, setSelectedItems] = useState(initialSelectedItems);

    const handleCheckboxChange = (itemId, isChecked) => {
        setSelectedItems(prevSelectedItems => ({
            ...prevSelectedItems,
            [itemId]: isChecked
        }));
    };


    // 선택된 상품들의 총액 계산
    const totalAmount = cartItems.reduce((total, item) => {
        return total + (selectedItems[item.detailId] ? item.price * item.quantity : 0);
    }, 0);

    return (
        <div>
            <br /> <br />

            <Container>
                <Row>
                    <Col xs={{ span: 10, offset: 1 }} md={{ span: 10, offset: 1 }}>
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>장바구니</h1>
                        <br /><br />
                    </Col>
                </Row>
                <Row>
                    <Hidden xs sm>
                        <Col md={{ span: 7, offset: 1 }}>
                            상품정보
                        </Col>
                    </Hidden>
                    <Hidden xs sm>
                        <Col md={1}>
                            수량
                        </Col>
                    </Hidden>
                    <Hidden xs sm>
                        <Col md={1} style={{ whiteSpace: 'nowrap' }}>
                            주문금액
                        </Col>
                    </Hidden>
                </Row>
                <Row>
                    <Col xs={12} md={{ span: 10, offset: 1 }}>
                        <hr style={{ border: 0, height: '2px', background: 'black' }} />
                    </Col>
                </Row>
                {cartItems.map(item => (
                    <CartItem
                        key={item.detailId}
                        item={item}
                        isChecked={!!selectedItems[item.detailId]} // 선택 상태 결정
                        onCheckboxChange={handleCheckboxChange} // 체크박스 변경 이벤트 핸들러
                    />
                ))}
                <Row>
                    <Col xs={9} md={{ span: 6, offset: 1 }}></Col>
                    <Col xs={3} md={{ span: 4 }} style={{ fontSize: '17px', fontWeight: '700' }}>
                        총 주문금액 {totalAmount.toLocaleString()}원
                    </Col>
                </Row>
                <br></br>
                <Row>
                    <Col>
                        <StyledButton>주문하기</StyledButton>
                    </Col>
                </Row>
                <br></br>
            </Container>
        </div >
    )
}

export default Cart;