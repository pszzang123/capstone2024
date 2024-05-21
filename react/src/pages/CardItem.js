import { useEffect, useState } from "react";
import { Col, Card } from 'react-bootstrap';
import './../App.css';
import axios from 'axios'
import { LazyLoadImage } from "react-lazy-load-image-component";
import 'react-lazy-load-image-component/src/effects/blur.css'; // 필요한 CSS 효과

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
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'space-between'
  };

  return (
    // <Col xs={4} md={3} onClick={() => { props.navigate('/detail/' + props.products.clothesId) }}>
    //   <Card style={cardStyle} className="border-0" onMouseOver={() => setHovered(true)} onMouseOut={() => setHovered(false)}>
    //     <LazyLoadImage
    //       alt={props.products.name}
    //       src={imageUrl}
    //       effect="blur"
    //       style={{
    //         width: "100%",
    //         height: "200px",
    //         objectFit: "cover"
    //       }}
    //       loading="lazy"
    //     />
    //     <Card.Body
    //       style={{
    //         textAlign: 'left',
    //         flex: '1', display: 'flex',
    //         flexDirection: 'column',
    //         justifyContent: 'flex-start'
    //       }}>
    //       <Card.Text
    //         style={{
    //           fontWeight: '700',
    //           minHeight: '20px',
    //           marginBottom: '10px',
    //           fontSize: '18px'
    //         }}>
    //         {props.products.companyName}
    //       </Card.Text>
    //       <Card.Title style={{
    //         minHeight: '40px',
    //         marginBottom: '10px',
    //         fontSize: '18px',
    //         overflow: 'hidden',
    //         textOverflow: 'ellipsis',
    //         display: '-webkit-box',
    //         WebkitLineClamp: '2',
    //         WebkitBoxOrient: 'vertical',
    //         lineHeight: '20px',
    //       }}>
    //         {props.products.name}
    //       </Card.Title>
    //       <Card.Text style={{
    //          fontWeight: '700',
    //           minHeight: '20px', 
    //           fontSize: '18px' 
    //           }}>
    //         {props.products.price.toLocaleString()}원
    //       </Card.Text>
    //     </Card.Body>
    //   </Card>
    // </Col>
    <Col xs={4} md={3} onClick={() => { props.navigate('/detail/' + props.products.clothesId) }}>
      <Card className="border-0" style={cardStyle} onMouseOver={() => setHovered(true)} onMouseOut={() => setHovered(false)}>
        <LazyLoadImage
          alt={props.products.name}
          src={imageUrl}
          effect="blur"
          style={{
            width: "100%",
            height: "200px",
            objectFit: "cover"
          }}
          loading="lazy"
        />
         <Card.Body style={{ textAlign: 'left', flex: '1', display: 'flex', flexDirection: 'column', justifyContent: 'flex-start' }}>
          <Card.Text className="company-name">
            {props.products.companyName}
          </Card.Text>
          <Card.Title className="product-name">
            {props.products.name}
          </Card.Title>
          <Card.Text className="product-price">
            {props.products.price.toLocaleString()}원
          </Card.Text>
        </Card.Body>
      </Card>
    </Col>
  );
}

export default CardItem;