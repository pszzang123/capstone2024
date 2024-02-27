import { useParams } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Nav from 'react-bootstrap/Nav';
import { useDispatch, useSelector } from 'react-redux';
import { addItem } from '../store.js';

function Detail(props) {

    // Redux
    let state = useSelector((state) => { return state })
    let shoes = state.shoes
    let dispatch = useDispatch()

    // 탭 상태
    let [tab, setTab] = useState(0)

    // fade 애니메이션
    let [fade1, setFade1] = useState('')

    // 2초 이내 구매
    let [eventAlert, setEventAlert] = useState(true)

    let { id } = useParams();

    // 선택된 상품 데이터
    let selectedShoes = shoes.find(function (item) {
        return item.id == id
    });

    useEffect(() => {
        let a = JSON.parse(localStorage.getItem('watched'))
        a.push(selectedShoes.id)
        a = new Set(a)
        a = Array.from(a)
        localStorage.setItem('watched', JSON.stringify(a))

        setTimeout(() => { setEventAlert(false) }, 2000)

        let t = setTimeout(() => { setFade1('end') }, 100)
        return () => {
            clearTimeout(t)
            setFade1('')
        }
    }, [])


    return (
        <div className={"container start " + fade1}>
            {
                eventAlert == true
                    ? <div className="alert alert-warning"> 2초 이내 구매시 할인 </div>
                    : null
            }

            <div className="row">
                <div className="col-md-6">
                    <img src={process.env.PUBLIC_URL + '/img/shoes' + (selectedShoes.id + 1) + '.jpg'} width="100%" />
                </div>
                <div className="col-md-6">
                    <h4 className="pt-5">{selectedShoes.title}</h4>
                    <p>{selectedShoes.content}</p>
                    <p>{selectedShoes.price}원</p>
                    <button className="btn btn-danger" onClick={() => {
                        let item = { id: selectedShoes.id, name: selectedShoes.title, count: 1 }
                        dispatch(addItem(item))
                        alert(item.name + ' 장바구니에 추가되었습니다.')
                    }}>주문하기</button>
                </div>
            </div>

            <Nav variant="tabs" defaultActiveKey="link0">
                <Nav.Item>
                    <Nav.Link eventKey="link0" onClick={() => { setTab(0) }}>상품 정보</Nav.Link>
                </Nav.Item>
                <Nav.Item>
                    <Nav.Link eventKey="link1" onClick={() => { setTab(1) }}>판매자 정보</Nav.Link>
                </Nav.Item>
                <Nav.Item>
                    <Nav.Link eventKey="link2" onClick={() => { setTab(2) }}>상품 리뷰</Nav.Link>
                </Nav.Item>
            </Nav>
            <TabContent tab={tab} />

        </div>
    )
}


function TabContent({ tab }) {

    let [fade2, setFade2] = useState('')
    useEffect(() => {
        let a = setTimeout(() => { setFade2('end') }, 100)

        return () => {
            clearTimeout(a)
            setFade2('')
        }
    }, [tab])

    return (<div className={"start " + fade2}>
        {[<div>내용0</div>, <div>내용1</div>, <div>내용2</div>][tab]}
    </div>
    )
}


export default Detail;