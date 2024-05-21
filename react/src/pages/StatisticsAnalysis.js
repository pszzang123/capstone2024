import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useDispatch, useSelector } from 'react-redux';
import { Bar } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from 'chart.js';
import { Col, Container, Row } from "react-bootstrap";
import './StatisticsAnalysis.css'; 

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

function StatisticsAnalysis() {
    const dispatch = useDispatch();
    const { sellerInfo } = useSelector((state) => state.seller);
    const [products, setProducts] = useState([]);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [statistics, setStatistics] = useState({});
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        async function fetchProducts() {
            setLoading(true);
            try {
                const response = await axios.get(`${process.env.REACT_APP_API_URL}/clothes/seller/${sellerInfo.email_id}`);
                setProducts(response.data);
                setSelectedProduct(response.data.length > 0 ? response.data[0].clothesId : null);
            } catch (error) {
                console.error('상품 가져오기 실패', error);
            }
            setLoading(false);
        }
        fetchProducts();
    }, [sellerInfo.email_id]);

    useEffect(() => {
        async function fetchStatistics() {
            if (selectedProduct) {
                setLoading(true);
                try {
                    const response = await axios.get(`${process.env.REACT_APP_API_URL}/clothes/statistics/${selectedProduct}`);
                    setStatistics(response.data);
                } catch (error) {
                    console.error('통계 가져오기 실패', error);
                }
                setLoading(false);
            }
        }
        fetchStatistics();
    }, [selectedProduct]);

    const data = {
        labels: ['일간', '월간', '총계'],
        datasets: [
            {
                label: '판매량',
                data: [statistics.dailySales, statistics.monthlySales, statistics.totalSales],
                backgroundColor: 'rgba(255, 99, 132, 0.5)',
            },
            {
                label: '조회수',
                data: [statistics.dailyView, statistics.monthlyView, statistics.totalView],
                backgroundColor: 'rgba(54, 162, 235, 0.5)',
            },
            {
                label: '댓글 수',
                data: [statistics.dailyComment, statistics.monthlyComment, statistics.totalComment],
                backgroundColor: 'rgba(255, 206, 86, 0.5)',
            },
            {
                label: '좋아요',
                data: [statistics.dailyLike, statistics.monthlyLike, statistics.totalLike],
                backgroundColor: 'rgba(75, 192, 192, 0.5)',
            }
        ]
    };

    return (
        <Container className="mt-5">
            <Row>
                <Col className="text-center mb-4">
                    <h1 style={{ fontSize: '30px', fontWeight: '700' }}>통계 분석</h1>
                </Col>
            </Row>
            <Row className="select-container">
                <Col xs={12} md={6}>
                    <select className="form-control" value={selectedProduct} onChange={e => setSelectedProduct(e.target.value)}>
                        {products.map(product => (
                            <option key={product.clothesId} value={product.clothesId}>{product.name}</option>
                        ))}
                    </select>
                </Col>
            </Row>
            <Row>
                <Col>
                    {loading ? (
                        <p>Loading...</p>
                    ) : (
                        <Bar data={data} options={{ responsive: true, scales: { y: { beginAtZero: true } } }} />
                    )}
                </Col>
            </Row>
        </Container>
    );
}

export default StatisticsAnalysis;
