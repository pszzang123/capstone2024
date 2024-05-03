import React from 'react';
import { useNavigate } from 'react-router-dom';


const ExampleCarouselImage = ({ text, productName }) => {
  let navigate = useNavigate();
  return (
    <div>
      <img onClick={()=>{navigate('/itemlist')}} src={process.env.PUBLIC_URL + '/img/' + productName   + '.jpg'} alt={`캐러셀 슬라이드: ${text}`} 
      style={{maxWidth:'100%', maxHeight:'500px', width: 'auto', height: 'auto' }}/>
      
    </div>
  );
};

export default ExampleCarouselImage;