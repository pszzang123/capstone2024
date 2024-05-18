import axios from 'axios';
import React, { useState, useEffect } from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import { Hidden } from 'react-grid-system';
import { useSelector } from 'react-redux';
import styled from 'styled-components';
import { FaHeart } from 'react-icons/fa6';
import { useNavigate } from 'react-router-dom';

const HeartButton = styled.button`
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 5px;
    width: ${props => props.likeCount > 999 ? '100px' : '80px'};
    height: 45px;
    border: 2px solid #ccc;
    border-radius: 30px;
    background: white;
    color: red;
    font-size: ${props => props.likeCount > 999 ? '22px' : '24px'};
    cursor: pointer;
    transition: all 0.3s ease;

    &:hover, &:focus {
        background: #ffcccc;
        border-color: red;
    }
`;

function LikeItem({ like, onDelete }) {

const navigate = useNavigate();

    const handleDelete = () => {
        const confirmDelete = window.confirm("상품을 위시리스트에서 제거하시겠습니까?");
        if(confirmDelete){
        axios.delete(`${process.env.REACT_APP_API_URL}/like/${like.customerEmail}/${like.clothesId}`)
            .then(() => {
                onDelete(like.clothesId);
            });
        }
    };

    return (
        <div style={{ fontSize: '18px', fontWeight: '600' }}>
            <Row>
                <Col xs={12} md={{ span: 1, offset: 1 }}>
                    <img src={like.imageUrl} alt={like.name} style={{ width: '100px', height: '132px', cursor:'pointer' }}
                    onClick={()=>{navigate(`/detail/${like.clothesId}`)}} />
                </Col>
                <Col xs={12} md={8}>
                    <p>{like.name}</p>
                </Col>
                <Col xs={12} md={1}>
                    <HeartButton onClick={handleDelete}>
                        <FaHeart />
                    </HeartButton>
                </Col>
            </Row>
            <Row>
                <Col xs={12} md={{ span: 10, offset: 1 }}>
                    <hr style={{ border: 0, height: '2px', background: 'gray' }} />
                </Col>
            </Row>
        </div>
    );
};

function LikesPage(props) {
    const [likes, setLikes] = useState([]);
    let { userInfo, isLoggedIn } = useSelector((state) => state.user);

    useEffect(() => {
        axios.get(`${process.env.REACT_APP_API_URL}/like/customer/${userInfo.email_id}`)
            .then(response => {
                const likesData = response.data;
                Promise.all(likesData.map(like => {
                    return Promise.all([
                        axios.get(`${process.env.REACT_APP_API_URL}/clothes/${like.clothesId}`),
                        axios.get(`${process.env.REACT_APP_API_URL}/clothes_images/${like.clothesId}`)
                    ]).then(([detailsResponse, imagesResponse]) => {
                        const details = detailsResponse.data;
                        const images = imagesResponse.data;
                        const primaryImage = images.find(image => image.order === 1);
                        return { ...like, ...details, imageUrl: primaryImage.imageUrl };
                    });
                })).then(results => setLikes(results));
            });
    }, []);

    const handleDeleteLike = (clothesId) => {
        setLikes(currentLikes => currentLikes.filter(like => like.clothesId !== clothesId));
    };

    return (
        <div>
            <br /> <br />

            <Container>
                <Row>
                    <Col xs={12} md={{ span: 10, offset: 1 }}>
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>위시리스트</h1>
                        <br /><br />
                    </Col>
                </Row>
                <Row>
                    <Hidden xs sm>
                        <Col md={{ span: 8, offset: 2 }} style={{ fontSize: '20px', fontWeight: '700' }}>
                            상품정보
                        </Col>
                    </Hidden>
                    <Hidden xs sm>
                        <Col md={1} style={{ whiteSpace: 'nowrap', fontSize: '20px', fontWeight: '700' }}>
                            주문금액
                        </Col>
                    </Hidden>
                </Row>
                <Row>
                    <Col xs={12} md={{ span: 10, offset: 1 }}>
                        <hr style={{ border: 0, height: '2px', background: '#000000' }} />
                    </Col>
                </Row>
                <Row>
                    {likes.map(like => (
                        <LikeItem
                            key={like.clothesId}
                            like={like} 
                            onDelete={handleDeleteLike} />
                    ))}
                </Row>
            </Container>
        </div>
    );
};

export default LikesPage;
