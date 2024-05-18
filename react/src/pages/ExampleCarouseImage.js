import React from 'react';
import { useNavigate } from 'react-router-dom';

const ExampleCarouselImage = ({ text, productName }) => {
  let navigate = useNavigate();
  return (
    <div style={{ width: '100%', height: 'auto', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
      <img src={process.env.PUBLIC_URL + '/img/' + productName + '.jpg'} alt={`캐러셀 슬라이드: ${text}`}
        className="carousel-img"
      />
    </div>
  );
};

export default ExampleCarouselImage;