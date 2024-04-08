import { initializeApp } from 'firebase/app';
// import { getStorage } from 'firebase/storage';
import { getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";

const firebaseConfig = {
    apiKey: "AIzaSyAbEPvoOioqXqzboqAXF4rt9tOIIpf3240",
    authDomain: "hsmall-49fb6.firebaseapp.com",
    projectId: "hsmall-49fb6",
    storageBucket: "hsmall-49fb6.appspot.com",
    messagingSenderId: "145324794706",
    appId: "1:145324794706:web:713c5808560492eec8508b"
};

// Firebase 앱 초기화
const app = initializeApp(firebaseConfig);

// Storage 서비스 접근
const storage = getStorage(app);

export { storage };