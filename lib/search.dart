import 'dart:convert';
import 'package:capstone/productDetail.dart';
import 'package:capstone/shoppingCart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'ClothesModel.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

// 검색 기록 정보를 제공하는 Provider 클래스
class SearchRecordsProvider extends ChangeNotifier {
  List<String> searchedRecordsList = [];
  var maxSize = 5;

  // 현재 사용자 아이디를 가져오는 게터
  List<String> getSearchedRecords() {
    return searchedRecordsList;
  }

  void delete(index) {
    //index 데이터 삭제
    searchedRecordsList.removeAt(index);
  }

  void add(String word) {
    //검색 데이터 추가
    if (searchedRecordsList.length < maxSize) {
      searchedRecordsList.add(word);
    } else {
      searchedRecordsList.removeAt(0);
      searchedRecordsList.add(word);
    }
  }
}

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField with border only at the bottom
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    // width: MediaQuery.of(context).size.width/1.5,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        //hintText: '브랜드, 상품, 프로필, 태그 등...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0), // 테두리 둥글기
                          borderSide: const BorderSide(
                            color: Colors.black38, // 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black45, // 포커스된 테두리 색상
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a1, a2) =>
                                    moveSearchPage(
                                        item: _searchController.text),
                                transitionsBuilder: (context, a1, a2, child) =>
                                    FadeTransition(opacity: a1, child: child),
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                              ),
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(width: 20),
                ],
              ),
            ),

            const SizedBox(height: 16.0), // 간격 추가

            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: context
                      .read<SearchRecordsProvider>()
                      .searchedRecordsList
                      .length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, a1, a2) => moveSearchPage(
                                  item: context
                                      .read<SearchRecordsProvider>()
                                      .getSearchedRecords()[index]),
                              transitionsBuilder: (context, a1, a2, child) =>
                                  FadeTransition(opacity: a1, child: child),
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ));
                      },
                      child: ListTile(
                        title: Text(context
                            .read<SearchRecordsProvider>()
                            .getSearchedRecords()[index]),
                        trailing: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                context
                                    .read<SearchRecordsProvider>()
                                    .delete(index);
                              });
                            }),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8.0),

            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  // 검색 버튼 클릭 시 호출되는 함수
  void onSearch() {
    // TODO: 검색 기능 구현
    print('Searching... Query: ${_searchController.text}');

    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) =>
              moveSearchPage(item: _searchController.text),
          transitionsBuilder: (context, a1, a2, child) =>
              FadeTransition(opacity: a1, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ));
  }
}

class moveSearchPage extends StatefulWidget {
  moveSearchPage({Key? key, this.item}) : super(key: key);
  var item; // 검색어 String값

  @override
  State<moveSearchPage> createState() => _moveSearchPageState();
}

class _moveSearchPageState extends State<moveSearchPage> {
  late TextEditingController _searchController;
  var scroll = ScrollController();

  bool itemCheck = false; //clothesData 유,무 check변수
  bool isLoading = true;

  List<ClothesModel> searchedItemList = [];
  List<ClothesModel> sortedItemList = [];
  int selectFilter = 1;

  //검색한 단어에 대한 List가져오기
  Future<void> getSearchedItemList() async {
    var data = await http.get(Uri.parse(
        'http://3.25.202.52:8080/api/clothes/search/${widget.item}?gender=&major_category=&sub_category='));
    context.read<SearchRecordsProvider>().add(widget.item); // 검색 기록.

    if (data.body == "[]") {
      // 응답 본문이 비어 있는 경우
      print('응답 본문이 비어 있습니다.');
    } else {
      // 응답 본문에 데이터가 있는 경우
      print('응답 본문에 데이터가 있습니다.');
    }

    if (data.body != "[]") {
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      //해당 검색어를 의류명으로 가진 data get
      var jsonData = json.decode(utf8DecodedBody);

      for (var e in jsonData) {
        ClothesModel clothes = new ClothesModel();
        clothes.clothesId = e["clothesId"];
        clothes.name = e["name"];
        clothes.price = e["price"];
        clothes.companyName = e["companyName"];
        clothes.imageUrl = e["imageUrl"];
        searchedItemList.add(clothes);
        print("qweqwe${clothes.clothesId}");
      }

      print("clothesData exist");
      setState(() {
        itemCheck = true;
      });
    } else {
      print("clothesData not exist");
      setState(() {
        isLoading = false;
        itemCheck = false;
      });
    }
  }

  Future<void> sortItemList(int index) async {
    final data = await http.put(
      Uri.parse('http://3.25.202.52:8080/api/clothes/sort/${index}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(searchedItemList.map((item) => item.toJson()).toList()),
    );

    print(data.statusCode);

    if (data.statusCode == 404) {
      print("clothesData sort failed");
      setState(() {
        isLoading = false;
        itemCheck = false;
      });
    } else {
      // 만약 서버가 생성 요청을 성공적으로 처리했다면,
      print("Success to sort Clothes");

      for (var e in searchedItemList) {
        print("${e.getClothesId} 변경전");
      }
      print("${index} 클릭 sortNum");

      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      //해당 검색어를 의류명으로 가진 data get
      var jsonData = json.decode(utf8DecodedBody);
      List<ClothesModel> list = [];

      for (var e in jsonData) {
        ClothesModel clothes = new ClothesModel();
        clothes.clothesId = e["clothesId"];
        clothes.name = e["name"];
        clothes.price = e["price"];
        clothes.companyName = e["companyName"];
        clothes.imageUrl = e["imageUrl"];
        list.add(clothes);
        print("${clothes.getClothesId} 변경후");
      }

      print("clothesData exist");
      setState(() {
        isLoading = false;
        sortedItemList = list;
      });
    }
  }

  void getData() async {
    await getSearchedItemList();
    await sortItemList(1);
  }

  void _showSortOptions() {
    // 팝업 메뉴를 표시하고 선택된 항목을 처리하는 로직
    final screenSize = MediaQuery.of(context).size; // 화면 크기 가져오기
    final screenWidth = screenSize.width; // 화면 너비
    final screenHeight = screenSize.height; // 화면 높이
    int selectFilter = 1;

    // 우측 하단에 위치시키기
    RelativeRect position = RelativeRect.fromLTRB(
      screenWidth - 200, // 팝업의 오른쪽 가장자리에서 150 픽셀 왼쪽으로 이동
      screenHeight - 200, // 팝업의 아래쪽 가장자리에서 150 픽셀 위로 이동
      0,
      0,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          child: Text('인기순'),
          value: 1,
        ),
        const PopupMenuItem(
          child: Text('최신순'),
          value: 2,
        ),
        const PopupMenuItem(
          child: Text('댓글순'),
          value: 3,
        ),
        const PopupMenuItem(
          child: Text('좋아요순'),
          value: 4,
        ),
        const PopupMenuItem(
          child: Text('조회수순'),
          value: 5,
        ),
      ],
    ).then((value) async {
      // 사용자가 팝업 메뉴에서 항목을 선택한 경우 선택된 옵션을 저장하고 처리
      await sortItemList(value!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    _searchController = TextEditingController(text: widget.item);

    // 검색어가 존재할 때
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : itemCheck
            ? Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text(
                    '검색',
                    style: TextStyle(fontSize: 15),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, a1, a2) => search(),
                              transitionsBuilder: (context, a1, a2, child) =>
                                  FadeTransition(opacity: a1, child: child),
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ));
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () async {
                        if (context
                            .read<UserProvider>()
                            .getCurrentUser()
                            .isEmpty) {
                          bool confirmation = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('로그인'),
                                content: const Text(
                                    '로그인이 필요한 서비스입니다.?\n로그인 하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // "네"를 눌렀을 때 true를 반환
                                    },
                                    child: const Text('네'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // "아니오"를 눌렀을 때 false를 반환
                                    },
                                    child: const Text('아니오'),
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
                                      const idAndPassword(),
                                  transitionsBuilder: (context, a1, a2,
                                          child) =>
                                      FadeTransition(opacity: a1, child: child),
                                  transitionDuration:
                                      const Duration(milliseconds: 100),
                                ));
                          }
                        } else {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a1, a2) =>
                                    const shoppingCart(),
                                transitionsBuilder: (context, a1, a2, child) =>
                                    FadeTransition(opacity: a1, child: child),
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                              ));
                        }
                      },
                      iconSize: 30,
                    ),
                  ],
                ),
                body: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                //검색창
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    //hintText: '브랜드, 상품, 프로필, 태그 등...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          12.0), // 테두리 둥글기
                                      borderSide: const BorderSide(
                                        color: Colors.black38, // 테두리 색상
                                        width: 1.0, // 테두리 두께
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                        color: Colors.black45, // 포커스된 테두리 색상
                                        width: 2.0,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                moveSearchPage(
                                                    item:
                                                        _searchController.text),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.search),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(width: 20),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${NumberFormat('#,##0').format(searchedItemList.length)}개 상품",
                              ),
                              DropdownButton<int>(
                                icon: null,
                                value: selectFilter,
                                underline: null,
                                items: <int>[1, 2, 3, 4, 5]
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(convertFilterName(e)),
                                        ))
                                    .toList(),
                                onChanged: (int? value) async {
                                  if (value != null) {
                                    selectFilter = value;
                                    await sortItemList(value);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (c, i) => Container(
                            //color: Colors.grey,
                            child: GestureDetector(
                              onTap: () {
                                print(
                                    "searchedItem is ${sortedItemList[i].getClothesId}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => productDetail(
                                            item: sortedItemList[i]
                                                .getClothesId)));
                              },
                              child: ShopItem(
                                clothes: sortedItemList[i],
                              ),
                            ),
                          ),
                          childCount: sortedItemList.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 25.0,
                          crossAxisSpacing: 15.0,
                          childAspectRatio: 0.45, // 아이템의 가로 세로 비율
                        ),
                      ),
                    ],
                  ),
                ),
                // floatingActionButton: FloatingActionButton(
                //   onPressed: _showSortOptions,
                //   child: const Icon(Icons.sort),
                // ),
              )
            :
            //아이템 없는경우
            Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text(
                    '검색',
                    style: TextStyle(fontSize: 15),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, a1, a2) => search(),
                              transitionsBuilder: (context, a1, a2, child) =>
                                  FadeTransition(opacity: a1, child: child),
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ));
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () async {
                        if (context
                            .read<UserProvider>()
                            .getCurrentUser()
                            .isEmpty) {
                          bool confirmation = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('로그인'),
                                content: const Text(
                                    '로그인이 필요한 서비스입니다.?\n로그인 하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // "네"를 눌렀을 때 true를 반환
                                    },
                                    child: const Text('네'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // "아니오"를 눌렀을 때 false를 반환
                                    },
                                    child: const Text('아니오'),
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
                                      const idAndPassword(),
                                  transitionsBuilder: (context, a1, a2,
                                          child) =>
                                      FadeTransition(opacity: a1, child: child),
                                  transitionDuration:
                                      const Duration(milliseconds: 100),
                                ));
                          }
                        } else {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a1, a2) =>
                                    const shoppingCart(),
                                transitionsBuilder: (context, a1, a2, child) =>
                                    FadeTransition(opacity: a1, child: child),
                                transitionDuration:
                                    const Duration(milliseconds: 500),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                //검색창
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    //hintText: '브랜드, 상품, 프로필, 태그 등...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          12.0), // 테두리 둥글기
                                      borderSide: const BorderSide(
                                        color: Colors.black38, // 테두리 색상
                                        width: 1.0, // 테두리 두께
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                        color: Colors.black45, // 포커스된 테두리 색상
                                        width: 2.0,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, a1, a2) =>
                                                moveSearchPage(
                                                    item:
                                                        _searchController.text),
                                            transitionsBuilder:
                                                (context, a1, a2, child) =>
                                                    FadeTransition(
                                                        opacity: a1,
                                                        child: child),
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.search),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(width: 20),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16.0), // 간격 추가

                        Center(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('검색결과가 없습니다.'),
                                  Text('검색어를 바꾸어 보세요.'),
                                ],
                              )),
                        ),
                      ],
                    );
                  },
                ),
              );
  }
}

String convertFilterName(int filterId) {
  if (filterId == 1) {
    return "인기순";
  } else if (filterId == 2) {
    return "최신순";
  } else if (filterId == 3) {
    return "댓글순";
  } else if (filterId == 4) {
    return "좋아요순";
  } else {
    return "조회수순";
  }
}

class ShopItem extends StatefulWidget {
  ClothesModel clothes;

  ShopItem({super.key, required this.clothes});

  @override
  State<ShopItem> createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {
  int likeCount = 0;
  int commentCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadData();
    isLoading = false;
  }

  Future<void> loadData() async {
    var result = await http.get(Uri.parse(
        "http://3.25.202.52:8080/api/comment/clothes/${widget.clothes.clothesId}"));
    commentCount = (jsonDecode(result.body) as List<dynamic>).length;
    var result2 = await http.get(Uri.parse(
        "http://3.25.202.52:8080/api/like/clothes/${widget.clothes.clothesId}"));
    print(result2.body);
    likeCount = (jsonDecode(result2.body) as List<dynamic>).length;
    print(commentCount);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.clothes.getImageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width / 2 - 15,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.clothes.companyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.clothes.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                NumberFormat('#,###').format(widget.clothes.price),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_outline,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              FutureBuilder(
                future: http.get(Uri.parse(
                    "http://3.25.202.52:8080/api/like/clothes/${widget.clothes.clothesId}")),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("0");
                  }
                  if (snapshot.hasError) {
                    return Text("0");
                  }
                  if (!snapshot.hasData) {
                    return Text("0");
                  }
                  final data = jsonDecode(snapshot.data!.body) as List<dynamic>;

                  if (data!.length == 0) {
                    return Text("0");
                  } else {
                    return Text(data.length.toString());
                  }
                },
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(height: 10, child: VerticalDivider()),
              SizedBox(
                width: 5,
              ),
              FutureBuilder(
                future: http.get(Uri.parse(
                    "http://3.25.202.52:8080/api/comment/clothes/${widget.clothes.clothesId}")),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("리뷰 0");
                  }
                  if (snapshot.hasError) {
                    return Text("리뷰 0");
                  }
                  if (!snapshot.hasData) {
                    return Text("리뷰 0");
                  }
                  final data = jsonDecode(snapshot.data!.body) as List<dynamic>;

                  if (data!.length == 0) {
                    return Text("리뷰 0");
                  } else {
                    return Text("리뷰 ${data.length.toString()}");
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
