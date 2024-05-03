import { createSlice } from '@reduxjs/toolkit'

let initialState = {
    isLoggedIn: false,
    sellerInfo: null,
    isPwConfirm: false,   // 회원정보 수정시 사용할 비밀번호 확인 여부
    isLoading: true,
};

let sellerSlice = createSlice({
    name: 'seller',
    initialState: initialState,
    reducers: {
        // 로딩 상태 설정
        setSellerLoading(state, action) {
            state.isLoading = action.payload;
          },
        // 로그인 액션
        sellerLogin(state, action) {
            state.isLoggedIn = true;
            state.sellerInfo = action.payload; // payload는 로그인한 사용자 정보를 포함
            state.isPwConfirm = false;
            state.isLoading = false;
        },
        // 로그아웃 액션
        sellerLogout(state) {
            state.isLoggedIn = false;
            state.sellerInfo = null;
            state.isPwConfirm = false;
            state.isLoading = false;
        },
        // 프로필 업데이트 액션
        sellerUpdateProfile(state, action) {
            if (state.isLoggedIn && state.sellerInfo) {
                state.sellerInfo = { ...state.sellerInfo, ...action.payload }; // payload는 업데이트할 사용자 정보를 포함
                state.isPwConfirm = false;
            }
        },
        // 회원정보 수정 시 비밀번호 확인 액션
        sellerPwConfirm(state, action) {
            state.isPwConfirm = true;
        },
        // 회원정보 수정 완료 시 isPwConfirm 초기화
        sellerPwConfirmReset(state, action) {
            state.isPwConfirm = false;
        }
    }
})

export let { setSellerLoading, sellerLogin, sellerLogout, sellerUpdateProfile, sellerPwConfirm, sellerPwConfirmReset } = sellerSlice.actions;

export default sellerSlice;