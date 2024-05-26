import 'package:capstone/ReceiptDetailModel.dart';
import 'package:capstone/ReceiptModel.dart';
import 'package:capstone/productDetail.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './style.dart' as style;
import './search.dart';
import './shoppingCart.dart';
import './man.dart';
import './woman.dart';
import './kids.dart';
import './bagAndShoes.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './notification.dart';
import 'dart:async';

//import 'package:image_network/image_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'CustomerModel.dart';
import 'ReceiptDetailGetModel.dart';
import 'ReceiptGetModel.dart';
import 'firebase_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'getcustomers.dart';

final firestore = FirebaseFirestore.instance;

// 사용자 정보를 제공하는 Provider 클래스
class UserProvider extends ChangeNotifier {
  String _currentUser = ''; // 사용자의 현재 아이디를 저장하는 변수

  // 현재 사용자 아이디를 가져오는 게터
  String getCurrentUser() {
    return _currentUser;
  }

  // 로그인한 사용자의 아이디를 설정하는 메서드
  void login(String userId) {
    _currentUser = userId;
    notifyListeners(); // 변경 사항을 Provider에 알림
  }

  Future<void> logout() async {
    _currentUser = '';
    notifyListeners();
  }

  Future<void> delete() async {
    final response = await http.delete(Uri.parse('http://3.25.202.52:8080/api/customers/$_currentUser'));
    //탈퇴후 재 로그인을 위한 처리
    print("del 유저 : $_currentUser");
    _currentUser = '';
    notifyListeners();
    print("after 유저 : $_currentUser");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => SearchRecordsProvider(),
      child: ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(
          theme: style.theme,
          home: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  //const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

checkFirebase() async {
  var result = await firestore.collection('product').get();
  for (var doc in result.docs) {
    print(doc['name']);
  }

  print("123");
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var tabIndex = 0;

  var userContent;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    checkFirebase();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/DesignTheStyle.jpg'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, a1, a2) => search(),
                    transitionsBuilder: (context, a1, a2, child) =>
                        FadeTransition(opacity: a1, child: child),
                    transitionDuration: Duration(milliseconds: 500),
                  ));
            },
            iconSize: 30,
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () async {
              if (context.read<UserProvider>().getCurrentUser().isEmpty) {
                bool confirmation = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('로그인'),
                      content: Text('로그인이 필요한 서비스입니다.?\n로그인 하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(true); // "네"를 눌렀을 때 true를 반환
                          },
                          child: Text('네'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(false); // "아니오"를 눌렀을 때 false를 반환
                          },
                          child: Text('아니오'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmation == true) {
                  //팝업
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => idAndPassword(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ));
                }
              } else {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a1, a2) => shoppingCart(),
                      transitionsBuilder: (context, a1, a2, child) =>
                          FadeTransition(opacity: a1, child: child),
                      transitionDuration: Duration(milliseconds: 500),
                    ));
              }
            },
            iconSize: 30,
          ),
        ],
        leading: tabIndex == 1
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    tabIndex = 0;
                  });
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // 상단에 고정된 Container

          // 선택된 탭의 내용
          Expanded(
            child: IndexedStack(
              index: tabIndex,
              children: [
                Home(), // 첫 번째 탭
                Login(), // 두 번째 탭
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tabIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: '샵',
          )
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();
  var _current = 0;
  final CarouselController _controller = CarouselController();
  var isLoading = true;

  List<dynamic> currentPopularImageClothesId = ["2", "3", "16","29"];

  List<dynamic> currentPopularImageList = [
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/03/19/GM0024031963231_0_THNAIL_ORGINL_20240321130308429.jpg", //clothesId 2
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/ORBR/24/03/14/GQ3A24031417153_0_THNAIL_ORGINL_20240314181129974.jpg", //clothesId 3
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/04/17/GM0024041737914_0_THNAIL_ORGINL_20240419115855778.jpg", //clothesId 16
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/CGCG/24/04/08/GM0024040882840_0_THNAIL_ORGINL_20240409175441490.jpg", //clothesId 29
  ];
  List<dynamic> currentSaleItemsImageList = [
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/ECBR/24/03/18/GM0024031854835_0_THNAIL_ORGINL_20240320164604461.jpg", //clothesId 1
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/03/19/GM0024031963231_0_THNAIL_ORGINL_20240321130308429.jpg", //clothesId 2
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/ORBR/24/03/14/GQ3A24031417153_0_THNAIL_ORGINL_20240314181129974.jpg", //clothesId 3
    "https://img.ssfshop.com/cmd/RB_100x133/src/https://img.ssfshop.com/goods/BPBR/23/12/29/GM0023122958358_0_THNAIL_ORGINL_20240205111940576.jpg", //clothesId 4
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/IMIM/24/03/06/GM0024030654378_0_THNAIL_ORGINL_20240314151330999.jpg", //clothesId 12
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/BPBR/23/12/14/GM0023121475356_0_THNAIL_ORGINL_20240124180459250.jpg", //clothesId 13
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/ECBR/23/11/24/GM0023112436627_0_THNAIL_ORGINL_20240124124419651.jpg", //clothesId 14
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/ORBR/24/03/05/GQHV24030544150_0_THNAIL_ORGINL_20240307112540079.jpg", //clothesId 15
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/04/17/GM0024041737914_0_THNAIL_ORGINL_20240419115855778.jpg", //clothesId 16
  ];
  List<dynamic> newItemsImageList = [
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/01/05/GM0024010510993_0_THNAIL_ORGINL_20240108115335287.jpg", //clothesId 17
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/01/08/GM0024010821438_0_THNAIL_ORGINL_20240420202243431.jpg", //clothesId 18
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/01/08/GM0024010821441_0_THNAIL_ORGINL_20240222155704358.jpg", //clothesId 19
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/HMBR/24/02/01/GM0024020139288_0_THNAIL_ORGINL_20240205121021921.jpg", //clothesId 20
    "https://img.ssfshop.com/cmd/LB_750x1000/src/https://img.ssfshop.com/goods/CGCG/24/01/22/GM0024012240161_0_THNAIL_ORGINL_20240226103800703.jpg", //clothesId 21
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadItemsImages();
    setState(() {
      isLoading = false;
    });
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        //getMore();
      }
    });
  }
  //
  // void loadItemsImages() async {
  //   try {
  //     // List<dynamic> currentPopularItems = await getCurrentPopularItems();
  //     // List<dynamic> currentSaleItems = await getCurrentSaleItems();
  //     // List<dynamic> newItems = await getNewItems();
  //
  //     setState(() {
  //       currentPopularImageList = currentPopularItems;
  //       currentSaleItemsImageList = currentSaleItems;
  //       newItemsImageList = newItems;
  //       // testImageList = testImage;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('에러남 $e');
  //     isLoading = false;
  //   }
  // }

  Future<List<dynamic>> getCurrentPopularItems() async {
    var result = await firestore.collection('currentPopularItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getCurrentSaleItems() async {
    var result = await firestore.collection('currentSaleItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getNewItems() async {
    var result = await firestore.collection('newItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: 1,
            controller: scroll,
            itemBuilder: (c, i) {
              return Column(
                children: [
                  Container(
                    height: 50.0,
                    color: Colors.white,
                    child: (Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => woman()));
                            },
                            child: Text(
                              '여성',
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => man()));
                            },
                            child: Text(
                              '남성',
                              style: TextStyle(color: Colors.black),
                            )),
                        // TextButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => kids()));
                        //     },
                        //     child: Text(
                        //       '키즈',
                        //       style: TextStyle(color: Colors.black),
                        //     )),
                        // TextButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => bagAndShoes()));
                        //     },
                        //     child: Text(
                        //       '백&슈즈',
                        //       style: TextStyle(color: Colors.black),
                        //     )),
                      ],
                    )),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('현재 인기 아이템',
                        style:
                            TextStyle(fontSize: fontSize1(context).toDouble())),
                  ),
                  SizedBox(
                    height: 400,
                    child: Stack(
                      children: [
                        sliderWidget(),
                        sliderIndicator(),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Divider(
                    indent: 100,
                    endIndent: 100,
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('현재 할인 아이템',
                        style:
                            TextStyle(fontSize: fontSize1(context).toDouble())),
                  ),
                  SizedBox(
                    height: 350,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "1")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(
                                      currentSaleItemsImageList[0]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "2")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[1]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "3")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[2]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // 간격 조절
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "4")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[3]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "12")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[4]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "13")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[5]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // 간격 조절

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "14")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[6]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "15")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[7]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "16")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image:
                                      NetworkImage(currentSaleItemsImageList[8]),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.width / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Divider(
                    indent: 100,
                    endIndent: 100,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('새로운 아이템',
                        style:
                            TextStyle(fontSize: fontSize1(context).toDouble())),
                  ),
                  SizedBox(
                    height: 350,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "17")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(newItemsImageList[0]),
                                  width: MediaQuery.of(context).size.width / 7,
                                  height: MediaQuery.of(context).size.width / 7,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "18")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(newItemsImageList[1]),
                                  width: MediaQuery.of(context).size.width / 7,
                                  height: MediaQuery.of(context).size.width / 7,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "19")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(newItemsImageList[2]),
                                  width: MediaQuery.of(context).size.width / 7,
                                  height: MediaQuery.of(context).size.width / 7,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "20")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(newItemsImageList[3]),
                                  width: MediaQuery.of(context).size.width / 7,
                                  height: MediaQuery.of(context).size.width / 7,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            productDetail(item: "21")));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(newItemsImageList[4]),
                                  width: MediaQuery.of(context).size.width / 7,
                                  height: MediaQuery.of(context).size.width / 7,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
  }

  Widget sliderWidget() {
    return CarouselSlider(
        carouselController: _controller,
        items: currentPopularImageList.map((imgLink) {
          return Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                print('Clicked image: $_current');
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a1, a2) => productDetail(item:currentPopularImageClothesId[_current]),
                      transitionsBuilder: (context, a1, a2, child) =>
                          FadeTransition(opacity: a1, child: child),
                      transitionDuration: Duration(milliseconds: 100),
                    )
                );
              },
              child: SizedBox(
                  //width:MediaQuery.of(context).size.width,
                  width: 600,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          imgLink,
                        )),
                  )),
            );
          });
        }).toList(),
        options: CarouselOptions(
            height: 400,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }));
  }

  Widget sliderIndicator() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: currentPopularImageList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12,
                height: 12,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ));
  }
}

fontSize1(context) {
  if (MediaQuery.of(context).size.width > 600) {
    return 30.0;
  } else {
    return 16.0;
  }
}

final auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

var loginCheck = false;

class _LoginScreenState extends State<LoginScreen> {
  var tabIndex = 0;
  var scroll = ScrollController();

  Future<void> deleteReceiptAllData() async {
    var data = await http
        .get(Uri.parse('http://3.25.202.52:8080/api/receipt/${context.read<UserProvider>().getCurrentUser()}'));

    if(data.statusCode==200){
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      var jsonData = json.decode(utf8DecodedBody);

      List<ReceiptGetModel> RM = [];

      for(var e in jsonData){
        ReceiptGetModel box = new ReceiptGetModel();
        box.receiptId = e["receiptId"];
        box.customerEmail = e["customerEmail"];
        box.status = e["status"];
        box.date = e["date"];
        RM.add(box);

      }


      print("get receipt data success");
      var success = false;

      for(var i=0;i<RM.length;i++){
        final data2 = await http.delete(Uri.parse('http://3.25.202.52:8080/api/receipt_detail/${RM[i].getReceiptId}'));
        if(data2.statusCode==200){
          print("${i} delete detailReceipt success");
          success = true;
        }else{
          print("${i} delete detailReceipt fail");
        }
      }

      if(success){
        for(var i=0;i<RM.length;i++){
          final data3 = await http.delete(Uri.parse('http://3.25.202.52:8080/api/receipt/${RM[i].getReceiptId}'));
          if(data3.statusCode==200){
            print("${i} delete detailReceipt success");
            success = true;
          }else{
            print("${i} delete detailReceipt fail");
          }
        }
      }








    }else{
      print("get receipt data fail");
    }

  }

  @override
  Widget build(BuildContext context) {
    if (context.read<UserProvider>().getCurrentUser().isNotEmpty) {
      // currentUser 즉 로그인 되어있는 상태.
      return ListView.builder(
          itemCount: 1,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.account_circle,
                            size: MediaQuery.of(context).size.width / 4,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextButton(
                                child: Text(
                                  '로그아웃 >',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {

                                  await context
                                      .read<UserProvider>()
                                      .logout(); //로그아웃. currentUser없음.


                                  // ignore: use_build_context_synchronously
                                  // 화면을 재구성합니다.
                                  setState(() {});
                                }),
                          ),
                          SizedBox(
                              height: 50,
                              child: Text(
                                '${context.read<UserProvider>().getCurrentUser()}님 반갑습니다.',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                    softWrap: true,
                              )),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, a1, a2) => purchaseLists(),
                                    transitionsBuilder: (context, a1, a2, child) =>
                                        FadeTransition(opacity: a1, child: child),
                                    transitionDuration: Duration(milliseconds: 500),
                                  ));
                            },
                            child: Text(
                              '주문 정보 확인',
                                style: TextStyle(color: Colors.grey, fontSize: 10),
                                softWrap: true,
                            ),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a1, a2) => updateUser(),
                            transitionsBuilder: (context, a1, a2, child) =>
                                FadeTransition(opacity: a1, child: child),
                            transitionDuration: Duration(milliseconds: 100),
                          ));
                    },
                    child: Text(
                      '회원 정보 수정',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  height: 35,
                  child: TextButton(
                    onPressed: () async {
                      bool confirmation = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('계정 탈퇴'),
                            content: Text('계정을 정말 탈퇴하시겠습니까?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // "네"를 눌렀을 때 true를 반환
                                },
                                child: Text('네'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // "아니오"를 눌렀을 때 false를 반환
                                },
                                child: Text('아니오'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmation == true) {
                        //팝업
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('계정 탈퇴'),
                              content: Text('계정이 탈퇴 되었습니다.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    // 사용자 정보를 삭제하고 Provider에 변경 사항을 알립니다.
                                    await deleteReceiptAllData();
                                    await context.read<UserProvider>().delete();


                                    // AlertDialog를 닫고 화면을 재구성합니다.
                                    Navigator.of(context).pop();

                                    // 화면을 재구성합니다.
                                    setState(() {});
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      //
                    },
                    child: Text(
                      '계정 탈퇴',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      //로그인 안돼있는 경우
      return ListView.builder(
          itemCount: 1,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.account_circle,
                            size: MediaQuery.of(context).size.width / 4,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextButton(
                                child: Text(
                                  '로그인 >',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => idAndPassword()),
                                  ).then((value) {
                                    // idAndPassword() 화면에서 로그인 성공 시에 처리할 내용
                                    // 사용자가 로그인에 성공했으므로 이전 화면의 상태를 갱신할 필요가 있음
                                    setState(() {});
                                    print(
                                        'now${context.read<UserProvider>().getCurrentUser()}');

                                    context
                                        .read<UserProvider>()
                                        .notifyListeners();
                                  });
                                }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            child: Text('로그인을 하시면\n주문 정보 확인이 가능합니다.',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  width: double.infinity, // 부모 위젯의 가로 길이만큼
                  height: 4, // Divider의 두께 설정
                  color: Colors.grey.shade300, // 회색 배경색 설정
                ),
              ],
            );
          });
    }
  }

//}
}

class idAndPassword extends StatefulWidget {
  const idAndPassword({super.key});

  @override
  State<idAndPassword> createState() => _idAndPasswordState();
}

class _idAndPasswordState extends State<idAndPassword> {
  var id = '';
  var passWord = '';
  var scroll = ScrollController();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '로그인',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a1, a2) => search(),
                      transitionsBuilder: (context, a1, a2, child) =>
                          FadeTransition(opacity: a1, child: child),
                      transitionDuration: Duration(milliseconds: 500),
                    ));
              },
              iconSize: 30,
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () async {
                if (context.read<UserProvider>().getCurrentUser().isEmpty) {
                  bool confirmation = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('로그인'),
                        content: Text('로그인이 필요한 서비스입니다.?\n로그인 하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // "네"를 눌렀을 때 true를 반환
                            },
                            child: Text('네'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // "아니오"를 눌렀을 때 false를 반환
                            },
                            child: Text('아니오'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmation == true) {
                    //팝업
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) => idAndPassword(),
                          transitionsBuilder: (context, a1, a2, child) =>
                              FadeTransition(opacity: a1, child: child),
                          transitionDuration: Duration(milliseconds: 100),
                        ));
                  }
                } else {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => shoppingCart(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 500),
                      ));
                }
              },
              iconSize: 30,
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: 1,
            controller: scroll,
            itemBuilder: (c, i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: SizedBox(
                      width: 200,
                      child: Text('로그인',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                          textAlign: TextAlign.start),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '아이디',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        id = value; // 사용자가 입력한 값을 id 변수에 저장
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: true, // 비밀번호 입력 시 텍스트 감춤 설정
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        border: OutlineInputBorder(),
                      ),

                      onChanged: (value) {
                        passWord = value; // 사용자가 입력한 값을 id 변수에 저장
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            login();
                            // 로그인 버튼 클릭 시 실행될 로직 작성
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 50),
                            backgroundColor:
                                Colors.black, // 배경색을 검정으로 설정// 버튼의 높이와 너비 조절
                          ),
                          child: Text(
                            '로그인',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a1, a2) =>
                                      registration(),
                                  transitionsBuilder: (context, a1, a2,
                                          child) =>
                                      FadeTransition(opacity: a1, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: 200),
                                ));
                            // 회원가입 버튼 클릭 시 실행될 로직 작성
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 50),
                            backgroundColor:
                                Colors.white, // 배경색을 검정으로 설정// 버튼의 높이와 너비 조절
                          ),
                          child: Text(
                            '회원가입',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }

  bool isValidEmail(String email) {
    // 이메일 유효성 검사를 위한 정규표현식 사용
    // 여기서는 간단한 형태의 정규표현식을 사용하였습니다. 실제 프로덕션 환경에 맞게 수정해야 합니다.
    // 이메일 형식이 잘못된 경우 false를 반환합니다.
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  //로그인
  login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      if (id.isEmpty || passWord.isEmpty) {
        throw '이메일과 비밀번호를 모두 입력해주세요.';
      }

      if (!isValidEmail(id)) {
        throw '올바른 이메일 주소를 입력해주세요.';
      }

      // 로그인 API 호출 spring
      print("$id // $passWord");
      var response = await http
          .get(Uri.parse('http://3.25.202.52:8080/api/customers/$id/$passWord'));
      if (response.body == 'true') {
        print('로그인 성공: ${response.body}'); //성공시 provider의 _currentUser로 등록.
        context.read<UserProvider>().login(id); // 로그인 메서드 호출

        print("12313213${context.read<UserProvider>().getCurrentUser()}");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('로그인'),
              content: Text('로그인 되었습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    context.read<UserProvider>().notifyListeners();
                    print(
                        "4124${context.read<UserProvider>().getCurrentUser()}");

                    //Provider.of<UserProvider>(context, listen: false).notifyListeners();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        print('로그인 실패: ${response.statusCode}');
        throw 'loginError';
      }
    } catch (e) {
      print('로그인 실패: $e');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('존재하지 않는 계정입니다.'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }
}

class updateUser extends StatefulWidget {
  const updateUser({super.key});

  @override
  State<updateUser> createState() => _updateUserState();
}

class _updateUserState extends State<updateUser> {
  var passWord = '';
  var name = '';
  var phone = '';
  var detailAddress = '';
  var scroll = ScrollController();


  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController detailAddressController = TextEditingController();

  bool isLoading = true;
  bool addressSearchCheck = false;

  void _searchAddress(BuildContext context) async {
    KopoModel? model = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) => RemediKopo(),
          transitionsBuilder: (context, a1, a2, child) =>
              FadeTransition(opacity: a1, child: child),
          transitionDuration: Duration(milliseconds: 100),
        ));

    if (model != null) {
      final modelZipcode = model.zonecode ?? '';
      final modelAddress = model.address ?? '';
      final modelBuildingName = model.buildingName ?? '';

      zipCodeController.value = TextEditingValue(
        text: modelZipcode,
      );
      streetAddressController.value = TextEditingValue(
        text: modelAddress,
      );
      detailAddressController.value = TextEditingValue(
        text: modelBuildingName,
      );

      setState(() {
        addressSearchCheck = true;
      });
    }
  }

  Future<void> getCustomerData() async {
    var data = await http.get(Uri.parse(
        'http://3.25.202.52:8080/api/customers/${context.read<UserProvider>().getCurrentUser()}'));
    var utf8DecodedBody = utf8.decode(data.bodyBytes);
    // 디코딩된 데이터를 JSON으로 파싱
    var jsonData = json.decode(utf8DecodedBody);

    setState(() {
      name = jsonData["name"];
      phone = jsonData["phone"];
      detailAddress = jsonData["detailAddress"].split(',')[1].toString();
      isLoading = false;
    });

    zipCodeController.value = TextEditingValue(
      text: jsonData["zipCode"].toString(),
    );
    streetAddressController.value = TextEditingValue(
      text: jsonData["streetAddress"].toString(),
    );
    detailAddressController.value = TextEditingValue(
      text: jsonData["detailAddress"].split(',')[0].toString(),
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              '회원 정보 수정',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => search(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 500),
                      ));
                },
                iconSize: 30,
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () async {
                  if (context.read<UserProvider>().getCurrentUser().isEmpty) {
                    bool confirmation = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('로그인'),
                          content: Text('로그인이 필요한 서비스입니다.?\n로그인 하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // "네"를 눌렀을 때 true를 반환
                              },
                              child: Text('네'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // "아니오"를 눌렀을 때 false를 반환
                              },
                              child: Text('아니오'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmation == true) {
                      //팝업
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a1, a2) => idAndPassword(),
                            transitionsBuilder: (context, a1, a2, child) =>
                                FadeTransition(opacity: a1, child: child),
                            transitionDuration: Duration(milliseconds: 100),
                          ));
                    }
                  } else {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) => shoppingCart(),
                          transitionsBuilder: (context, a1, a2, child) =>
                              FadeTransition(opacity: a1, child: child),
                          transitionDuration: Duration(milliseconds: 500),
                        ));
                  }
                },
                iconSize: 30,
              ),
            ],
          ),
          body: ListView.builder(
              itemCount: 1,
              controller: scroll,
              itemBuilder: (c, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: SizedBox(
                        width: 200,
                        child: Text('회원 정보 수정',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                            textAlign: TextAlign.start),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: true, // 비밀번호 입력 시 텍스트 감춤 설정
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          border: OutlineInputBorder(),
                        ),

                        onChanged: (value) {
                          passWord = value; // 사용자가 입력한 값을 id 변수에 저장
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(
                          labelText: '이름',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          name = value; // 사용자가 입력한 값을 id 변수에 저장
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        initialValue: phone,
                        decoration: InputDecoration(
                          labelText: '전화번호(010-XXXX-XXXX)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          phone = value; // 사용자가 입력한 값을 id 변수에 저장
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        _searchAddress(context);
                      },
                      child: const Text('주소검색'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: false,
                        controller: zipCodeController,
                        decoration: InputDecoration(
                          labelText: '주소',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: false,
                        controller: streetAddressController,
                        decoration: InputDecoration(
                          labelText: '주소',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: false,
                        controller: detailAddressController,
                        decoration: InputDecoration(
                          labelText: '주소',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        initialValue: detailAddress,
                        decoration: InputDecoration(
                          labelText: '상세주소',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          detailAddress = value; // 사용자가 입력한 값을 id 변수에 저장
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // if(addressSearchCheck==true) {
                              //
                              // }else{
                              //
                              // }
                              update();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 50),
                              backgroundColor:
                                  Colors.black, // 배경색을 검정으로 설정// 버튼의 높이와 너비 조절
                            ),
                            child: Text(
                              '회원 정보 수정',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                );
              }));
    }
  }

  bool isValidPhone(String phoneNumber) {
    // 전화번호 정규식
    RegExp regExp = RegExp(r'^01(?:0|1|[6-9])[-]?\d{3,4}[-]?\d{4}$');
    return regExp.hasMatch(phoneNumber);
  }

  update() async {
    CustomerModel newCustomer = new CustomerModel();

    //전부 수정한 경우
    try {
      if (passWord.isEmpty ||
          name.isEmpty ||
          phone.isEmpty ||
          zipCodeController.text.isEmpty ||
          streetAddressController.text.isEmpty ||
          detailAddressController.text.isEmpty ||
          detailAddress.isEmpty) {
        throw '정보를 모두 입력해주세요.';
      }

      if (!isValidPhone(phone)) {
        throw '올바른 전화번호를 입력해주세요.(010-XXXX-XXXX).';
      }

      newCustomer.email = context.read<UserProvider>().getCurrentUser();
      newCustomer.password = passWord;
      newCustomer.name = name;
      newCustomer.phone = phone;
      newCustomer.streetAddress = streetAddressController.text;
      newCustomer.detailAddress = "${detailAddressController.text},${detailAddress}";
      newCustomer.zipCode = zipCodeController.text;

      final response = await http.put(
        Uri.parse(
            'http://3.25.202.52:8080/api/customers/${context.read<UserProvider>().getCurrentUser()}'), // 적절한 엔드포인트를 사용하세요.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newCustomer.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update${response.body}');
      } else {
        print("회원 정보 수정 완료");
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원 정보 수정'),
            content: Text('회원 정보 수정이 완료되었습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      // 2초 후에 화면 전환 수행
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      print('회원 정보 수정 실패: $e');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$e ERROR'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }
}

//회원가입
class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  var id = '';
  var passWord = '';
  var name = '';
  var phone = '';
  var detailAddress = '';

  var scroll = ScrollController();

  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController detailAddressController = TextEditingController();

  void _searchAddress(BuildContext context) async {
    KopoModel? model = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) => RemediKopo(),
          transitionsBuilder: (context, a1, a2, child) =>
              FadeTransition(opacity: a1, child: child),
          transitionDuration: Duration(milliseconds: 100),
        ));

    if (model != null) {
      final modelZipcode = model.zonecode ?? '';
      final modelAddress = model.address ?? '';
      final modelBuildingName = model.buildingName ?? '';

      zipCodeController.value = TextEditingValue(
        text: modelZipcode.toString(),
      );
      streetAddressController.value = TextEditingValue(
        text: modelAddress.toString(),
      );
      detailAddressController.value = TextEditingValue(
        text: modelBuildingName.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '회원가입',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a1, a2) => search(),
                      transitionsBuilder: (context, a1, a2, child) =>
                          FadeTransition(opacity: a1, child: child),
                      transitionDuration: Duration(milliseconds: 500),
                    ));
              },
              iconSize: 30,
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () async {
                if (context.read<UserProvider>().getCurrentUser().isEmpty) {
                  bool confirmation = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('로그인'),
                        content: Text('로그인이 필요한 서비스입니다.?\n로그인 하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // "네"를 눌렀을 때 true를 반환
                            },
                            child: Text('네'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // "아니오"를 눌렀을 때 false를 반환
                            },
                            child: Text('아니오'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmation == true) {
                    //팝업
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) => idAndPassword(),
                          transitionsBuilder: (context, a1, a2, child) =>
                              FadeTransition(opacity: a1, child: child),
                          transitionDuration: Duration(milliseconds: 100),
                        ));
                  }
                } else {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => shoppingCart(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 500),
                      ));
                }
              },
              iconSize: 30,
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: 1,
            controller: scroll,
            itemBuilder: (c, i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: SizedBox(
                      width: 200,
                      child: Text('회원가입',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                          textAlign: TextAlign.start),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '아이디',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        id = value; // 사용자가 입력한 값을 id 변수에 저장
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: true, // 비밀번호 입력 시 텍스트 감춤 설정
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        border: OutlineInputBorder(),
                      ),

                      onChanged: (value) {
                        passWord = value; // 사용자가 입력한 값을 id 변수에 저장
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '이름',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        name = value; // 사용자가 입력한 값을 id 변수에 저장
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '전화번호(010-XXXX-XXXX)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        phone = value; // 사용자가 입력한 값을 id 변수에 저장
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      _searchAddress(context);
                    },
                    child: const Text('주소검색'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: false,
                      controller: zipCodeController,
                      decoration: InputDecoration(
                        labelText: '주소',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: false,
                      controller: streetAddressController,
                      decoration: InputDecoration(
                        labelText: '주소',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: false,
                      controller: detailAddressController,
                      decoration: InputDecoration(
                        labelText: '주소',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '상세주소',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        detailAddress = value; // 사용자가 입력한 값을 id 변수에 저장
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // 로그인 버튼 클릭 시 실행될 로직 작성
                            addUser();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 50),
                            backgroundColor:
                                Colors.black, // 배경색을 검정으로 설정// 버튼의 높이와 너비 조절
                          ),
                          child: Text(
                            '회원가입',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              );
            }));
  }

  bool isValidEmail(String email) {
    // 이메일 유효성 검사를 위한 정규표현식 사용
    // 여기서는 간단한 형태의 정규표현식을 사용하였습니다. 실제 프로덕션 환경에 맞게 수정해야 합니다.
    // 이메일 형식이 잘못된 경우 false를 반환합니다.
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhone(String phoneNumber) {
    // 전화번호 정규식
    RegExp regExp = RegExp(r'^01(?:0|1|[6-9])[-]?\d{3,4}[-]?\d{4}$');
    return regExp.hasMatch(phoneNumber);
  }

  addUser() async {
    try {
      if (id.isEmpty ||
          passWord.isEmpty ||
          name.isEmpty ||
          phone.isEmpty ||
          zipCodeController.text.isEmpty ||
          streetAddressController.text.isEmpty ||
          detailAddressController.text.isEmpty ||
          detailAddress.isEmpty) {
        throw '정보를 모두 입력해주세요.';
      }

      if (!isValidEmail(id)) {
        throw '올바른 이메일 주소를 입력해주세요.';
      }

      if (!isValidPhone(phone)) {
        throw '올바른 전화번호를 입력해주세요.(010-XXXX-XXXX).';
      }


      print("check");
      print(detailAddressController.text);
      print(detailAddress);
      print("check");

      CustomerModel newCustomer = new CustomerModel();
      newCustomer.email = id;
      newCustomer.password = passWord;
      newCustomer.name = name;
      newCustomer.phone = phone;
      newCustomer.streetAddress = streetAddressController.text;
      newCustomer.detailAddress = "${detailAddressController.text},${detailAddress}";
      newCustomer.zipCode = zipCodeController.text;



      final response = await http.post(
        Uri.parse('http://3.25.202.52:8080/api/customers'), // 적절한 엔드포인트를 사용하세요.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newCustomer.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add customer');
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원가입'),
            content: Text('회원가입이 완료되었습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      // 2초 후에 화면 전환 수행
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      print('회원가입 실패: $e');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$e 이미 존재하는 계정입니다.'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }
}




class purchaseLists extends StatefulWidget {
  const purchaseLists({super.key});

  @override
  State<purchaseLists> createState() => _purchaseListsState();
}

class _purchaseListsState extends State<purchaseLists> {
  bool isLoading = true;
  var scroll = ScrollController();

  List<ReceiptGetModel> RGM = [];
  List<ReceiptDetailGetModel> RDGM = [];



  Future<void> getData() async{
    var data = await http
        .get(Uri.parse('http://3.25.202.52:8080/api/receipt/${context.read<UserProvider>().getCurrentUser()}'));

    if(data.statusCode==200){
      print("get receipt data success");
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      var jsonData = json.decode(utf8DecodedBody);

      for(var e in jsonData){
        ReceiptGetModel box = new ReceiptGetModel();
        box.receiptId = e["receiptId"];
        box.customerEmail = e["customerEmail"];
        box.status = e["status"];
        box.date = e["date"];
        RGM.add(box);
      }

      for(int i=0;i<RGM.length;i++){
        var data2 = await http.get(Uri.parse('http://3.25.202.52:8080/api/receipt_detail/${RGM[i].getReceiptId}'));

        if(data2.statusCode == 200){
          print("get Receipt Detail Success");
          var utf8DecodedBody2 = utf8.decode(data2.bodyBytes);
          var jsonData2 = json.decode(utf8DecodedBody2);

          for(var e in jsonData2){
            ReceiptDetailGetModel box = new ReceiptDetailGetModel();
            box.customerEmail = e["customerEmail"];
            box.clothesId = e["clothesId"];
            box.name = e["name"];
            box.color = e["color"];
            box.size = e["size"];
            box.price = e["price"];
            box.imageUrl = e["imageUrl"];
            box.quantity = e["quantity"];
            box.status = e["status"];
            RDGM.add(box);
          }
          setState(() {
            isLoading = false;
          });


        }else{
          print("get Receipt Detail Fail");
          setState(() {
            isLoading = true;
          });
        }
      }

    }else{
      print("get receipt data fail");
      setState(() {
        isLoading = true;
      });
    }
  }
  String getStatusText(int status) {
    switch (status) {
      case 0:
        return '상품준비';
      case 1:
        return '배송준비';
      case 2:
        return '배송중';
      case 3:
        return '배송완료';
      case 4:
        return '일부반품중';
      case 5:
        return '반품중';
      case 6:
        return '일부반품완료';
      case 7:
        return '반품완료';
      default:
        return '알 수 없음';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('구매 목록'),
        actions: [

        ],
      ),

      body: ListView.builder(
          itemCount: RDGM.length,
          controller: scroll,
          itemBuilder: (c, i){
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 150,
                  child: Row(
                    children: [
                      SizedBox(
                        child: Image.network(
                          RDGM[i].getImageUrl,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      RDGM[i].getName,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      getStatusText(RDGM[i].getStatus),
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text(
                                  "${RDGM[i].getColor}, ${RDGM[i].getSize}, ${RDGM[i].getQuantity.toString()}개",
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text(
                                  '${NumberFormat("#,##0").format(RDGM[i].getPrice*RDGM[i].getQuantity)} 원',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    print("주문 현황 변경???");

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        border: Border.all(color: Colors.black12,width: 0.5)
                                    ),
                                    child: Text(
                                      '주문 취소',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            )

                          ],

                        ),
                      )
                    ],
                  ),
                ),
                Divider()

              ],

            );
          }
      ),
    );

  }


}
