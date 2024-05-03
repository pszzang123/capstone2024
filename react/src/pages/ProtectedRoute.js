import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useSelector } from 'react-redux';

function ProtectedRoute({ children }) {
    const { isLoggedIn, isLoading } = useSelector((state) => state.user);
    const location = useLocation();

    if (isLoading) {
        return <div>Loading...</div>;  // 로딩 중 표시, 필요에 따라 로딩 컴포넌트 적용 가능
    }

    if (!isLoggedIn) {
        // 로그인이 되어있지 않다면 로그인 페이지로 리디렉션
        return <Navigate to="/login" state={{ from: location }} replace />;
    }

    return children;
}

export default ProtectedRoute;
