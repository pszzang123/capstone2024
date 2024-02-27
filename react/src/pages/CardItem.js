import { lazy, Suspense, useEffect, useState } from "react";
import { Button, Navbar, Container, Nav, Row, Col, Card, ButtonGroup, ButtonToolbar, Dropdown,Image,Pagination  } from 'react-bootstrap';
import './../App.css';
import bg from './../images/bg.png';
import data from '../data.js';
import { Routes, Route, useNavigate, Outlet } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import axios from 'axios'
import { useQuery } from "react-query";
import { setShoes } from '../store.js'
import { Link } from 'react-router-dom';
import Breadcrumb from 'react-bootstrap/Breadcrumb';


import productData from '../data/productData.json'


function CardItem(props) {
    const [isHovered, setHovered] = useState(false);
  
    const cardStyle = {
      height: '350px', // 고정된 높이 설정
      transition: 'box-shadow 0.3s', // 마우스 호버 시 표시되는 효과 설정
      boxShadow: isHovered ? '0 0 10px rgba(0,0,0,0.5)' : 'none', // 마우스 호버 시 box-shadow 변경
      marginBottom: '5px'
    };
  
    return (
      <Col xs={4} md={3} onClick={() => { props.navigate('/detail/' + props.index) }}>
        <Card style={cardStyle} className="border-0" onMouseOver={() => setHovered(true)} onMouseOut={() => setHovered(false)}>
          <Card.Img src={process.env.PUBLIC_URL + '/img/shoes' + (props.index + 1) + '.jpg'} width="80%" />
          <Card.Body>
            <Card.Title> {props.shoes.title} </Card.Title>
            <Card.Text>
              Some quick example text to build on the
            </Card.Text>
            <Card.Text>
              {props.shoes.price}원
            </Card.Text>
          </Card.Body>
        </Card>
      </Col>
    );
  }

  export default CardItem;