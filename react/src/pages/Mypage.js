import Image from 'react-bootstrap/Image';
import Button from 'react-bootstrap/Button';


function Mypage(props) {
    return(
        <div>
            
            <br /> <br />
            
            
            <h1 style={{ fontSize: '30px', fontWeight: '700' }}>마이페이지</h1>
            <br />
            <hr style={{ border: '0', height: '2px', backgroundColor: '#333'}} />
            <Image src={process.env.PUBLIC_URL + '/img/ronaldo.jpg'} style={{ width: '170px', height: '170px', borderRadius: '50%' }} roundedCircle />
            <h1 style={{ fontSize: '20px', fontWeight: '500' }}>홍길동 님<br /> qwer@hansung.ac.kr</h1>
            <br />
            <h1 style={{ fontSize: '20px', fontWeight: '500' }}>첫 구매하고 포인트 받으세요!</h1>

            <br />
            <Button variant="primary">회원정보 수정</Button>{' '}
            
            <Button variant="danger">회원탈퇴</Button>{' '}
        </div>
    )
}

export default Mypage;