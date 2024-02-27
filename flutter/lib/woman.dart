import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import './search.dart';
import './shoppingCart.dart';
import './Login.dart';

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
        title: Text('여성'),
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
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();
  var _current = 0;
  final CarouselController _controller = CarouselController();
  var isLoading = true;
  var categoryIndex = 0;

  List<dynamic> womanRankingItems = [];
  List<dynamic> womanOuterItems = [];
  List<dynamic> womanJacketeItems = [];
  List<dynamic> womanKnitItems = [];
  List<dynamic> womanTshirtsItems = [];
  List<dynamic> womanShirtsItems = [];
  List<dynamic> womanPantsItems = [];

  List<dynamic> womanSliderImageList = [];
  List<dynamic> womanRankingImageList = [];

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
      List<dynamic> womanSliderItems = await getWomanSliderItems();
      womanRankingItems = await getWomanRankingItems();
      womanOuterItems = await getWomanOuterItems();
      womanJacketeItems = await getWomanJacketItems();
      womanKnitItems = await getWomanKnitItems();
      womanTshirtsItems = await getWomanTshirtsItems();
      womanShirtsItems = await getWomanShirtsItems();
      womanPantsItems = await getWomanPantsItems();

      setState(() {
        womanSliderImageList = womanSliderItems;
        womanRankingImageList = womanRankingItems;
        categoryIndex=0;
        isLoading = false;
      });
    } catch (e) {
      print('에러남 $e');
      isLoading = false;
    }
  }

  Future<List<dynamic>> getWomanSliderItems() async {
    var result = await firestore.collection('womanSliderItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getWomanRankingItems() async {
    var result = await firestore.collection('womanRankingItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getWomanOuterItems() async {
    var result = await firestore.collection('womanOuterItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getWomanJacketItems() async {
    var result = await firestore.collection('womanJacketItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getWomanKnitItems() async {
    var result = await firestore.collection('womanKnitItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getWomanPantsItems() async {
    var result = await firestore.collection('womanPantsItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getWomanShirtsItems() async {
    var result = await firestore.collection('womanShirtsItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
  }

  Future<List<dynamic>> getWomanTshirtsItems() async {
    var result = await firestore.collection('womanTshirtsItems').get();
    List<dynamic> images = [];
    for (var doc in result.docs) {
      images.add(doc['image']);
    }
    return images;
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
                  SizedBox(
                      height: 400,
                      child: Stack(
                        children: [
                          sliderWidget(),
                          sliderIndicator(),
                        ],
                      )),
                  SizedBox(height: 50),
                  Text('여성페이지'),
                  SizedBox(height: 50),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 2 + 50,
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
                                                all(),
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
                                                outer(),
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
                                                jacket(),
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
                                                knit(),
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
                                                onePiece(),
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
                                                shirts(),
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
                                                tShirts(),
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
                                                pants(),
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
                                                skirt(),
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
                                                underWear(),
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
                                  categoryIndex=0;
                                  changeCategoryIndex(0);
                                });
                              },
                              child: Text('전체', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  categoryIndex=1;
                                  changeCategoryIndex(1);
                                });
                              },
                              child: Text('아우터', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  categoryIndex=2;
                                  changeCategoryIndex(2);
                                });
                              },
                              child: Text('재킷', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  categoryIndex=3;
                                  changeCategoryIndex(3);
                                });
                              },
                              child: Text('니트', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  categoryIndex=4;
                                  changeCategoryIndex(4);
                                });
                              },
                              child: Text('티셔츠', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  categoryIndex=5;
                                  changeCategoryIndex(5);
                                });
                              },
                              child: Text('셔츠', style: TextStyle(fontSize: 10),)),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  categoryIndex=6;
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
                            SizedBox(
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
                                          womanRankingImageList[0]),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
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
                                          womanRankingImageList[1]),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      '3',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image(
                                      image: NetworkImage(
                                          womanRankingImageList[2]),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      '4',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image(
                                      image: NetworkImage(
                                          womanRankingImageList[3]),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      '5',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image(
                                      image: NetworkImage(
                                          womanRankingImageList[4]),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      '6',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image(
                                      image: NetworkImage(
                                          womanRankingImageList[5]),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    child: TextButton(
                      onPressed: () {},
                      child: Text('랭킹 바로가기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: buttonFontSize1(context).toDouble())),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              );
            });
  }

  Widget sliderWidget() {
    double targetWidth = MediaQuery.of(context).size.width > 500 ? 600 : 300;

    return CarouselSlider(
        carouselController: _controller,
        items: womanSliderImageList.map((imgLink) {
          return Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                // 사용자가 이미지를 클릭했을 때 원하는 동작을 수행합니다.
                // 예를 들어, 해당 이미지에 대한 세부 정보를 표시하거나 다른 화면으로 이동할 수 있습니다.
                print('Clicked image: $_current');
                if (_current == 0) {
                  print('0번쨰 클릭');
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => firstSlideTap(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ));
                } else if (_current == 1) {
                  print('1번쨰 클릭');
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => secondSlideTap(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ));
                } else if (_current == 2) {
                  print('2번쨰 클릭');
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => thirdSlideTap(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ));
                }
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

class firstSlideTap extends StatefulWidget {
  const firstSlideTap({super.key});

  @override
  State<firstSlideTap> createState() => _firstSlideTapState();
}

class _firstSlideTapState extends State<firstSlideTap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1'),
      ),
    );
  }
}

class secondSlideTap extends StatefulWidget {
  const secondSlideTap({super.key});

  @override
  State<secondSlideTap> createState() => _secondSlideTapState();
}

class _secondSlideTapState extends State<secondSlideTap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2'),
      ),
    );
  }
}

class thirdSlideTap extends StatefulWidget {
  const thirdSlideTap({super.key});

  @override
  State<thirdSlideTap> createState() => _thirdSlideTapState();
}

class _thirdSlideTapState extends State<thirdSlideTap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3'),
      ),
    );
  }
}

class all extends StatefulWidget {
  const all({super.key});

  @override
  State<all> createState() => _allState();
}

class _allState extends State<all> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('all'),
      ),
    );
  }
}

class outer extends StatefulWidget {
  const outer({super.key});

  @override
  State<outer> createState() => _outerState();
}

class _outerState extends State<outer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('outer'),
      ),
    );
  }
}

class jacket extends StatefulWidget {
  const jacket({super.key});

  @override
  State<jacket> createState() => _jacketState();
}

class _jacketState extends State<jacket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('jacket'),
      ),
    );
  }
}

class knit extends StatefulWidget {
  const knit({super.key});

  @override
  State<knit> createState() => _knitState();
}

class _knitState extends State<knit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('knit'),
      ),
    );
  }
}

class onePiece extends StatefulWidget {
  const onePiece({super.key});

  @override
  State<onePiece> createState() => _onePieceState();
}

class _onePieceState extends State<onePiece> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('onePiece'),
      ),
    );
  }
}

class shirts extends StatefulWidget {
  const shirts({super.key});

  @override
  State<shirts> createState() => _shirtsState();
}

class _shirtsState extends State<shirts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shirts'),
      ),
    );
  }
}

class tShirts extends StatefulWidget {
  const tShirts({super.key});

  @override
  State<tShirts> createState() => _tShirtsState();
}

class _tShirtsState extends State<tShirts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tShirts'),
      ),
    );
  }
}

class pants extends StatefulWidget {
  const pants({super.key});

  @override
  State<pants> createState() => _pantsState();
}

class _pantsState extends State<pants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pants'),
      ),
    );
  }
}

class skirt extends StatefulWidget {
  const skirt({super.key});

  @override
  State<skirt> createState() => _skirtState();
}

class _skirtState extends State<skirt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('skirt'),
      ),
    );
  }
}

class underWear extends StatefulWidget {
  const underWear({super.key});

  @override
  State<underWear> createState() => _underWearState();
}

class _underWearState extends State<underWear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('underWear'),
      ),
    );
  }
}
