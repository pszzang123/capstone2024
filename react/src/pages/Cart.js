import Table from 'react-bootstrap/Table';
import { useDispatch, useSelector } from 'react-redux';
import { addCount, deleteItem } from '../store.js';

function Cart(props) {

    // Redux
    let state = useSelector((state) => { return state })
    let cartList = state.cartList
    let dispatch = useDispatch()
    
    return (
        <div>
                        <br /> <br /> <br />
            
            
                        <h1 style={{ fontSize: '30px', fontWeight: '700' }}>장바구니</h1>
            
            <Table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>상품명</th>
                        <th>수량</th>
                        <th>수량 추가</th>
                        <th>제거</th>
                    </tr>
                </thead>
                <tbody>
                    {
                        cartList.map(function (a, i) {
                            return (
                                <tr key={i}>
                                    <td>{cartList[i].id}</td>
                                    <td>{cartList[i].name}</td>
                                    <td>{cartList[i].count}</td>
                                    <td>
                                        <button onClick={()=>{
                                            dispatch(addCount(cartList[i].id))
                                        }}>+</button>
                                    </td>
                                    <td><button onClick={()=>{
                                        dispatch(deleteItem(cartList[i].id))
                                    }}>X</button></td>
                                </tr>
                            )
                        })
                    }
                </tbody>
            </Table>
        </div>
    )
}

export default Cart;