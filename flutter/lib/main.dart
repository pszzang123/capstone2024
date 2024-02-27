import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './style.dart' as style;
import './search.dart';
import './shoppingCart.dart';
import './Login.dart';
import './man.dart';
import './woman.dart';
import './kids.dart';
import './bagAndShoes.dart';

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
import 'package:image_network/image_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(theme: style.theme, home: MyApp()));
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
      floatingActionButton: FloatingActionButton(
        child: Text('+'),
        onPressed: () {
          showNotification2();
        },
      ),
      appBar: AppBar(
        title: Text('HS SHOP'),
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
              //shoppingCart();
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, a1, a2) => shoppingCart(),
                    transitionsBuilder: (context, a1, a2, child) =>
                        FadeTransition(opacity: a1, child: child),
                    transitionDuration: Duration(milliseconds: 500),
                  ));
            },
            iconSize: 30,
          ),
        ],
        leading: tabIndex == 1
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    tabIndex=0;
                  });
                },
              )
            : null,
      ),
      // body: [ MediaQuery.of(context).size.width > 600 ? HomeLarge() : Home(data: data, addData: addData), Shop()][tab],
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

  // getMore() async {
  //   var result = await http
  //       .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
  //   var result2 = jsonDecode(result.body);
  //   widget.addData(result2);
  // }
  List<dynamic> currentPopularImageList = [];
  List<dynamic> currentSaleItemsImageList = [];
  List<dynamic> newItemsImageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItemsImages();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        //getMore();
      }
    });
  }

  void loadItemsImages() async {
    try {
      List<dynamic> currentPopularItems = await getCurrentPopularItems();
      List<dynamic> currentSaleItems = await getCurrentSaleItems();
      List<dynamic> newItems = await getNewItems();

      setState(() {
        currentPopularImageList = currentPopularItems;
        currentSaleItemsImageList = currentSaleItems;
        newItemsImageList = newItems;
        isLoading = false;
      });
    } catch (e) {
      print('에러남 $e');
      isLoading = false;
    }
  }

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
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => kids()));
                            },
                            child: Text(
                              '키즈',
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => bagAndShoes()));
                            },
                            child: Text(
                              '백&슈즈',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    )),
                    // child: Center(
                    //   child: Text(
                    //     'Fixed Top Container',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 20.0,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[0]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[1]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[2]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // 간격 조절
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[3]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[4]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[5]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // 간격 조절

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[6]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[7]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image:
                                    NetworkImage(currentSaleItemsImageList[8]),
                                width: MediaQuery.of(context).size.width / 5,
                                height: 100,
                                fit: BoxFit.cover,
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
                  SizedBox(height: 50),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image: NetworkImage(newItemsImageList[0]),
                                width: MediaQuery.of(context).size.width / 7,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image: NetworkImage(newItemsImageList[1]),
                                width: MediaQuery.of(context).size.width / 7,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image: NetworkImage(newItemsImageList[2]),
                                width: MediaQuery.of(context).size.width / 7,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image: NetworkImage(newItemsImageList[3]),
                                width: MediaQuery.of(context).size.width / 7,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image: NetworkImage(newItemsImageList[4]),
                                width: MediaQuery.of(context).size.width / 7,
                                height: 100,
                                fit: BoxFit.cover,
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
            return SizedBox(
                //width:MediaQuery.of(context).size.width,
                width: 600,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        imgLink,
                      )),
                ));
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

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData})
      : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              addMyData();
            },
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage, width: 200),
          Text('이미지업로드화면'),
          TextField(
            onChanged: (text) {
              setUserContent(text);
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],
      ),
    );
  }
}

class Store1 extends ChangeNotifier {
  var follower = 0;
  var friend = false;
  var profileImage = [];

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  addFollower() {
    if (friend == false) {
      follower++;
      friend = true;
    } else {
      follower--;
      friend = false;
    }
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var name = 'john kim';

  changeName() {
    name = 'john park';
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.watch<Store2>().name),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProfileHeader(),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (c, i) =>
                      Image.network(context.watch<Store1>().profileImage[i]),
                  childCount: context.watch<Store1>().profileImage.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3))
          ],
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(
            onPressed: () {
              context.read<Store1>().addFollower();
            },
            child: Text('팔로우')),
        ElevatedButton(
            onPressed: () {
              context.read<Store1>().getData();
            },
            child: Text('사진가져오기')),
      ],
    );
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

var firstAccess = true;

class _LoginScreenState extends State<LoginScreen> {
  var tabIndex =0;

  signOut() async {
    await FirebaseAuth.instance.signOut();
    // 이후 로그아웃 후 처리할 작업을 추가할 수 있습니다.
  }



  @override
  Widget build(BuildContext context) {

    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        // 로딩 중일 때의 화면을 반환합니다.
        return CircularProgressIndicator();
      }
      else{
        if (snapshot.hasData && snapshot.data!.uid != null){ //login 돼있는 경우

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
                              onPressed: () async{
                                await signOut();
                                setState(() {
                                  firstAccess = false;
                                });
                                print('지금인');


                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a1, a2) =>
                                          LoginScreen(),
                                      transitionsBuilder:
                                          (context, a1, a2, child) =>
                                          FadeTransition(
                                              opacity: a1, child: child),
                                      transitionDuration:
                                      Duration(milliseconds: 100),
                                    ));
                              }),
                        ),
                        SizedBox(
                            height: 50,
                            child: Text('${auth.currentUser?.email}님 반갑습니다.')
                        ),
                        SizedBox(
                          height: 50,
                          child: Text('주문/혜택 등의 정보를 빠르게 확인할 수 있습니다.',
                              style: TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
            ],
          );
        }

        else{ //로그인 안돼있는 경우
          if(firstAccess){ //첫 화면접속
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
                                      PageRouteBuilder(
                                        pageBuilder: (context, a1, a2) =>
                                            idAndPassword(),
                                        transitionsBuilder:
                                            (context, a1, a2, child) =>
                                            FadeTransition(
                                                opacity: a1, child: child),
                                        transitionDuration:
                                        Duration(milliseconds: 200),
                                      ));
                                }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/2,
                            height: 50,
                            child: Text('주문/혜택 등의 정보를 빠르게 확인할 수 있습니다.',
                                style: TextStyle(color: Colors.grey, fontSize: 15)),
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

          }
          else{ //첫 화면 접속x
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      firstAccess=true;
                    });
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) =>
                              MyApp(),
                          transitionsBuilder:
                              (context, a1, a2, child) =>
                              FadeTransition(
                                  opacity: a1, child: child),
                          transitionDuration:
                          Duration(milliseconds: 100),
                        ));
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
                      //shoppingCart();
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a1, a2) => shoppingCart(),
                            transitionsBuilder: (context, a1, a2, child) =>
                                FadeTransition(opacity: a1, child: child),
                            transitionDuration: Duration(milliseconds: 500),
                          ));
                    },
                    iconSize: 30,
                  ),
                ],
              ),
              body: Column(
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
                                        PageRouteBuilder(
                                          pageBuilder: (context, a1, a2) =>
                                              idAndPassword(),
                                          transitionsBuilder:
                                              (context, a1, a2, child) =>
                                              FadeTransition(
                                                  opacity: a1, child: child),
                                          transitionDuration:
                                          Duration(milliseconds: 200),
                                        ));
                                  }),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              height: 50,
                              child: Text('주문/혜택 등의 정보를 빠르게 확인할 수 있습니다.',
                                  style: TextStyle(color: Colors.grey, fontSize: 15)),
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
      }
    });


  }
}

class idAndPassword extends StatefulWidget {
  const idAndPassword({super.key});

  @override
  State<idAndPassword> createState() => _idAndPasswordState();
}

class _idAndPasswordState extends State<idAndPassword> {
  var id = '';
  var passWord = '';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  alreadyLogin() {
    Navigator.of(context).pop();
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
              //shoppingCart();
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, a1, a2) => shoppingCart(),
                    transitionsBuilder: (context, a1, a2, child) =>
                        FadeTransition(opacity: a1, child: child),
                    transitionDuration: Duration(milliseconds: 500),
                  ));
            },
            iconSize: 30,
          ),
        ],
      ),
      body: Column(
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
                          transitionsBuilder: (context, a1, a2, child) =>
                              FadeTransition(opacity: a1, child: child),
                          transitionDuration: Duration(milliseconds: 200),
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
      ),
    );
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

      await auth.signInWithEmailAndPassword(
        email: id,
        password: passWord,
      );

      // 로그인 API 호출 spring
      Response response = await Dio().post(
        'http://localhost:8080/api/login',
        data: {'username': username, 'password': password},
      );
      print('로그인 성공: ${response.data}');

      // ignore: use_build_context_synchronously
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
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      // 2초 후에 화면 전환 수행
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
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

//회원가입
class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  var id = '';
  var passWord = '';
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
                //shoppingCart();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a1, a2) => shoppingCart(),
                      transitionsBuilder: (context, a1, a2, child) =>
                          FadeTransition(opacity: a1, child: child),
                      transitionDuration: Duration(milliseconds: 500),
                    ));
              },
              iconSize: 30,
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: SizedBox(
                width: 200,
                child: Text('회원가입',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 로그인 버튼 클릭 시 실행될 로직 작성
                      firebaseRegistration();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(vertical: 30, horizontal: 50),
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
        ));
  }

  bool isValidEmail(String email) {
    // 이메일 유효성 검사를 위한 정규표현식 사용
    // 여기서는 간단한 형태의 정규표현식을 사용하였습니다. 실제 프로덕션 환경에 맞게 수정해야 합니다.
    // 이메일 형식이 잘못된 경우 false를 반환합니다.
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  firebaseRegistration() async {
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      if (id.isEmpty || passWord.isEmpty) {
        throw '이메일과 비밀번호를 모두 입력해주세요.';
      }

      if (!isValidEmail(id)) {
        throw '올바른 이메일 주소를 입력해주세요.';
      }

      await auth.createUserWithEmailAndPassword(
        email: id,
        password: passWord,
      );

      // 회원가입 API 호출
      Response response = await Dio().post(
        'http://localhost:8080/api/signup',
        data: {'username': username, 'password': password},
      );
      print('회원가입 성공: ${response.data}');

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

    print('4124');
  }
}

// Navigator.push(
// context,
// PageRouteBuilder(
// pageBuilder: (context, a1, a2) => idAndPassword(),
// transitionsBuilder: (context, a1, a2, child) =>
// FadeTransition(opacity: a1, child: child),
// transitionDuration: Duration(milliseconds: 200),
// ));
getData() async {
  // await firestore.collection('product').add({'name' : '바지', });
  await firestore.collection('product').get();

  // await auth.signOut(); 로그아웃

  try {
    await auth.signInWithEmailAndPassword(
      // var result = await auth.createUserWithEmailAndPassword(
      email: "kim@test.com",
      password: "123456",
    );
    // result.user?.updateDisplayName('john');
    // print(result.user);
    if (auth.currentUser?.uid == null) {
      print('로그인 안된 상태');
    } else {
      print('로그인 하셨네');
    }
  } catch (e) {
    print(e);
  }
}
