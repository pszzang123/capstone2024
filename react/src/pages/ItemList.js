import { lazy, Suspense, useEffect, useState } from "react";
import { Button, Navbar, Container, Nav, Row, Col, Card, ButtonGroup, ButtonToolbar, Dropdown, Image, Pagination } from 'react-bootstrap';
import './../App.css';
import bg from './../images/bg.png';
import data from './../data.js';
import { Routes, Route, useNavigate, Outlet } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import axios from 'axios'
import { useQuery } from "react-query";
import { Link } from 'react-router-dom';
import Breadcrumb from 'react-bootstrap/Breadcrumb';
import CardItem from "./CardItem.js";
import productData from './../data/productData.json'
import "firebase/firestore";
import { storage } from "../firebaseConfig.js";
import { useParams } from 'react-router-dom';


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

  const { category, major, minor } = useParams();

  // Redux
  // let shoes = useSelector((state) => { return state.shoes })
  const [products, setProducts] = useState([]);
  let dispatch = useDispatch()

  // useEffect(() => {
  //   fetchProducts({ category, major, minor }).then(data => {
  //     setProducts(data); // 상품 데이터를 상태에 저장
  //   });
  // }, [category, major, minor]); // 의존성 배열에 매개변수들을 포함시켜, 이들이 변할 때마다 useEffect가 실행되도록 합니다.
  useEffect(() => {
    fetchProducts({ category, major, minor })
      .then(data => {
        setProducts(data); // 상품 데이터를 상태에 저장
      })
      .catch(error => {
        console.error("Failed to fetch products:", error);
      });
  }, [category, major, minor]);



  // const fetchProducts = async (page) => {
  //   const response = await axios.get(`${process.env.REACT_APP_API_URL}/clothes`);
  //   setProducts(response.data); // 상품 목록 설정
  // };

  async function fetchProducts({ category, major, minor }) {
    // 서버의 상품 데이터 엔드포인트 URL. 실제 URL로 대체해야 합니다.
    let url = `${process.env.REACT_APP_API_URL}/clothes`;

    // category, major, minor 매개변수를 URL의 일부로 사용하여
    // 필터링할 상품의 범위를 지정합니다.
    // if (category) url += `/${category}`;
    // if (major) url += `/${major}`;
    // if (minor) url += `/${minor}`;
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 백엔드 변경되면 주석 풀기.
    try {
      const response = await axios.get(url);
      return response.data; // 서버로부터 받은 데이터를 반환합니다.
    } catch (error) {
      console.error("There was a problem with the axios request:", error);
      // throw error; // 에러를 다시 던져서 함수를 호출한 쪽에서 처리할 수 있도록 합니다.
    }
  }


  // 상품 state
  // data.js 에서 state 초기화
  // let [shoes, setShoes] = useState(data)


  // 더보기 버튼 카운트
  // let [btnCount, setBtnCount] = useState(0);

  // 더보기 로딩
  // let [loading, setLoading] = useState(false);

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

      {/* <Container>
        <Row className="justify-content-start" style={{ fontSize: '12px', color: 'gray', margin: '10px 15px' }}>
          <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'left' }}>
            <Link to="/" style={{ color: 'gray', textDecoration: 'none', marginRight: '5px' }}>홈</Link>
            <span>&gt;</span>
            <Link to="/detail" style={{ color: 'gray', textDecoration: 'none', margin: '0 5px' }}>남성</Link>
            <span>&gt;</span>
            <Link to="/detail" style={{ fontWeight: 'bold', color: 'black', textDecoration: 'none', margin: '0 5px' }}>티셔츠</Link>
          </Col>
        </Row>
      </Container> */}

<Container>
        <Row className="justify-content-start" style={{ fontSize: '12px', color: 'gray', margin: '10px 15px' }}>
          <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'left' }}>
            <Link to="/" style={{ color: !category ? 'black' : 'gray', textDecoration: 'none', marginRight: '5px' }}>
              홈
            </Link>
            {category && (
              <>
                <span>&gt;</span>
                <Link to={`/itemlist/${category}`} style={{ color: !major ? 'black' : 'gray', textDecoration: 'none', margin: '0 5px' }}>
                  {category}
                </Link>
              </>
            )}
            {major && (
              <>
                <span>&gt;</span>
                <Link to={`/itemlist/${category}/${major}`} style={{ color: !minor ? 'black' : 'gray', textDecoration: 'none', margin: '0 5px' }}>
                  {major}
                </Link>
              </>
            )}
            {minor && (
              <>
                <span>&gt;</span>
                <Link to={`/itemlist/${category}/${major}/${minor}`} style={{ color: 'black', textDecoration: 'none', margin: '0 5px' }}>
                  {minor}
                </Link>
              </>
            )}
          </Col>
        </Row>
      </Container>

      <Container>
        <Row>
          <Col xs={6} md={6}>
            <div style={{ textAlign: 'left', fontSize: '40px', fontWeight: '700', margin: '20px 0 10px 0' }}>남성</div>
          </Col>


        </Row>
        <Row>
          <Col>
            <div style={{ height: '2px', backgroundColor: '#000000' }}></div>
          </Col>
        </Row>

        <Row>
          <Col>
            <Navbar style={{ background: '#ffffff' }} data-bs-theme="light">
              <Container>
                <Nav className="me-auto">
                  <Nav.Link onClick={() => { navigate('/itemlist/1') }}>아우터</Nav.Link>
                  <Nav.Link onClick={() => { navigate('/itemlist/2') }}>정장</Nav.Link>
                  <Nav.Link onClick={() => { navigate('/itemlist/3') }}>팬츠</Nav.Link>
                  <Nav.Link onClick={() => { navigate('/itemlist/4') }}>재킷/베스트</Nav.Link>
                </Nav>
              </Container>
            </Navbar>
          </Col>
        </Row>

      </Container>




      <Container>
        <Row className="justify-content-end">
          <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'right', marginBottom:'10px' }}>
            <Dropdown>
              <Dropdown.Toggle
                variant="success"
                id="dropdown-basic"
                className="bg-transparent border-0 text-dark btn-sm" // 배경, 테두리 없애고 글씨는 검은색으로, 작은 크기
              >인기상품순 {'('} 전체 {')'}
              </Dropdown.Toggle>
              <Dropdown.Menu align="end">
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
            products.map(function (a, i) {
              return (
                <CardItem products={a} key={a.clothesId} alt={a.name} navigate={navigate}></CardItem>
                // navigate 꼭 넘겨줘야함?
              )
            })
          }
        </Row>
        <Row>
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
        </Row>
      </Container>

      {/* 더보기 버튼 처음 누르면 "https://codingapple1.github.io/shop/data2.json", 
            "https://codingapple1.github.io/shop/data3.json" 서버에서 데이터를 가져옴 */}
      {/* {(btnCount < 2)
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
      } */}
      {/* <Pagination currentPage={currentPage} totalPages={totalPages} /> */}




    </div>
  )
}


export default ItemList;