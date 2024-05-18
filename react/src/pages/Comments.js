import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { Col, Container, Row } from 'react-bootstrap';

function Comments() {
    const [comments, setComments] = useState([]);
    const navigate = useNavigate();

    let { userInfo, isLoggedIn, isLoading } = useSelector((state) => state.user);

    useEffect(() => {
        if (!isLoading && !isLoggedIn) {
            alert('로그인 후 이용해주세요.');
            navigate('/login');
        }
    }, [isLoggedIn, isLoading, navigate]);

    useEffect(() => {
        if (userInfo && userInfo.email_id) {
            axios.get(`${process.env.REACT_APP_API_URL}/comment/customer/${userInfo.email_id}`)
                .then(response => {
                    const comments = response.data;
                    const productDetailsRequests = comments.map(comment =>
                        axios.get(`${process.env.REACT_APP_API_URL}/clothes/${comment.clothesId}`)
                            .then(response => ({ ...comment, productName: response.data.name }))
                            .catch(error => ({ ...comment, productName: 'Unknown' })) // Handle error gracefully
                    );
                    Promise.all(productDetailsRequests)
                        .then(commentsWithProducts => setComments(commentsWithProducts));
                })
                .catch(error => {
                    console.error('Error fetching comments:', error);
                    alert('Failed to retrieve comments.');
                });
        }
    }, [userInfo]);

    if (comments.length === 0) return <div>Loading comments...</div>;

    if (isLoading) return <div>Loading...</div>; // 로딩 중 표시
    if (!isLoggedIn) return null; // 비로그인 상태에서는 아무것도 표시하지 않음

    return (
        <div>
        <Container>
            <Row>
                <Col md={{ span: 8, offset: 1 }} xs={12}>
                    <h1 style={{ fontSize: '30px', fontWeight: '700', marginBottom: '60px' }}>작성 댓글</h1>
                </Col>
            </Row>
            <Row>
                <Col md={{ span: 8, offset: 1 }} xs={12}>
                    {comments.length > 0 ? comments.map((comment, index) => (
                        <div key={index}>
                            <p><strong>상품명 :</strong> {comment.productName}</p>
                            <p><strong>작성 일시 :</strong> {comment.date}</p>
                            <p><strong>작성 댓글 :</strong> {comment.comment}</p>
                            <hr style={{ border: 0, height: '2px', background: '#000000' }} />
                        </div>
                    )) : <div>Loading comments...</div>}
                </Col>
            </Row>
        </Container>
    </div>
    );
}

export default Comments;