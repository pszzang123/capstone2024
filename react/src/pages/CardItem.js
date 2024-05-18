import { useEffect, useState } from "react";
import { Col, Card } from 'react-bootstrap';
import './../App.css';
import axios from 'axios'

function CardItem(props) {
  const [isHovered, setHovered] = useState(false);
  const [imageUrl, setImageUrl] = useState('');

  useEffect(() => {
    axios.get(`${process.env.REACT_APP_API_URL}/clothes_images/${props.products.clothesId}`)
      .then(response => {
        const orderOneImage = response.data.find(item => item.order === 1);
        if (orderOneImage) {
          setImageUrl(orderOneImage.imageUrl);
        }
      })
      .catch(error => console.log(error));
  }, [props.products]);

  if (!props.products) {
    return <div>Loading...</div>;
  }

  const cardStyle = {
    height: '340px',
    transition: 'box-shadow 0.3s',
    boxShadow: isHovered ? '0 0 10px rgba(0,0,0,0.5)' : 'none',
    marginBottom: '5px',
    display: 'flex', // Flex layout을 적용
    flexDirection: 'column', // 컴포넌트를 수직으로 정렬
    justifyContent: 'space-between' // 컴포넌트 사이의 공간을 균일하게 분배
  };

  return (
    <Col xs={4} md={3} onClick={() => { props.navigate('/detail/' + props.products.clothesId) }}>
      <Card style={cardStyle} className="border-0" onMouseOver={() => setHovered(true)} onMouseOut={() => setHovered(false)}>
        <Card.Img
          src={imageUrl}
          style={{
            width: "100%",
            height: "200px",
            objectFit: "cover"
          }}
          loading="lazy"
        />
        <Card.Body style={{ textAlign: 'left', flex: '1', display: 'flex', flexDirection: 'column', justifyContent: 'flex-start' }}>
          <Card.Text style={{ fontWeight: '700', minHeight: '20px', marginBottom: '10px', fontSize: '18px' }}>
            {props.products.companyName}
          </Card.Text>
          <Card.Title style={{
            minHeight: '40px',
            marginBottom: '10px',
            fontSize: '18px',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            display: '-webkit-box',
            WebkitLineClamp: '2', // 2줄만 표시
            WebkitBoxOrient: 'vertical',
            lineHeight: '20px', // 줄간격 설정
          }}>
            {props.products.name}
          </Card.Title>
          <Card.Text style={{ fontWeight: '700', minHeight: '20px', fontSize: '18px' }}>
            {props.products.price.toLocaleString()}원
          </Card.Text>
        </Card.Body>
      </Card>
    </Col>
  );
}

export default CardItem;