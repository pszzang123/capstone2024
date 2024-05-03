import { useDispatch, useSelector } from "react-redux";
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Bar } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from 'chart.js';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

function StatisticsAnalysis(props) {
    let dispatch = useDispatch();
    let { sellerInfo, isLoggedIn } = useSelector((state) => state.seller);

    const [products, setProducts] = useState([]);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [statistics, setStatistics] = useState({});

    useEffect(() => {
        const fetchProducts = async () => {
            const response = await axios.get(`${process.env.REACT_APP_API_URL}/clothes/seller/${sellerInfo.email_id}`);
            setProducts(response.data);
            if (response.data.length > 0) {
                setSelectedProduct(response.data[0].clothesId);
            }
        };

        fetchProducts();
    }, []);

    useEffect(() => {
        const fetchStatistics = async () => {
            if (selectedProduct) {
                const response = await axios.get(`${process.env.REACT_APP_API_URL}/clothes/statistics/${selectedProduct}`);
                setStatistics(response.data);
            }
        };

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
        <div>
            <h1>통계 분석</h1>
            <select onChange={e => setSelectedProduct(e.target.value)}>
                {products.map(product => (
                    <option key={product.clothesId} value={product.clothesId}>{product.name}</option>
                ))}
            </select>
            <Bar data={data} options={{ responsive: true, scales: { y: { beginAtZero: true } } }} />
        </div>
    )
}

export default StatisticsAnalysis;