import { configureStore, createSlice } from '@reduxjs/toolkit'
import shoesdata from './data.js';

let shoes = createSlice({
    name: 'shoes',
    initialState: shoesdata,
    reducers: {
        setShoes(state, action) {
            return action.payload
        }
    }
})

export let { setShoes } = shoes.actions


let data = [
    { id: 0, name: 'White and Black', count: 2 },
    { id: 2, name: 'Grey Yordan', count: 1 }
]

let cartList = createSlice({
    name: 'cartList',
    initialState: data,
    reducers: {
        addCount(state, action) {
            let a = state.find(function (item) {
                return item.id == action.payload
            })
            a.count += 1
        },
        addItem(state, action) {
            let a = state.find(function (item) {
                return item.id == action.payload.id
            })
            if (a !== undefined) {
                a.count += 1
            } else {
                state.push(action.payload)
            }
        },
        deleteItem(state, action) {
            let a = state.find(function (item) {
                return item.id == action.payload
            })
            let index = state.indexOf(a)
            state.splice(index, 1)
        }
    }
})
export let { addCount, addItem, deleteItem } = cartList.actions

export default configureStore({
    reducer: {
        cartList: cartList.reducer,
        shoes: shoes.reducer
    }
})