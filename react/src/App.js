import { lazy, Suspense, useEffect } from "react";
import './App.css';
import { Routes, Route, useNavigate } from 'react-router-dom';
import { useDispatch } from "react-redux";
import { login, logout, setUserLoading } from "./store/userSlice.js";
import { sellerLogin, sellerLogout, setSellerLoading } from "./store/sellerSlice.js";

import UserLayout from "./pages/UserLayout.js";
import Main from "./pages/Main.js";

const ProductRegistration = lazy(() => import("./pages/ProductRegistration.js"));
const SellerLogin = lazy(() => import("./pages/SellerLogin.js"));
const SellerLayout = lazy(() => import("./pages/SellerLayout.js"));
const ProductList = lazy(() => import("./pages/ProductList.js"));
const OrderManagement = lazy(() => import("./pages/OrderManagement.js"));
const StatisticsAnalysis = lazy(() => import("./pages/StatisticsAnalysis.js"));
const SellerJoin = lazy(() => import("./pages/SellerJoin.js"));
const Checkout = lazy(() => import("./pages/Checkout.js"));
const OrderComplete = lazy(() => import("./pages/OrderComplete.js"));
const SearchResults = lazy(() => import("./pages/SearchResults.js"));
const OrderDeliveryStatus = lazy(() => import("./pages/OrderDeliveryStatus.js"));
const OrderDetails = lazy(() => import("./pages/OrderDetails.js"));
const ProtectedRoute = lazy(() => import("./pages/ProtectedRoute.js"));
const ProtectedRouteSeller = lazy(() => import("./pages/ProtectedRouteSeller.js"));
const DeleteCustomer = lazy(() => import("./pages/DeleteCustomer.js"));
const ItemList = lazy(() => import("./pages/ItemList.js"));
const Login = lazy(() => import("./pages/Login.js"));
const Join = lazy(() => import("./pages/Join.js"));
const Mypage = lazy(() => import("./pages/Mypage.js"));
const ProductEdit = lazy(() => import("./pages/ProductEdit.js"));
const UpdateCustomer = lazy(() => import("./pages/UpdateCustomer.js"));
const PwConfirm = lazy(() => import("./pages/PwConfirm.js"));
const Cart = lazy(() => import('./pages/Cart.js'));
const Detail = lazy(() => import('./pages/Detail.js'));
const Comments = lazy(() => import('./pages/Comments.js'));
const LikesPage = lazy(() => import('./pages/LikesPage.js'));

function App() {

  let dispatch = useDispatch();


  
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
           

            <Route path="/itemlist/:gender" element={<ItemList />}>
              <Route path=":major" element={<ItemList />}>
                <Route path=":minor" element={<ItemList />} />
              </Route>
            </Route>

            <Route path="/cart" element={<Cart />} />
            <Route path="/login" element={<Login />} />
            <Route path="/join" element={<Join />} />
            <Route path="/productedit" element={<ProductEdit />} />
            <Route path="/likespage" element={<LikesPage />} />

            {/* <Route path="/mypage" element={<Mypage />} > */}
            <Route path="/mypage" element={<ProtectedRoute><Mypage /></ProtectedRoute>}>
              <Route path="orderdeliverystatus" element={<OrderDeliveryStatus />} />
              <Route path="orderdeliverystatus/orderdetails/:receiptId" element={<OrderDetails />} />
              <Route path="deletecustomer" element={<DeleteCustomer />} />
              <Route path="updatecustomer" element={<UpdateCustomer />} />
              <Route path="pwconfirm" element={<PwConfirm />} />
              <Route path="comments" element={<Comments />} />
            </Route>
          </Route>

          <Route path="/seller" element={<SellerLayout />}>
            <Route index path="login" element={<SellerLogin />} />
            <Route path="*" element={<div>없는 페이지입니다.</div>} />
            <Route path="sellerjoin" element={<SellerJoin />} />
            <Route path="productregistration" element={<ProtectedRouteSeller><ProductRegistration /></ProtectedRouteSeller>} />
            <Route path="productlist" element={<ProtectedRouteSeller><ProductList /></ProtectedRouteSeller>} />
            <Route path="productedit/:editId" element={<ProtectedRouteSeller><ProductEdit /></ProtectedRouteSeller>} />
            <Route path="ordermanagement" element={<ProtectedRouteSeller><OrderManagement /></ProtectedRouteSeller>} />
            <Route path="statisticsanalysis" element={<ProtectedRouteSeller><StatisticsAnalysis /></ProtectedRouteSeller>} />
          </Route>
        </Routes>
      </Suspense>
    </div>
  );
}



export default App;
