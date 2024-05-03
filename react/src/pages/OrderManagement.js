import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Table, Button, Modal, Container, Row, Col } from 'react-bootstrap';
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
            .catch(error => console.error('Error fetching products', error));

        axios.get(`${process.env.REACT_APP_API_URL}/major_category`)
            .then(response => {
                setMajorCategories(response.data);
            })
            .catch(error => {
                console.error('Major categories fetching error:', error);
            });

        axios.get(`${process.env.REACT_APP_API_URL}/sub_category`)
            .then(response => {
                setSubCategories(response.data);
            })
            .catch(error => {
                console.error('Sub categories fetching error:', error);
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
        axios.get(`${process.env.REACT_APP_API_URL}/sales/clothes/${product.clothesId}`)
            .then(response => setSales(response.data))
            .catch(error => console.error('Error fetching sales data', error));
    };

    const handleStatusChange = (receiptId, newStatus) => {
        axios.put(`${process.env.REACT_APP_API_URL}/receipt/${receiptId}/${newStatus}`)
            .then(() => {
                alert('Order status updated successfully');
                // Optionally refresh the sales data or update state locally
            })
            .catch(error => console.error('Error updating order status', error));
    };

    const closeModal = () => {
        setShowModal(false);
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
                                    <Button onClick={() => handleProductSelect(product)}>주문관리</Button>
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
                                    <th>총 주문금액</th>
                                    <th>주문상태</th>
                                    <th>Update Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {sales.map(sale => (
                                    <tr key={sale.receiptId}>
                                        <td>{sale.date}</td>
                                        <td style={{textAlign:'center'}}>{sale.quantity}</td>
                                        <td style={{ whiteSpace: 'nowrap' }}>{sale.price.toLocaleString()}원</td>
                                        <td>
                                            <Button onClick={() => handleStatusChange(sale.receiptId, 3)}>Set Delivered</Button>
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
