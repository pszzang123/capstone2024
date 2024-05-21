import { useEffect, useState } from "react";
import { Navbar, Container, Nav, Row, Col, Dropdown } from 'react-bootstrap';
import './../App.css';
import { useNavigate } from 'react-router-dom';
import axios from 'axios'
import { Link } from 'react-router-dom';
import CardItem from "./CardItem.js";
import "firebase/firestore";
import { useParams } from 'react-router-dom';

// 카테고리 데이터
const categoriesData = {
  male: [
    { id: 1, name: "아우터" },
    { id: 2, name: "정장" },
    { id: 3, name: "팬츠" },
    { id: 4, name: "재킷/베스트" },
    { id: 5, name: "셔츠" },
    { id: 6, name: "니트" },
    { id: 7, name: "티셔츠" },
    { id: 8, name: "패션잡화" },
    { id: 9, name: "언더웨어" },
    { id: 10, name: "쥬얼리/시계" },
    { id: 16, name: "키즈아우터" },
    { id: 17, name: "키즈티셔츠" },
    { id: 18, name: "키즈셔츠(남아)" },
    { id: 20, name: "키즈니트" },
    { id: 21, name: "키즈팬츠" },
    { id: 22, name: "슈즈" }
  ],
  female: [
    { id: 1, name: "아우터" },
    { id: 2, name: "재킷/베스트" },
    { id: 3, name: "팬츠" },
    { id: 6, name: "니트" },
    { id: 7, name: "티셔츠" },
    { id: 8, name: "패션잡화" },
    { id: 10, name: "쥬얼리/시계" },
    { id: 11, name: "셔츠/블라우스" },
    { id: 12, name: "원피스" },
    { id: 13, name: "스커트" },
    { id: 14, name: "라운지/언더웨어" },
    { id: 15, name: "비치웨어" },
    { id: 16, name: "키즈아우터" },
    { id: 17, name: "키즈티셔츠" },
    { id: 19, name: "키즈셔츠/키즈블라우스(여아)" },
    { id: 20, name: "키즈니트" },
    { id: 21, name: "키즈팬츠" },
    { id: 22, name: "슈즈" }
  ]
};

// 카테고리 상세 데이터
const categoriesDetailData = [
  {
    "subCategoryId": 1,
    "majorCategoryId": 1,
    "name": "점퍼"
  },
  {
    "subCategoryId": 2,
    "majorCategoryId": 1,
    "name": "코트"
  },
  {
    "subCategoryId": 3,
    "majorCategoryId": 1,
    "name": "다운/패딩"
  },
  {
    "subCategoryId": 4,
    "majorCategoryId": 1,
    "name": "래더재킷"
  },
  {
    "subCategoryId": 5,
    "majorCategoryId": 1,
    "name": "퍼"
  },
  {
    "subCategoryId": 6,
    "majorCategoryId": 2,
    "name": "정장재킷"
  },
  {
    "subCategoryId": 7,
    "majorCategoryId": 2,
    "name": "정장팬츠"
  },
  {
    "subCategoryId": 8,
    "majorCategoryId": 2,
    "name": "드레스셔츠"
  },
  {
    "subCategoryId": 9,
    "majorCategoryId": 2,
    "name": "정장베스트"
  },
  {
    "subCategoryId": 10,
    "majorCategoryId": 3,
    "name": "치노"
  },
  {
    "subCategoryId": 11,
    "majorCategoryId": 3,
    "name": "슬렉스"
  },
  {
    "subCategoryId": 12,
    "majorCategoryId": 3,
    "name": "수트팬츠"
  },
  {
    "subCategoryId": 13,
    "majorCategoryId": 3,
    "name": "조거/스웻"
  },
  {
    "subCategoryId": 14,
    "majorCategoryId": 3,
    "name": "데님"
  },
  {
    "subCategoryId": 15,
    "majorCategoryId": 3,
    "name": "쇼츠"
  },
  {
    "subCategoryId": 16,
    "majorCategoryId": 3,
    "name": "와이드팬츠"
  },
  {
    "subCategoryId": 17,
    "majorCategoryId": 3,
    "name": "스트레이트팬츠"
  },
  {
    "subCategoryId": 18,
    "majorCategoryId": 3,
    "name": "슬림"
  },
  {
    "subCategoryId": 19,
    "majorCategoryId": 3,
    "name": "조거"
  },
  {
    "subCategoryId": 20,
    "majorCategoryId": 4,
    "name": "재킷"
  },
  {
    "subCategoryId": 21,
    "majorCategoryId": 4,
    "name": "블레이저"
  },
  {
    "subCategoryId": 22,
    "majorCategoryId": 4,
    "name": "래더재킷"
  },
  {
    "subCategoryId": 23,
    "majorCategoryId": 4,
    "name": "베스트"
  },
  {
    "subCategoryId": 24,
    "majorCategoryId": 5,
    "name": "긴팔셔츠"
  },
  {
    "subCategoryId": 25,
    "majorCategoryId": 5,
    "name": "반팔셔츠"
  },
  {
    "subCategoryId": 26,
    "majorCategoryId": 6,
    "name": "풀오버"
  },
  {
    "subCategoryId": 27,
    "majorCategoryId": 6,
    "name": "카디건"
  },
  {
    "subCategoryId": 28,
    "majorCategoryId": 6,
    "name": "베스트"
  },
  {
    "subCategoryId": 29,
    "majorCategoryId": 7,
    "name": "반팔티셔츠"
  },
  {
    "subCategoryId": 30,
    "majorCategoryId": 7,
    "name": "긴팔티셔츠"
  },
  {
    "subCategoryId": 31,
    "majorCategoryId": 7,
    "name": "민소매"
  },
  {
    "subCategoryId": 32,
    "majorCategoryId": 8,
    "name": "모자"
  },
  {
    "subCategoryId": 33,
    "majorCategoryId": 8,
    "name": "벨트"
  },
  {
    "subCategoryId": 34,
    "majorCategoryId": 8,
    "name": "스카프/머플러"
  },
  {
    "subCategoryId": 35,
    "majorCategoryId": 8,
    "name": "양말"
  },
  {
    "subCategoryId": 36,
    "majorCategoryId": 9,
    "name": "언더웨어"
  },
  {
    "subCategoryId": 37,
    "majorCategoryId": 10,
    "name": "쥬얼리"
  },
  {
    "subCategoryId": 38,
    "majorCategoryId": 10,
    "name": "귀걸이"
  },
  {
    "subCategoryId": 39,
    "majorCategoryId": 10,
    "name": "목걸이"
  },
  {
    "subCategoryId": 40,
    "majorCategoryId": 10,
    "name": "반지"
  },
  {
    "subCategoryId": 41,
    "majorCategoryId": 10,
    "name": "시계"
  },
  {
    "subCategoryId": 42,
    "majorCategoryId": 11,
    "name": "셔츠"
  },
  {
    "subCategoryId": 43,
    "majorCategoryId": 11,
    "name": "블라우스"
  },
  {
    "subCategoryId": 44,
    "majorCategoryId": 12,
    "name": "긴팔"
  },
  {
    "subCategoryId": 45,
    "majorCategoryId": 12,
    "name": "반팔/민소매"
  },
  {
    "subCategoryId": 46,
    "majorCategoryId": 13,
    "name": "롱/미디"
  },
  {
    "subCategoryId": 47,
    "majorCategoryId": 13,
    "name": "미니"
  },
  {
    "subCategoryId": 48,
    "majorCategoryId": 14,
    "name": "파자마"
  },
  {
    "subCategoryId": 49,
    "majorCategoryId": 14,
    "name": "로브"
  },
  {
    "subCategoryId": 50,
    "majorCategoryId": 14,
    "name": "브라"
  },
  {
    "subCategoryId": 51,
    "majorCategoryId": 14,
    "name": "팬티"
  },
  {
    "subCategoryId": 52,
    "majorCategoryId": 14,
    "name": "세트"
  },
  {
    "subCategoryId": 53,
    "majorCategoryId": 15,
    "name": "스윔수트"
  },
  {
    "subCategoryId": 54,
    "majorCategoryId": 15,
    "name": "비키니"
  },
  {
    "subCategoryId": 55,
    "majorCategoryId": 16,
    "name": "다운/패딩"
  },
  {
    "subCategoryId": 56,
    "majorCategoryId": 16,
    "name": "점퍼"
  },
  {
    "subCategoryId": 57,
    "majorCategoryId": 16,
    "name": "코트"
  },
  {
    "subCategoryId": 58,
    "majorCategoryId": 16,
    "name": "재킷/베스트"
  },
  {
    "subCategoryId": 59,
    "majorCategoryId": 17,
    "name": "긴팔"
  },
  {
    "subCategoryId": 60,
    "majorCategoryId": 17,
    "name": "반팔/민소매"
  },
  {
    "subCategoryId": 61,
    "majorCategoryId": 18,
    "name": "긴팔"
  },
  {
    "subCategoryId": 62,
    "majorCategoryId": 18,
    "name": "반팔"
  },
  {
    "subCategoryId": 63,
    "majorCategoryId": 19,
    "name": "긴팔"
  },
  {
    "subCategoryId": 64,
    "majorCategoryId": 19,
    "name": "반팔"
  },
  {
    "subCategoryId": 65,
    "majorCategoryId": 20,
    "name": "풀오버"
  },
  {
    "subCategoryId": 66,
    "majorCategoryId": 20,
    "name": "카디건/베스트"
  },
  {
    "subCategoryId": 67,
    "majorCategoryId": 21,
    "name": "롱팬츠"
  },
  {
    "subCategoryId": 68,
    "majorCategoryId": 21,
    "name": "쇼트팬츠"
  },
  {
    "subCategoryId": 69,
    "majorCategoryId": 22,
    "name": "운동화/스니커즈"
  },
  {
    "subCategoryId": 70,
    "majorCategoryId": 22,
    "name": "워커/부츠"
  },
  {
    "subCategoryId": 71,
    "majorCategoryId": 22,
    "name": "슬리퍼/뮬"
  },
  {
    "subCategoryId": 72,
    "majorCategoryId": 22,
    "name": "슬립온"
  },
  {
    "subCategoryId": 73,
    "subCategoryId": 22,
    "name": "구두"
  },
  {
    "subCategoryId": 74,
    "majorCategoryId": 22,
    "name": "샌들"
  },
  {
    "subCategoryId": 75,
    "majorCategoryId": 22,
    "name": "등산화/골프화"
  },
  {
    "subCategoryId": 76,
    "majorCategoryId": 22,
    "name": "펌프스/힐"
  },
  {
    "subCategoryId": 77,
    "majorCategoryId": 22,
    "name": "플랫/로퍼"
  }
];


function ItemList(props) {

  const { gender, major, minor } = useParams();
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [sortOrder, setSortOrder] = useState('인기상품순');
  const navigate = useNavigate();

  // fade 애니메이션
  let [fade1, setFade1] = useState('');

  useEffect(() => {
    let t = setTimeout(() => { setFade1('end') }, 500)
    return () => {
      clearTimeout(t)
      setFade1('')
    }
  }, [gender, major, minor])

  useEffect(() => {
    const validateCategory = async () => {
      if (!categoriesData[gender]) {
        console.error("Invalid gender specified.");
        navigate('/'); 
        return;
      }

      if (major && !categoriesData[gender].some(cat => cat.id === parseInt(major))) {
        console.error("Invalid major category ID");
        navigate('/'); 
        return;
      }

      if (minor && !categoriesDetailData.some(subcat => subcat.subCategoryId === parseInt(minor))) {
        console.error("Invalid minor category ID");
        navigate('/');
        return;
      }

      fetchProducts(gender, major, minor);
    };

    validateCategory();
  }, [gender, major, minor, navigate]);


  function generateCategoryLinks() {
    if (!categoriesData[gender]) {
      console.error("Invalid gender specified.");
      return null;
    }

    if (minor || major) {
      const majorId = major ? parseInt(major) : categoriesDetailData.find(item => item.subCategoryId === parseInt(minor)).majorCategoryId;
      const filteredMinors = categoriesDetailData.filter(item => item.majorCategoryId === majorId);

      return filteredMinors.map(subcat => (
        <Nav.Link key={subcat.subCategoryId} onClick={() => navigate(`/itemlist/${gender}/${major}/${subcat.subCategoryId}`)}>{subcat.name}</Nav.Link>
      ));
    } else if (gender) {
      return categoriesData[gender].map(subcat => (
        <Nav.Link key={subcat.id} onClick={() => navigate(`/itemlist/${gender}/${subcat.id}`)}>{subcat.name}</Nav.Link>
      ));
    }
  }


  const categoryLinks = generateCategoryLinks();
  async function fetchProducts(gender, major, minor) {
    setLoading(true); 
    setError(null); 
    let url = `${process.env.REACT_APP_API_URL}/clothes`;

    let params = new URLSearchParams();
    if (gender === 'male' || gender === 'female') {
      const genderValue = gender === 'male' ? 0 : 1;
      params.append('gender', genderValue);
    } else {
      navigate('/itemlist/male');
    }


    if (major) {
      params.set('major_category', major); 
    }
    if (minor) {
      params.append('sub_category', minor);
    }

    url += `?${params.toString()}`;

    axios.get(url)
      .then((response1) => {
        axios.put(`${process.env.REACT_APP_API_URL}/clothes/sort/1`, response1.data)
          .then((response2) => {
            setProducts(response2.data || []); 
            setLoading(false); 
          })
          .catch((error) => {
            console.error('상품 정렬 실패:', error);
            setError(error);
            setLoading(false);
          })
      })
      .catch((error) => {
        console.error('상품 불러오기 실패:', error);
        setError(error);
        setLoading(false);
      })

  }

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;


  const getMajorName = (majorId) => {
    const majorData = categoriesData[gender]?.find(cat => cat.id === parseInt(majorId));
    return majorData ? majorData.name : 'Unknown Category';
  };

  const getMinorName = (minorId) => {
    const minorData = categoriesDetailData.find(item => item.subCategoryId === parseInt(minorId));
    return minorData ? minorData.name : 'Category';
  };

  const displayCategoryName = () => {
    if (minor) {
      return getMinorName(minor);
    } else if (major) {
      return getMajorName(major);
    } else {
      return gender === 'male' ? '남성 의류' : '여성 의류';
    }
  };

  const sortProducts = async (sortKey, sortText) => {
    try {
      const response = await axios.put(`${process.env.REACT_APP_API_URL}/clothes/sort/${sortKey}`, products);
      console.log("정렬 상품:", response.data);
      setProducts(response.data || []); 
      setSortOrder(sortText);
    } catch (error) {
      console.error('상품 정렬 실패:', error);
    }
  };

  return (
    <div className={"start " + fade1}>
      <Container>
        <Row className="justify-content-start" style={{ fontSize: '12px', color: 'gray', margin: '10px 15px' }}>
          <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'left' }}>
            <Link to="/" style={{ color: !gender ? 'black' : 'gray', textDecoration: 'none', marginRight: '5px' }}>
              홈
            </Link>
            {gender && (
              <>
                <span>&gt;</span>
                <Link to={`/itemlist/${gender}`} style={{ color: !major ? 'black' : 'gray', textDecoration: 'none', margin: '0 5px' }}>
                  {gender === 'male' ? '남성 의류' : '여성 의류'}
                </Link>
              </>
            )}
            {major && (
              <>
                <span>&gt;</span>
                <Link to={`/itemlist/${gender}/${major}`} style={{ color: !minor ? 'black' : 'gray', textDecoration: 'none', margin: '0 5px' }}>
                  {getMajorName(major)}
                </Link>
              </>
            )}
            {minor && (
              <>
                <span>&gt;</span>
                <Link to={`/itemlist/${gender}/${major}/${minor}`} style={{ color: 'black', textDecoration: 'none', margin: '0 5px' }}>
                  {getMinorName(minor)}
                </Link>
              </>
            )}
          </Col>
        </Row>
      </Container>

      <Container>
        <Row>
          <Col xs={6} md={6}>
            <div style={{ textAlign: 'left', fontSize: '40px', fontWeight: '700', margin: '20px 0 10px 0' }}>{displayCategoryName()}</div>
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
                <Nav className="me-auto" style={{ flexWrap: 'wrap' }}>
                  {categoryLinks}
                </Nav>
              </Container>
            </Navbar>
          </Col>
        </Row>

      </Container>

      <Container>

        <Row className="justify-content-end">
          <Col xs={12} md={12} className="text-nowrap" style={{ textAlign: 'right', marginBottom: '10px' }}>
            <Dropdown>
              <Dropdown.Toggle
                variant="success"
                id="dropdown-basic"
                className="bg-transparent border-0 text-dark btn-sm" 
              >{sortOrder}
              </Dropdown.Toggle>
              <Dropdown.Menu align="end">
                <Dropdown.Item onClick={() => sortProducts('1', '인기상품순')}>인기상품순</Dropdown.Item>
                <Dropdown.Item onClick={() => sortProducts('2', '신상품순')}>신상품순</Dropdown.Item>
                <Dropdown.Item onClick={() => sortProducts('3', '댓글순')}>댓글순</Dropdown.Item>
                <Dropdown.Item onClick={() => sortProducts('4', '좋아요순')}>좋아요순</Dropdown.Item>
                <Dropdown.Item onClick={() => sortProducts('5', '조회수순')}>조회수순</Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
          </Col>
        </Row>
      </Container>

      <Container>
        <Row>
          {
            (Array.isArray(products) ? products : []).map(function (a, i) {
              return (
                <CardItem products={a} key={a.clothesId} alt={a.name} navigate={navigate}></CardItem>
              )
            })
          }
        </Row>
      </Container>
    </div>
  )
}

export default ItemList;
