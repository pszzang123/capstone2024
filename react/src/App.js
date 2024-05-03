import { lazy, Suspense, useEffect, useState } from "react";
import { Button, Navbar, Container, Nav, Row, Col, Form, FormControl } from 'react-bootstrap';
import './App.css';
import { Routes, Route, useNavigate, Outlet, Link } from 'react-router-dom';
import axios from 'axios'
import { useQuery } from "react-query";
import ProductRegistration from "./pages/ProductRegistration.js";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSearch, faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons';
import { useDispatch, useSelector } from "react-redux";
import { login, logout, setUserLoading, setUserLoginState } from "./store/userSlice.js";
import Badge from 'react-bootstrap/Badge';
import { FaShoppingCart } from 'react-icons/fa';
import { BsCart2 } from "react-icons/bs";
import { FaUser } from "react-icons/fa";
import SellerLogin from "./pages/SellerLogin.js";
import Dashboard from "./pages/Dashboard.js";
import SellerLayout from "./pages/SellerLayout.js";
import UserLayout from "./pages/UserLayout.js";
import ProductList from "./pages/ProductList.js";
import OrderManagement from "./pages/OrderManagement.js";
import StatisticsAnalysis from "./pages/StatisticsAnalysis.js";
import SellerJoin from "./pages/SellerJoin.js";
import { sellerLogin, sellerLogout, setSellerLoading } from "./store/sellerSlice.js";
import Checkout from "./pages/Checkout.js";
import OrderComplete from "./pages/OrderComplete.js";
import SearchResults from "./pages/SearchResults.js";
import OrderDeliveryStatus from "./pages/OrderDeliveryStatus.js";
import OrderDetails from "./pages/OrderDetails.js";
import ProtectedRoute from "./pages/ProtectedRoute.js";
import ProtectedRouteSeller from "./pages/ProtectedRouteSeller.js";

const DeleteCustomer = lazy(() => import("./pages/DeleteCustomer.js"));
const Main = lazy(() => import("./pages/Main.js"));
const ItemList = lazy(() => import("./pages/ItemList.js"));
const Login = lazy(() => import("./pages/Login.js"));
const Join = lazy(() => import("./pages/Join.js"));
const Mypage = lazy(() => import("./pages/Mypage.js"));
const About = lazy(() => import("./pages/About.js"));
const ProductEdit = lazy(() => import("./pages/ProductEdit.js"));
const UpdateCustomer = lazy(() => import("./pages/UpdateCustomer.js"));
const PwConfirm = lazy(() => import("./pages/PwConfirm.js"));
const Cart = lazy(() => import('./pages/Cart.js'));
const Detail = lazy(() => import('./pages/Detail.js'));


function App() {

  let navigate = useNavigate();
  let dispatch = useDispatch();

  useEffect(() => {
    dispatch(setUserLoading(true));
    const userIsLoggedIn = localStorage.getItem('userIsLoggedIn') === 'true';
    const loginTime = parseInt(localStorage.getItem('userLoginTime'), 10);
    const now = new Date().getTime();
    const expirationTime = 60 * 60 * 1000; // 로그인 성공 후 1시간 지났으면 로그아웃
    // const expirationTime = 5 * 1000; // 테스트용, 로그인 후 5초 후 재접속 시 로그아웃
    const userData = JSON.parse(localStorage.getItem('userData'));

    if (userIsLoggedIn && (now - loginTime > expirationTime)) {
      // 로그인 시간이 유효 기간을 초과했을 경우 로그아웃 처리
      localStorage.removeItem('userIsLoggedIn');
      localStorage.removeItem('userLoginTime');
      localStorage.removeItem('userData');
      dispatch(logout()); // Redux 상태 업데이트
      alert('로그인 세션이 만료되었습니다. 다시 로그인 해주세요.');
      return;
    }

    if (userIsLoggedIn && userData) {
      dispatch(login({ 'email_id': userData }));
    } else {
      dispatch(logout());
    }
  }, [dispatch]);


  useEffect(() => {
    dispatch(setSellerLoading(true));
    const sellerIsLoggedIn = localStorage.getItem('sellerIsLoggedIn') === 'true';
    const loginTime = parseInt(localStorage.getItem('sellerLoginTime'), 10);
    const now = new Date().getTime();
    const expirationTime = 60 * 60 * 1000; // 로그인 성공 후 1시간 지났으면 로그아웃
    // const expirationTime = 5 * 1000; // 테스트용, 로그인 후 5초 후 재접속 시 로그아웃
    const sellerData = JSON.parse(localStorage.getItem('sellerData'));

    if (sellerIsLoggedIn && (now - loginTime > expirationTime)) {
      // 로그인 시간이 유효 기간을 초과했을 경우 로그아웃 처리
      localStorage.removeItem('sellerIsLoggedIn');
      localStorage.removeItem('sellerLoginTime');
      localStorage.removeItem('sellerData');
      dispatch(sellerLogout()); // Redux 상태 업데이트
      alert('로그인 세션이 만료되었습니다. 다시 로그인 해주세요.');
      navigate('/seller/login');
      return;
    }

    if (sellerIsLoggedIn && sellerData) {
      dispatch(sellerLogin({ 'email_id': sellerData }));
    } else {
      dispatch(sellerLogout());
    }
    // setLoading(false);  // 로딩 상태 업데이트
  }, [dispatch]);





  useEffect(() => {
    const updateLastAccessTime = (role) => {
      const currentTime = new Date().getTime();
      localStorage.setItem(`${role}LoginTime`, currentTime);
    };

    const checkAndUpdateLoginTime = () => {
      const isUserLoggedIn = localStorage.getItem('userIsLoggedIn') === 'true';
      const isSellerLoggedIn = localStorage.getItem('sellerIsLoggedIn') === 'true';

      if (isUserLoggedIn) {
        updateLastAccessTime('user');
      }
      if (isSellerLoggedIn) {
        updateLastAccessTime('seller');
      }
    };

    // 페이지가 닫힐 때와 탭이 백그라운드로 이동할 때 최종 접속 시간을 업데이트
    window.addEventListener('beforeunload', checkAndUpdateLoginTime);
    window.addEventListener('visibilitychange', () => {
      if (document.visibilityState === 'hidden') {
        checkAndUpdateLoginTime();
      }
    });

    // 컴포넌트 언마운트 시 이벤트 리스너 제거
    return () => {
      window.removeEventListener('beforeunload', checkAndUpdateLoginTime);
      window.removeEventListener('visibilitychange', checkAndUpdateLoginTime);
    };
  }, []); // 빈 의존성 배열을 사용하여 컴포넌트 마운트와 언마운트 시에만 실행


  return (
    <div>


      <Suspense fallback={<div>로딩중.......</div>}>
        <Routes>
          <Route path="/" element={<UserLayout />}>

            <Route index element={<Main />} />
            <Route path="/detail/:clothesId" element={<Detail />} />
            <Route path="/checkout" element={<Checkout />} />
            <Route path="search/:query" element={<SearchResults />} />
            <Route path="/ordercomplete" element={<OrderComplete />} />
            <Route path="*" element={<div>없는 페이지입니다.</div>} />
            <Route path="/about" element={<About />} >
              <Route path="member" element={<div> 멤버 페이지입니다. </div>} />
              <Route path="location" element={<div> 위치정보 페이지입니다. </div>} />
            </Route>

            <Route path="/itemlist" element={<ItemList />} />
            <Route path="/itemlist/:category" element={<ItemList />} />
            <Route path="/itemlist/:category/:major" element={<ItemList />} />
            <Route path="/itemlist/:category/:major/:minor" element={<ItemList />} />

            <Route path="/cart" element={<Cart />} />
            <Route path="/login" element={<Login />} />
            <Route path="/Join" element={<Join />} />
            <Route path="/ProductEdit" element={<ProductEdit />} />

            {/* <Route path="/mypage" element={<Mypage />} > */}
            <Route path="/mypage" element={<ProtectedRoute><Mypage /></ProtectedRoute>}>
              <Route path="orderdeliverystatus" element={<OrderDeliveryStatus />} />
              <Route path="orderdeliverystatus/orderdetails/:receiptId" element={<OrderDetails />} />
              <Route path="deleteCustomer" element={<DeleteCustomer />} />
              <Route path="updateCustomer" element={<UpdateCustomer />} />
              <Route path="PwConfirm" element={<PwConfirm />} />
            </Route>
          </Route>

          <Route path="/seller" element={<SellerLayout />}>
            <Route index path="login" element={<SellerLogin />} />
            <Route path="*" element={<div>없는 페이지입니다.</div>} />
            <Route path="sellerjoin" element={<SellerJoin />} />
            {/* <Route path="dashboard" element={<Dashboard />} /> */}
            <Route path="ProductRegistration" element={<ProtectedRouteSeller><ProductRegistration /></ProtectedRouteSeller>} />
            <Route path="productlist" element={<ProtectedRouteSeller><ProductList /></ProtectedRouteSeller>} />
            <Route path="productedit/:editid" element={<ProtectedRouteSeller><ProductEdit /></ProtectedRouteSeller>} />
            {/* <Route path="/seller/ordermanagement/orderdetailsseller/:receiptId" element={<ProtectedRouteSeller><OrderDetailsSeller /></ProtectedRouteSeller>} /> */}
            <Route path="ordermanagement" element={<ProtectedRouteSeller><OrderManagement /></ProtectedRouteSeller>} />
            <Route path="statisticsanalysis" element={<ProtectedRouteSeller><StatisticsAnalysis /></ProtectedRouteSeller>} />
          </Route>
        </Routes>
      </Suspense>

      {/* <div className="col-md-3 recent-items">
        <h5>최근 본 상품</h5>
        {recentItemId && recentItemId.length > 0 ? (
          <div>
            {recentItemId.map(function (a, i) {
              return (
                <div key={i}>
                  <img src={process.env.PUBLIC_URL + '/img/shoes' + (recentItemId[i] + 1) + '.jpg'} alt={`Shoe ${recentItemId[i] + 1}`} style={{ width: '100%', cursor: 'pointer' }}
                    onClick={() => {
                      navigate(`/detail/${recentItemId[i]}`)
                    }} />
                </div>
              );
            })}
          </div>
        ) : (
          <p>최근 본 상품이 없습니다.</p>
        )}
      </div> */}


    </div>
  );
}



export default App;
