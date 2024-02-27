import { useEffect } from "react";

const { kakao } = window;

function About(props) {

    useEffect(() => {
        const container = document.getElementById('map');
        const options = {
            center: new kakao.maps.LatLng(33.450701, 126.570667),
            level: 3
        };
        const map = new kakao.maps.Map(container, options);
    }, [])

    return (
        <div style={{ textAlign: 'center', margin: 'auto', maxWidth: '800px' }}>
        <p>회사 정보 페이지입니다.</p>
        <div id="map" style={{ display: 'inline-block', width: '500px', height: '400px' }}></div>
    </div>
    )
}

export default About;