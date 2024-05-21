import React from 'react';

const ExampleCarouselImage = ({ text, productName }) => {
  return (
    <div style={{ width: '100%', height: 'auto', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
      <img src={process.env.PUBLIC_URL + '/img/' + productName + '.jpg'} alt={`캐러셀 슬라이드: ${text}`}
        className="carousel-img"
      />
    </div>
  );
};

export default ExampleCarouselImage;