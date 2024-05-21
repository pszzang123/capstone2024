import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Table, Button, Modal, Container, Row, Col, Dropdown } from 'react-bootstrap';
import { useSelector } from 'react-redux';

const OrderManagement = () => {
    const [products, setProducts] = useState([]);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [sales, setSales] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [majorCategories, setMajorCategories] = useState([]);
    const [subCategories, setSubCategories] = useState([]);

    let { sellerInfo, isLoggedIn } = useSelector((state) => state.seller);

    useEffect(() => {
        axios.get(`${process.env.REACT_APP_API_URL}/clothes/seller/${sellerInfo.email_id}`)
            .then(response => setProducts(response.data))
            .catch(error => console.error('상품 불러오기 에러', error));

        axios.get(`${process.env.REACT_APP_API_URL}/major_category`)
            .then(response => {
                setMajorCategories(response.data);
            })
            .catch(error => {
                console.error('Major categories 가져오기 에러:', error);
            });

        axios.get(`${process.env.REACT_APP_API_URL}/sub_category`)
            .then(response => {
                setSubCategories(response.data);
            })
            .catch(error => {
                console.error('Sub categories 가져오기 에러:', error);
            });
    }, []);

    const getCategoryName = (categoryId, isMajor = true) => {
        if (isMajor) {
            const category = majorCategories.find(cat => cat.majorCategoryId === categoryId);
            return category ? category.name : 'Unknown Major Category';
        } else {
            const category = subCategories.find(cat => cat.subCategoryId === categoryId);
            return category ? category.name : 'Unknown Sub Category';
        }
    };

    const handleProductSelect = (product) => {
        setSelectedProduct(product);
        setShowModal(true);
        axios.get(`${process.env.REACT_APP_API_URL}/receipt_detail/clothes/${product.clothesId}`)
            .then(response => setSales(response.data))
            .catch(error => console.error('주문 데이터 가져오기 실패', error));
    };

    const handleStatusChange = (receiptDetailId, newStatus) => {
        axios.put(`${process.env.REACT_APP_API_URL}/receipt_detail/${receiptDetailId}/${newStatus}`)
            .then(() => {
                alert('주문 상태가 성공적으로 변경되었습니다.');
                // 상태가 변경된 후 sales 상태도 업데이트합니다.
                const updatedSales = sales.map(sale => {
                    if (sale.receiptDetailId === receiptDetailId) {
                        return { ...sale, status: newStatus }; // 상태 변경
                    }
                    return sale;
                });
                setSales(updatedSales); // 업데이트된 sales 배열로 상태를 설정
            })
            .catch(error => {
                console.error('주문 상태 변경 실패', error);
            });
    };

    
    const closeModal = () => {
        setShowModal(false);
    };

    // 주문 상태 코드
    const receiptDetailStatusLabels = {
        0: "상품 준비",
        1: "배송 준비",
        2: "배송 중",
        3: "배송 완료",
        4: "반품 신청",
        5: "반품 중",
        6: "반품 완료"
    };

    return (
        <div>
            <Container>
                <Row>
                    <Col>
                        <br /> <br />
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>주문 관리</h1>
                        <br /><br />
                    </Col>
                </Row>

                <Table striped bordered hover style={{ verticalAlign: 'middle' }}>
                    <thead>
                        <tr style={{ whiteSpace: 'nowrap' }}>
                            <th>상품명</th>
                            <th>대분류</th>
                            <th>소분류</th>
                            <th>가격</th>
                            <th>주문관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        {products.map(product => (
                            <tr key={product.clothesId}>
                                <td>{product.name}</td>
                                <td>{getCategoryName(product.majorCategoryId)}</td>
                                <td>{getCategoryName(product.subCategoryId, false)}</td>
                                <td style={{ whiteSpace: 'nowrap' }}>{product.price.toLocaleString()}원</td>
                                <td>
                                    <Button style={{backgroundColor:'black', whiteSpace:'nowrap'}} onClick={() => handleProductSelect(product)}>주문관리</Button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </Table>

                <Modal show={showModal} onHide={closeModal} size="lg" aria-labelledby="contained-modal-title-vcenter" centered>
                    <Modal.Header closeButton>
                        <Modal.Title>Sales for {selectedProduct?.name}</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <Table striped bordered hover style={{ verticalAlign: 'middle' }}>
                            <thead>
                                <tr style={{ whiteSpace: 'nowrap' }}>
                                    <th>주문일</th>
                                    <th>개수</th>
                                    <th>총 주문 금액</th>
                                    <th>주문 상태</th>
                                    <th>상태 변경</th>
                                </tr>
                            </thead>
                            <tbody>
                                {sales.map(sale => (
                                    <tr key={sale.receiptDetailId}>
                                        <td>{sale.date}</td>
                                        <td style={{ textAlign: 'center' }}>{sale.quantity}</td>
                                        <td style={{ whiteSpace: 'nowrap' }}>{sale.price.toLocaleString()}원</td>
                                        <td>{receiptDetailStatusLabels[sale.status]}</td>        
                                        <td>
                                            <Dropdown>
                                                <Dropdown.Toggle variant="Secondary" id="dropdown-basic">
                                                    상태 변경
                                                </Dropdown.Toggle>

                                                <Dropdown.Menu>
                                                    {Object.entries(receiptDetailStatusLabels).map(([status, label]) => (
                                                        <Dropdown.Item key={status} onClick={() => handleStatusChange(sale.receiptDetailId, Number(status))}>
                                                            {label}
                                                        </Dropdown.Item>
                                                    ))}
                                                </Dropdown.Menu>
                                            </Dropdown>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </Table>
                    </Modal.Body>
                </Modal>
            </Container>
        </div>
    );
};

export default OrderManagement;
