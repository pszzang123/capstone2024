import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';
import CardItem from './CardItem'; // Your CardItem component
import { Col, Container, Pagination, Row } from 'react-bootstrap';

const SearchResults = () => {
    const { query } = useParams();
    const [products, setProducts] = useState([]);

    useEffect(() => {
        if (query) {
            fetchProducts(query);
        }
    }, [query]);

    const fetchProducts = async (searchQuery) => {
        try {
            const response = await axios.get(`${process.env.REACT_APP_API_URL}/clothes/search/${encodeURIComponent(searchQuery)}`);
            console.log("API Response:", response.data);  // API 응답 확인
            setProducts(response.data);
        } catch (error) {
            console.error('Failed to fetch products:', error);
        }
    };

    let navigate = useNavigate();

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
                <Row>
                    {products.length > 0 ? (
                        products.map(product => <CardItem key={product.clothesId} products={product} />)
                    ) : (
                        <p>No products found.</p>
                    )}
                </Row>
            </Container>





            {/* 
            <Container>
                <Row>
                    {
                        products.map(function (a, i) {
                            return (
                                <CardItem products={a} key={a.clothesId} alt={a.name} navigate={navigate}></CardItem>
                                // navigate 꼭 넘겨줘야함?
                            )
                        })
                    }
                </Row>
                <Row>
                    <div className="d-flex justify-content-center" style={{ marginTop: '50px' }}>
                        <Pagination>
                            <Pagination.First />
                            <Pagination.Prev />
                            <Pagination.Item active>{1}</Pagination.Item>
                            <Pagination.Item>{12}</Pagination.Item>
                            <Pagination.Item>{13}</Pagination.Item>
                            <Pagination.Ellipsis />
                            <Pagination.Item>{20}</Pagination.Item>
                            <Pagination.Next />
                            <Pagination.Last />
                        </Pagination>
                    </div>
                </Row>
            </Container> */}





        </div>
    );
};

export default SearchResults;
