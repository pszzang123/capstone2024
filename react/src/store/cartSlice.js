import { createSlice } from '@reduxjs/toolkit'
import { logout } from './userSlice';

let initialState = {
    items: [],
};


let cartSlice = createSlice({
    name: 'cart',
    initialState: initialState,
    reducers: {
        setCartItems(state, action) {
            state.items = action.payload;
        },
        addToCart(state, action) {
            const existingItem = state.items.find(item => item.detailId === action.payload.detailId);
            if (existingItem) {
                existingItem.quantity += action.payload.quantity;
            } else {
                state.items.push(action.payload);
            }
        },
        removeFromCart(state, action) { // 완전 제거
            state.items = state.items.filter(item => item.detailId !== action.payload.detailId);
        },
        // 상품 수량 업데이트 리듀서
        updateItemQuantity(state, action) {
            const { detailId, quantity } = action.payload;
            const existingItem = state.items.find(item => item.detailId === detailId);
            if (existingItem) {
                existingItem.quantity = quantity;
            } else {
                // 상품이 존재하지 않는 경우의 처리
                console.warn(`Item with id ${detailId} not found.`);
            }
        },
        clearCart(state) {
            state.items = [];
        },
    },
    extraReducers: (builder) => {
        builder
            .addCase(logout, (state) => {
                state.items = [];
            });
    },
})

export let { setCartItems, addToCart, removeFromCart, updateItemQuantity, clearCart } = cartSlice.actions;

export default cartSlice;