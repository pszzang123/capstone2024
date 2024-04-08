import axios from "axios";
import { useState } from "react";
import Button from 'react-bootstrap/Button';
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { logout } from "../store/userSlice";


function DeleteCustomer(props) {

    let dispatch = useDispatch();
    let { userInfo, isLoggedIn } = useSelector((state) => state.user);

    let navigate = useNavigate();
    
    let deleteCustClicked = () => {
        axios.delete(`http://localhost:8080/customers/${userInfo.email_id}`)
        .then((result)=>{
            dispatch(logout());
            console.log('회원탈퇴 성공');
            alert('회원탈퇴 성공');
            navigate('/');
        })
        .catch((error)=>{
            console.error('회원탈퇴 실패', error);
        })
    }

    return(
        <div>
            <div style={{ fontSize: '15px', fontWeight: '500', textAlign:'left' }}>
            회원님은 현재 {userInfo != null ? userInfo.email_id : ''}로 로그인하셨습니다.<br></br>
            정말로 회원 탈퇴하시겠습니까?
            </div>
            <div style={{textAlign:'left'} }>
            <Button variant="danger" onClick={deleteCustClicked}>회원탈퇴</Button>
            </div>
        </div>
    )
}

export default DeleteCustomer;