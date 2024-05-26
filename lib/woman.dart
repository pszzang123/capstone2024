import 'dart:convert';

import 'package:capstone/ClothesModel.dart';
import 'package:capstone/category.dart';
import 'package:capstone/productDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import './search.dart';
import './shoppingCart.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class woman extends StatefulWidget {
  const woman({super.key});

  @override
  State<woman> createState() => _womanState();
}

class _womanState extends State<woman> {
  var tabIndex = 0;



  @override
  Widget build(BuildContext context) {
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
              if (context
                  .read<UserProvider>()
                  .getCurrentUser()
                  .isEmpty) {
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
                        pageBuilder: (context, a1, a2) =>
                            idAndPassword(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ));
                }
              }
              else{
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
      body: Column(
        children: [
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
          if(i==0){
            Navigator.of(context).pop();
          }

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
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();
  var _current = 0;
  final CarouselController _controller = CarouselController();
  var isLoading = true;

  var gender=1; // woman



  List<ClothesModel> womanRankingItems = [];
  List<ClothesModel> womanOuterItems = [];
  List<ClothesModel> womanJacketeItems = [];
  List<ClothesModel> womanKnitItems = [];
  List<ClothesModel> womanTshirtsItems = [];
  List<ClothesModel> womanShirtsItems = [];
  List<ClothesModel> womanPantsItems = [];

  List<ClothesModel> womanSliderImageList = [];
  List<ClothesModel> womanRankingImageList = [];

  changeCategoryIndex(i) {

    setState(() {
      switch (i) {
        case 0:
          womanRankingImageList = womanRankingItems;
          break;
        case 1:
          womanRankingImageList = womanOuterItems;
          break;
        case 2:
          womanRankingImageList = womanJacketeItems;
          break;
        case 3:
          womanRankingImageList = womanKnitItems;
          break;
        case 4:
          womanRankingImageList = womanTshirtsItems;
          break;
        case 5:
          womanRankingImageList = womanShirtsItems;
          break;
        case 6:
          womanRankingImageList = womanPantsItems;
          break;
      }
    });
  }

  void loadItemsImages() async {
    try {
      await getWomanSliderItems();

      await getWomanRankingItems();
      await getWomanOuterItems();
      await getWomanJacketItems();
      await getWomanKnitItems();
      await getWomanPantsItems();
      await getWomanTshirtsItems();
      await getWomanShirtsItems();

      setState(() {
        womanRankingImageList = womanRankingItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      print('에러남 $e');
    }
  }

  Future<void> getWomanSliderItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=1&sub_category=1'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.

    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanSliderImageList.add(box);

        print("slider clothesData exist");
      }

    }else{
      throw ('slider clothesData not exist');
    }


  }

  Future<void> getWomanRankingItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=1&sub_category=4'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.


    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanRankingItems.add(box);

        print("ranking clothesData exist");
      }

    }else{
      throw ('ranking clothesData not exist');
    }

  }

  Future<void> getWomanOuterItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=1&sub_category=1'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.


    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanOuterItems.add(box);

        print("outer clothesData exist");
      }

    }else{
      throw ('outer clothesData not exist');
    }

  }

  Future<void> getWomanJacketItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=4&sub_category=20'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.


    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanJacketeItems.add(box);

        print("jacket clothesData exist");
      }

    }else{
      throw ('jacket clothesData not exist');
    }

  }

  Future<void> getWomanKnitItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=6&sub_category=26'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.


    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanKnitItems.add(box);

        print("knit clothesData exist");
      }

    }else{
      throw ('knit clothesData not exist');
    }

  }

  Future<void> getWomanPantsItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=3&sub_category=10'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.


    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanPantsItems.add(box);

        print("pants clothesData exist");
      }

    }else{
      throw ('pants clothesData not exist');
    }

  }

  Future<void> getWomanShirtsItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=5&sub_category=24'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.


    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanShirtsItems.add(box);

        print("shirts clothesData exist");
      }

    }else{
      throw ('shirts clothesData not exist');
    }

  }

  Future<void> getWomanTshirtsItems() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes?gender=${gender}&major_category=7&sub_category=29'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.


    if(data.statusCode==200){
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        womanTshirtsItems.add(box);

        print("tShirts clothesData exist");
      }

    }else{
      throw ('tShirts clothesData not exist');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItemsImages();
  }

  @override
  Widget build(BuildContext context) {
    // return isLoading ? Center(child:CircularProgressIndicator()) :
    // Scaffold(

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: 1,
            controller: scroll,
            itemBuilder: (c, i) {
              return Column(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "WOMAN",
                      style: TextStyle(
                        fontSize: 24.0, // 원하는 크기로 조정
                        fontWeight: FontWeight.bold, // 굵은 글꼴
                      ),
                    ),
                  ),

                  SizedBox(height: 50),
                  SizedBox(
                      height: 400,
                      child: Stack(
                        children: [
                          sliderWidget(),
                          sliderIndicator(),
                        ],
                      )),
                  SizedBox(height: 50),
                  SizedBox(
                    height: (MediaQuery.of(context).size.width / 5)*3+100,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('all clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 0),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/all.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('전체 상품'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('outer clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 1),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/outer.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('아우터'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('jacket clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 4),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/jacket.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('자켓'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('knit clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 6),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/knit.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('니트'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('onePiece clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 12),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/onePiece.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('원피스'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // 간격 조절
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('shirts clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 5),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/shirts.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('셔츠'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('tShirts clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 7),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/tShirts.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('티셔츠'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('pants clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 3),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/pants.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('바지'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('skirt clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 13),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/skirt.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('치마'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('underWear clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 9),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/underWear.jpg',
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('언더웨어'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // 간격 조절

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('beachWear clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 15),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/womanBeachWear.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('비치웨어'),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('accessory clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 8),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/womanAccessory.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('패션잡화'),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('jewerlyAndWatch clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 10),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/womanJewerlyWatch.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('쥬얼리/시계'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('woman shoes clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 22),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/womanShoes.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('신발'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('kids outer clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 16),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/kidsOuter.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('키즈아우터'),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('knit clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 20),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/knit.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('키즈니트'),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('kids pants clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 21),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/pants.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('키즈팬츠'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('kids Tshirts clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 17),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/kidsTShirts.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('여아티셔츠'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 버튼이 클릭되었을 때 수행할 작업을 여기에 추가하세요
                                      print('WShirts clicked!');
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                category(gender : gender, majorCategory: 19),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                FadeTransition(
                                                    opacity: a1,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 500),
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        'assets/girlKid.jpg',
                                        width:
                                        MediaQuery.of(context).size.width / 5,
                                        height:
                                        MediaQuery.of(context).size.width / 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text('여아셔츠'),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('랭킹',
                        style:
                            TextStyle(fontSize: fontSize1(context).toDouble())),
                  ),

                  
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  changeCategoryIndex(0);
                                });
                              },
                              child: Text('전체', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  changeCategoryIndex(1);
                                });
                              },
                              child: Text('아우터', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  changeCategoryIndex(2);
                                });
                              },
                              child: Text('재킷', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  changeCategoryIndex(3);
                                });
                              },
                              child: Text('니트', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  changeCategoryIndex(4);
                                });
                              },
                              child: Text('티셔츠', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  changeCategoryIndex(5);
                                });
                              },
                              child: Text('셔츠', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  changeCategoryIndex(6);
                                });
                              },
                              child: Text('팬츠', style: TextStyle(fontSize: 10),)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    height: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a1, a2) => productDetail(item:womanRankingImageList[0].getClothesId),
                                      transitionsBuilder: (context, a1, a2, child) =>
                                          FadeTransition(opacity: a1, child: child),
                                      transitionDuration: Duration(milliseconds: 100),
                                    )
                                );
                              },
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        '1',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image(
                                        image: NetworkImage(
                                            womanRankingImageList[0].getImageUrl),
                                        width:
                                            MediaQuery.of(context).size.width / 3,
                                        height: MediaQuery.of(context).size.width / 3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a1, a2) => productDetail(item:womanRankingImageList[1].getClothesId),
                                      transitionsBuilder: (context, a1, a2, child) =>
                                          FadeTransition(opacity: a1, child: child),
                                      transitionDuration: Duration(milliseconds: 100),
                                    )
                                );
                              },
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        '2',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image(
                                        image: NetworkImage(
                                            womanRankingImageList[1].getImageUrl),
                                        width:
                                            MediaQuery.of(context).size.width / 3,
                                        height: MediaQuery.of(context).size.width / 3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
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
    double targetWidth = MediaQuery.of(context).size.width > 500 ? 600 : 300;

    return CarouselSlider(
        carouselController: _controller,
        items: womanSliderImageList.map((ClothesModel box) {
          return Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                // 사용자가 이미지를 클릭했을 때 원하는 동작을 수행합니다.
                // 예를 들어, 해당 이미지에 대한 세부 정보를 표시하거나 다른 화면으로 이동할 수 있습니다.
                print('Clicked image: $_current');
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a1, a2) => productDetail(item:womanSliderImageList[_current].getClothesId),
                      transitionsBuilder: (context, a1, a2, child) =>
                          FadeTransition(opacity: a1, child: child),
                      transitionDuration: Duration(milliseconds: 100),
                    )
                );


              },
              child: SizedBox(
                  //width:MediaQuery.of(context).size.width,
                  width: targetWidth,
                  height: targetWidth /
                      (MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          box.getImageUrl,
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
          children: womanSliderImageList.asMap().entries.map((entry) {
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

buttonFontSize1(context) {
  if (MediaQuery.of(context).size.width > 600) {
    return 30.0;
  } else {
    return 14.0;
  }
}

