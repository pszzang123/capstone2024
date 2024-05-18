import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';
import CardItem from './CardItem'; 
import { Col, Container, Dropdown, Row } from 'react-bootstrap';

const SearchResults = () => {

    const { query } = useParams();
    const [products, setProducts] = useState([]);
    const [sortOrder, setSortOrder] = useState('인기상품순'); // 정렬 상태 초기화
    const navigate = useNavigate();

    useEffect(() => {
        fetchInitialProducts(query);
    }, [query]);

    const fetchInitialProducts = async (searchQuery) => {
        axios.get(`${process.env.REACT_APP_API_URL}/clothes/search/${encodeURIComponent(searchQuery)}`)
            .then((response1) => {
                axios.put(`${process.env.REACT_APP_API_URL}/clothes/sort/1`, response1.data)
                .then((response2)=>{
                    setProducts(response2.data);
                })
                .catch((error)=>{
                    console.error('상품 정렬 실패:', error);
                  })
            })
            .catch((error) => {
                console.error('상품 불러오기 실패:', error);
            })
    };

    const sortProducts = async (sortKey, sortText) => {
        try {
            // 서버에 PUT 요청을 보내 데이터 정렬 요청
            const response = await axios.put(`${process.env.REACT_APP_API_URL}/clothes/sort/${sortKey}`, products);
            console.log("정렬 상품:", response.data);
            setProducts(response.data);
            setSortOrder(sortText);
        } catch (error) {
            console.error('상품 정렬 실패:', error);
        }
    };

    return (
        <div>
            <Container>
                <br></br><br></br>
                <Row>
                    <Col>
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>'{query}' 에 대한 검색 결과입니다.</h1>
                        <br /><br />
                    </Col>
                </Row>
                <Row>
                    <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'left', marginBottom: '20px' }}>
                        <div>
                            {products.length.toLocaleString()}개 상품
                        </div>
                    </Col>
                </Row>

                <Row className="justify-content-end">
                    <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'right', marginBottom: '10px' }}>
                        <Dropdown>
                            <Dropdown.Toggle
                                variant="success"
                                id="dropdown-basic"
                                className="bg-transparent border-0 text-dark btn-sm" // 배경, 테두리 없애고 글씨는 검은색으로, 작은 크기
                            >{sortOrder}
                            </Dropdown.Toggle>
                            <Dropdown.Menu align="end">
                                <Dropdown.Item onClick={() => sortProducts('1', '인기상품순')}>인기상품순</Dropdown.Item>
                                <Dropdown.Item onClick={() => sortProducts('2', '신상품순')}>신상품순</Dropdown.Item>
                                <Dropdown.Item onClick={() => sortProducts('3', '댓글순')}>댓글순</Dropdown.Item>
                                <Dropdown.Item onClick={() => sortProducts('4', '좋아요순')}>좋아요순</Dropdown.Item>
                                <Dropdown.Item onClick={() => sortProducts('5', '조회수순')}>조회수순</Dropdown.Item>
                            </Dropdown.Menu>
                        </Dropdown>
                    </Col>
                </Row>

                <Row>
                    {products.length > 0 ? (
                        products.map(product => <CardItem key={product.clothesId} products={product} navigate={navigate} />)
                    ) : (
                        <p>No products found.</p>
                    )}
                </Row>
            </Container>
        </div>
    );
};

export default SearchResults;
