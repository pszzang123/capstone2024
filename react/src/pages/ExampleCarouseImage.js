import React from 'react';
import img1 from './../images/skirt1.jpg'
import Image from 'react-bootstrap/Image';


const ExampleCarouselImage = ({ text, productName }) => {
  return (
    <div>
      <img src={process.env.PUBLIC_URL + '/img/' + productName   + '.jpg'} alt={`캐러셀 슬라이드: ${text}`} 
      style={{maxWidth:'100%', maxHeight:'500px', width: 'auto', height: 'auto' }}/>
      
    </div>
  );
};

export default ExampleCarouselImage;