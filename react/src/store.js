import { configureStore, createSlice } from '@reduxjs/toolkit'
import userSlice from './store/userSlice.js';
import cartSlice from './store/cartSlice.js';
import sellerSlice from './store/sellerSlice.js';

export default configureStore({
    reducer: {
        cart: cartSlice.reducer,
        user: userSlice.reducer,
        seller: sellerSlice.reducer,
    }
})