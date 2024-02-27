import bg from './../images/bg.png';
import Carousel from 'react-bootstrap/Carousel';
import ExampleCarouselImage from './ExampleCarouseImage';
import CardItem from './CardItem';
import { setShoes } from './../store.js'
import { useState } from "react";
import { Container, Row, Col } from 'react-bootstrap';
import './../App.css';
import { useDispatch, useSelector } from 'react-redux';
import Nav from 'react-bootstrap/Nav';
import styled from 'styled-components'

import { useNavigate } from 'react-router-dom';
import axios from 'axios';

let RankingButton = styled.button`
    background : white;
    color : ${props => props.isActive ? 'black' : 'grey'};
    font-size: 18px;
    font-weight: 700;
    padding: 0px 20px 0px 20px;
    border: none;
    cursor: pointer;
    transition: color 0.3s;
    text-decoration: ${props => props.isActive ? 'underline' : 'none'};

    &:hover {
        color: black;
        text-decoration: underline;
      }
`

function Main(props) {
    const [index, setIndex] = useState(0);

    const handleSelect = (selectedIndex) => {
        setIndex(selectedIndex);
    };

    let shoes = useSelector((state) => { return state.shoes })
    let dispatch = useDispatch()
    let navigate = useNavigate();

    let [btnCountNew, setBtnCountNew] = useState(0);
    let [btnCountBest, setBtnCountBest] = useState(0);

    let [loading, setLoading] = useState(false);


    let [bestRanking, setBestRanking] = useState(0); // 클릭한 인기 카테고리
    let [newRanking, setNewRanking] = useState(0); // 클릭한 랭킹 카테고리

    return (
        <div>
            {/* <div className="main-bg" style={{ backgroundImage: 'url(' + bg + ')', marginBottom: '20px' }}></div> */}

            <Carousel activeIndex={index} onSelect={handleSelect}>
                <Carousel.Item>
                    <ExampleCarouselImage text="First slide" productName='sneakers1' />
                    <Carousel.Caption>
                        <h3>First slide label</h3>
                        <p>Nulla vitae elit libero, a pharetra augue mollis interdum.</p>
                    </Carousel.Caption>
                </Carousel.Item>
                <Carousel.Item>
                    <ExampleCarouselImage text="Second slide" productName='scarf1' />
                    <Carousel.Caption>
                        <h3>Second slide label</h3>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    </Carousel.Caption>
                </Carousel.Item>
                <Carousel.Item>
                    <ExampleCarouselImage text="Third slide" productName='beachwear1' />
                    <Carousel.Caption>
                        <h3>Third slide label</h3>
                        <p>
                            Praesent commodo cursus magna, vel scelerisque nisl consectetur.
                        </p>
                    </Carousel.Caption>
                </Carousel.Item>
            </Carousel>


            <br /> <br /> <br />
            
            
{/* 인기상품 */}
            <h1 style={{ fontSize: '30px', fontWeight: '700' }}>인기상품</h1>

            <br />

            <RankingButton onClick={() => { setBestRanking(0) }} isActive={bestRanking === 0}>여성</RankingButton>
            <RankingButton onClick={() => { setBestRanking(1) }} isActive={bestRanking === 1}>남성</RankingButton>
            <RankingButton onClick={() => { setBestRanking(2) }} isActive={bestRanking === 2}>키즈</RankingButton>
            <RankingButton onClick={() => { setBestRanking(3) }} isActive={bestRanking === 3}>슈즈</RankingButton>
            <br></br>
            <RankingConTent ranking={bestRanking}></RankingConTent>
            <br></br>


            <Container>
                <Row>
                    {
                        shoes.map(function (a, i) {
                            return (
                                <CardItem shoes={shoes[i]} index={i} key={i} navigate={navigate}></CardItem>
                            )
                        })
                    }
                </Row>
            </Container>

            {(btnCountBest < 2)
                ?
                <div>
                    {loading && <p>@@ 로딩중입니다 @@</p>}
                    <button onClick={() => {
                        setLoading(true);
                        axios.get('https://codingapple1.github.io/shop/data' + (btnCountBest + 2) + '.json')
                            .then((result) => {
                                setLoading(false);
                                let copy = [...shoes, ...result.data];
                                dispatch(setShoes(copy));
                                setBtnCountBest(btnCountBest + 1);
                            })
                            .catch(() => {
                                setLoading(false);
                                console.log('데이터 가져오기 실패')
                            })
                    }}>더보기</button>
                </div>
                : null
            }








            {/* 여기부터 신상품 */}

            <br />
            <br />
            <br />
            <h1 style={{ fontSize: '30px', fontWeight: '700' }}>신상품</h1>
            <br />




            <RankingButton onClick={() => { setNewRanking(0) }} isActive={newRanking === 0}>여성</RankingButton>
            <RankingButton onClick={() => { setNewRanking(1) }} isActive={newRanking === 1}>남성</RankingButton>
            <RankingButton onClick={() => { setNewRanking(2) }} isActive={newRanking === 2}>키즈</RankingButton>
            <RankingButton onClick={() => { setNewRanking(3) }} isActive={newRanking === 3}>슈즈</RankingButton>
            <br></br>
            <RankingConTent ranking={newRanking}></RankingConTent>
            <br></br>

            <Container>
                <Row>
                    {
                        shoes.map(function (a, i) {
                            return (
                                <CardItem shoes={shoes[i]} index={i} key={i} navigate={navigate}></CardItem>
                            )
                        })
                    }
                </Row>
            </Container>

            {(btnCountNew < 2)
                ?
                <div>
                    {loading && <p>@@ 로딩중입니다 @@</p>}
                    <button onClick={() => {
                        setLoading(true);
                        axios.get('https://codingapple1.github.io/shop/data' + (btnCountNew + 2) + '.json')
                            .then((result) => {
                                setLoading(false);
                                let copy = [...shoes, ...result.data];
                                dispatch(setShoes(copy));
                                setBtnCountNew(btnCountNew + 1);
                            })
                            .catch(() => {
                                setLoading(false);
                                console.log('데이터 가져오기 실패')
                            })
                    }}>더보기</button>
                </div>
                : null
            }
        </div>
    )
}

function RankingConTent(props) {
    return (
        <div>
            {[<div>내용0</div>, <div>내용1</div>, <div>내용2</div>, <div>내용3</div>][props.ranking]}
        </div>
    )
}

export default Main;