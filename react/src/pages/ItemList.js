import { lazy, Suspense, useEffect, useState } from "react";
import { Button, Navbar, Container, Nav, Row, Col, Card, ButtonGroup, ButtonToolbar, Dropdown,Image,Pagination  } from 'react-bootstrap';
import './../App.css';
import bg from './../images/bg.png';
import data from './../data.js';
import { Routes, Route, useNavigate, Outlet } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import axios from 'axios'
import { useQuery } from "react-query";
import { setShoes } from './../store.js'
import { Link } from 'react-router-dom';
import Breadcrumb from 'react-bootstrap/Breadcrumb';
import CardItem from "./CardItem.js";

import productData from './../data/productData.json'



// function Pagination({ currentPage, totalPages }) {
//   const pages = Array.from({ length: totalPages }, (_, index) => index + 1);

//   return (
//     <div>
//       <span> &lt; </span>
//       {pages.map((page) => (
//         <Link key={page} to={`/page/${page}`}>
//           <span className={currentPage === page ? 'active' : ''}>{' ' + page + ' '}</span>
//         </Link>
//       ))}
//       <span> ... {totalPages} &gt; </span>
//     </div>
//   );
// }


function ItemList(props) {

  // Redux
  let shoes = useSelector((state) => { return state.shoes })
  let dispatch = useDispatch()


  // 상품 state
  // data.js 에서 state 초기화
  // let [shoes, setShoes] = useState(data)


  // 더보기 버튼 카운트
  let [btnCount, setBtnCount] = useState(0);

  // 더보기 로딩
  let [loading, setLoading] = useState(false);

  let navigate = useNavigate();


  const totalPages = 27;
  const [currentPage, setCurrentPage] = useState(1);


  return (
    <div>

      {/* <div style={{ color: 'gray', display: 'flex', alignItems: 'center' }}>
        <Link to="/" style={{ color: 'gray', textDecoration: 'none', marginRight: '5px' }}>홈</Link>
        <span>&gt;</span>
        <Link to="/detail" style={{ color: 'gray', textDecoration: 'none', margin: '0 5px' }}>여성</Link>
        <span>&gt;</span>
        <Link to="/detail" style={{ color: 'gray', textDecoration: 'none', margin: '0 5px' }}>티셔츠</Link>
      </div> */}

      <Container>
        <Row className="justify-content-start" style={{ fontSize: '12px', color: 'gray', margin: '10px 15px' }}>
          <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'left' }}>
            <Link to="/" style={{ color: 'gray', textDecoration: 'none', marginRight: '5px' }}>홈</Link>
            <span>&gt;</span>
            <Link to="/detail" style={{ color: 'gray', textDecoration: 'none', margin: '0 5px' }}>남성</Link>
            <span>&gt;</span>
            <Link to="/detail" style={{ fontWeight: 'bold', color: 'black', textDecoration: 'none', margin: '0 5px' }}>티셔츠</Link>
          </Col>
        </Row>
      </Container>

      <Container>
        <Row className="justify-content-end">
          <Col xs={2} md={2}>
          <Dropdown>
          <Dropdown.Toggle
            variant="success"
            id="dropdown-basic"
            className="bg-transparent border-0 text-dark btn-sm" // 배경, 테두리 없애고 글씨는 검은색으로, 작은 크기
          >              인기상품순 {'('} 전체 {')'}
            </Dropdown.Toggle>
            <Dropdown.Menu>
              <Dropdown.Item href="#/action-1">신상품순</Dropdown.Item>
              <Dropdown.Item href="#/action-2">인기상품순</Dropdown.Item>
              <Dropdown.Item href="#/action-3">낮은가격순</Dropdown.Item>
              <Dropdown.Item href="#/action-4">높은가격순</Dropdown.Item>
              <Dropdown.Item href="#/action-5">높은할인율순</Dropdown.Item>
              <Dropdown.Item href="#/action-6">구매후기순</Dropdown.Item>
              <Dropdown.Item href="#/action-7">MD추천순</Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
          </Col>
        </Row>
      </Container>



      <Container>
        <Row>
          {
            shoes.map(function (a, i) {
              return (
                <CardItem shoes={shoes[i]} index={i} key={i} navigate={navigate}></CardItem>
              )
            })
          }
        </Row>
      </Container>

      {/* 더보기 버튼 처음 누르면 "https://codingapple1.github.io/shop/data2.json", 
            "https://codingapple1.github.io/shop/data3.json" 서버에서 데이터를 가져옴 */}
      {(btnCount < 2)
        ?
        <div>
          {loading && <p>@@ 로딩중입니다 @@</p>}
          <button onClick={() => {
            setLoading(true);
            axios.get('https://codingapple1.github.io/shop/data' + (btnCount + 2) + '.json')
              .then((result) => {
                setLoading(false);
                let copy = [...shoes, ...result.data];
                dispatch(setShoes(copy));
                setBtnCount(btnCount + 1);
              })
              .catch(() => {
                setLoading(false);
                console.log('데이터 가져오기 실패')
              })
          }}>더보기</button>
        </div>
        : null
      }
      {/* <Pagination currentPage={currentPage} totalPages={totalPages} /> */}


      <div className="d-flex justify-content-center" style={{ marginTop: '50px' }}>
      <Pagination>
      <Pagination.First />
      <Pagination.Prev />
      <Pagination.Item>{1}</Pagination.Item>
      <Pagination.Ellipsis />

      <Pagination.Item>{10}</Pagination.Item>
      <Pagination.Item>{11}</Pagination.Item>
      <Pagination.Item active>{12}</Pagination.Item>
      <Pagination.Item>{13}</Pagination.Item>
      <Pagination.Item disabled>{14}</Pagination.Item>

      <Pagination.Ellipsis />
      <Pagination.Item>{20}</Pagination.Item>
      <Pagination.Next />
      <Pagination.Last />
    </Pagination>
    </div>

    </div>
  )
}


export default ItemList;