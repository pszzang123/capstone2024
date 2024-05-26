import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:capstone/AdditionalDetailModel.dart';
import 'package:capstone/ClothesModel.dart';
import 'package:capstone/CommentlGetModel.dart';
import 'package:capstone/CommentlModel.dart';
import 'package:capstone/CustomerModel.dart';
import 'package:capstone/DetailImagesModel.dart';
import 'package:capstone/ReceiptModel.dart';
import 'package:capstone/ReceiptDetailModel.dart';
import 'package:capstone/search.dart';
import 'package:capstone/shoppingCart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'CartCustomerModel.dart';
import 'CartModel.dart';
import 'DetailModel.dart';
import 'main.dart';
import 'dart:convert';


class productDetail extends StatefulWidget {
  productDetail({Key? key, this.item}) : super(key: key);
  var item;

  @override
  State<productDetail> createState() => _productDetailState();
}

Future<int> getCartCount(BuildContext context) async {
  print("getCartCount");
  final user = context.read<UserProvider>().getCurrentUser();
  print(user);
  var data =
  await http.get(Uri.parse('http://3.25.202.52:8080/api/cart/${user}'));
  if (data.statusCode == 200) {
    List<dynamic> jsonData = json.decode(data.body);
    print("asdf");
    print(jsonData.length);
    return jsonData.length;
  }
  return 0;
}

class _productDetailState extends State<productDetail> {
  var scroll = ScrollController();
  var scroll2 = ScrollController();
  final CarouselController _controller = CarouselController();
  final TextEditingController _textEditingController = TextEditingController();

  bool isLoading = true;
  bool detailedItemCheck = false; // clothesId에 해당하는 Clothes Data 유무 체크
  bool detailedItemImagesCheck =
  false; // ClothesId에 해당하는 CLothes Image Data 유무 체크
  bool AdditionalDetailedItemCheck =
  false; // ClothesId에 해당하는 모든 detailId data 유무 체크

  var detailId; // 선택한 detailId 저장할 변수.

  DetailModel detailModel = new DetailModel(); //data 담아둘 model.
  List<dynamic> detailImagesList = [];

  CartModel cartModel = new CartModel();
  List<AdditionalDetailModel> ADM = [];

  List<CommentGetModel> CGM = [];
  int count = 0;
  int cartCount = 0;

  var _current = 0;
  int quantity = 1;

  //clothesId 에 해당하는 정보 get ==> name, detail, price, sellerEmail등 정보 필요
  Future<void> getDetailedData() async {
    var data = await http
        .get(Uri.parse('http://3.25.202.52:8080/api/clothes/${widget.item}'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.

    if (data.statusCode == 200) {
      //해당 검색어를 의류명으로 가진 data get
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      var jsonData = json.decode(utf8DecodedBody);

      detailModel.clothesId = jsonData["clothesId"];
      detailModel.name = jsonData["name"];
      detailModel.detail = jsonData["detail"];
      detailModel.genderCategory = jsonData["genderCategory"];
      detailModel.majorCategoryId = jsonData["majorCategoryId"];
      detailModel.subCategoryId = jsonData["subCategoryId"];
      detailModel.price = jsonData["price"];
      detailModel.sellerEmail = jsonData["sellerEmail"];

      setState(() {
        detailedItemCheck = true; //데이터 유무 체크
      });

      print("detailData exist");
    } else {
      print("detailData not exist");
      //data가 없거나 에러인 경우
      setState(() {
        detailedItemCheck = false; // 데이터 없음화면 출력
      });
    }
  }

  // clothesId에 해당하는 Image order 순대로 필요.
  Future<void> getDetailImages() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/clothes_images/${widget.item}'));
    // widget.item = 전달받은 clothes id값. id값을 통해 data get.

    if (data.statusCode == 200) {
      //해당 검색어를 의류명으로 가진 data get
      var jsonData = json.decode(data.body);

      List<DetailImagesModel> box = [];

      for (var e in jsonData) {
        DetailImagesModel image = new DetailImagesModel();
        image.clothesId = e["clothesId"];
        image.imageUrl = e["imageUrl"];
        image.order = e["order"];
        box.add(image);

        print("detailImagesData exist");
      }

      box.sort((a, b) => a.order.compareTo(b.order));
      // order 순서대로 정렬

      for (var e in box) {
        detailImagesList.add(e.getImageUrl);
      }

      setState(() {
        detailedItemImagesCheck = true; //데이터 유무 체크
      });
    } else {
      print("detailImagesData not exist");
      //data가 없거나 에러인 경우
      setState(() {
        detailedItemImagesCheck = false; // 데이터 없음화면 출력
      });
    }
  }

  Future<void> getDetailIDs() async {
    var data = await http.get(
        Uri.parse('http://3.25.202.52:8080/api/detail/clothes/${widget.item}'));
    // widget.item = 전달받은 clothes id값. id값을 통해 해당하는 모든 detail ID값 get.

    if (data.statusCode == 200) {
      //해당 검색어를 의류명으로 가진 data get
      var jsonData = json.decode(data.body);

      for (var e in jsonData) {
        AdditionalDetailModel box = new AdditionalDetailModel();
        box.detailId = e["detailId"];
        box.color = e["color"];
        box.size = e["size"];
        box.remaining = e["remaining"];
        box.clothesId = e["clothesId"];
        ADM.add(box);

        print("detailID Datas exist");
      }

      setState(() {
        detailId = ADM[0].getDetailId.toString();
        AdditionalDetailedItemCheck = true; //데이터 유무 체크
      });
    } else {
      print("detailImagesData not exist");
      //data가 없거나 에러인 경우
      setState(() {
        AdditionalDetailedItemCheck = false; // 데이터 없음화면 출력
      });
    }
  }

  Future<void> getComment() async {
    var data = await http.get(Uri.parse(
        'http://3.25.202.52:8080/api/comment/clothes/${widget.item}'));
    if (data.statusCode == 200) {
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      // 디코딩된 데이터를 JSON으로 파싱
      var jsonData = json.decode(utf8DecodedBody);

      List<CommentGetModel> list = [];

      for (var e in jsonData) {
        CommentGetModel box = new CommentGetModel();
        box.customerEmail = e["customerEmail"];
        box.clothesId = e["clothesId"];
        box.comment = e["comment"];
        box.date = e["date"];
        list.add(box);
      }

      setState(() {
        CGM = list;
      });

      print("get Comment Data success");
    } else {
      throw Exception("get Comment Data success");
    }
  }

  Future<void> addComment() async {
    CommentModel comment = new CommentModel();
    comment.customerEmail = context.read<UserProvider>().getCurrentUser();
    comment.clothesId = widget.item;
    comment.comment = _textEditingController.text;

    final response = await http.post(
      Uri.parse('http://3.25.202.52:8080/api/comment'), // 적절한 엔드포인트를 사용하세요.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(comment.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
    _textEditingController.clear();

    getComment();
  }

  void loadData() async {
    try {
      cartCount = await getCartCount(context);
      await getDetailedData(); //의류 정보 get
      await getDetailImages(); //의류 이미지 get
      await getComment();
      await getDetailIDs();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('에러남 $e');
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
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
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 440,
                    child: Stack(
                      children: [
                        sliderWidget(),
                        sliderIndicator(),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 32.0),
                        child: Text(
                          detailModel.getSellerEmail,
                          style: TextStyle(
                              fontSize: 12, color: Colors.black38),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    width: MediaQuery.of(context).size.width,
                    child: AutoSizeText(
                      maxLines: 2,
                      detailModel.getName,
                      style: TextStyle(
                        fontSize: 22,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 32.0),
                        child: Row(
                          children: [
                            Text(
                              NumberFormat('#,##0')
                                  .format(detailModel.getPrice),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text("원")
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          detailModel.getDetail.toString(),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Divider(),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                    ),
                    child: Text(
                      "옵션",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: DropdownButton<String>(
                      value: detailId,
                      items: ADM.map((AdditionalDetailModel box) {
                        return DropdownMenuItem<String>(
                          value: box.getDetailId.toString(),
                          child: Text('${box.getColor} - ${box.getSize}'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          detailId = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                    ),
                    child: Text(
                      "수량",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(0),
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black87, width: 0.5)),
                            child: IconButton(
                              icon: Icon(
                                Icons.remove,
                                size: 15,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                });
                              },
                            ),
                          ),
                          Container(
                            height: 38,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: Colors.black87, width: 0.5),
                                bottom: BorderSide(
                                    color: Colors.black87, width: 0.5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                quantity.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black87, width: 0.5)),
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                                size: 15,
                              ),
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(height: 25),
                  Divider(),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "상품리뷰 (${CGM.length})",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ]),
          ),
          if (CGM.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 22,
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(CGM[index].getCustomerEmail),
                                Text(CGM[index].getDate.substring(0, 10)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(CGM[index].getComment),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: CGM.length,
              ),
            ),
          SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: '댓글을 입력하세요...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      onPressed: () {
                        if (_textEditingController.text.isNotEmpty) {
                          if (context
                              .read<UserProvider>()
                              .getCurrentUser()
                              .isNotEmpty) {
                            addComment();
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    '!',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  content: Text('로그인이 필요한 서비스입니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
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
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              )),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 65,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_shopping_cart_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '장바구니',
                        style:
                        TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  //장바구니에 담기

                  //로그인 안 한 경우
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
                            transitionsBuilder: (context, a1, a2,
                                child) =>
                                FadeTransition(opacity: a1, child: child),
                            transitionDuration:
                            Duration(milliseconds: 100),
                          ));
                    }
                  } else {
                    // 로그인 한 경우
                    //장바구니에 없는경우
                    //장바구니에 data post.

                    cartModel.customerEmail =
                        context.read<UserProvider>().getCurrentUser();
                    cartModel.detailId = detailId; // 의류세부사항 ID
                    cartModel.quantity = quantity; // 수량

                    final response = await http.post(
                      Uri.parse('http://3.25.202.52:8080/api/cart'),
                      // 적절한 엔드포인트를 사용하세요.
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(cartModel.toJson()),
                    );

                    if (response.statusCode == 201) {
                      //cart에 동일 data가 없어서 해당 data가 cart에 post 된 경우
                      print('Cart DB post Success!');
                      if(!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              '!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            content: Text('장바구니에 담겼습니다.'),
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
                    } else {
                      print('이미 존재하는 DB');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              '!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            content: Text('이미 존재하는 상품입니다.'),
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
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () async {
                  // '구매하기' 텍스트 클릭 시 수행할 작업
                  //로그인 안한 경우
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
                            transitionsBuilder: (context, a1, a2,
                                child) =>
                                FadeTransition(opacity: a1, child: child),
                            transitionDuration:
                            Duration(milliseconds: 100),
                          ));
                    }
                  } else {
                    // 로그인 한 경우.

                    bool purchaseConfirmation = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('구매'),
                          content: Text('구매 하시겠습니까?'),
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

                    if (purchaseConfirmation == true) {
                      var data = await http.get(Uri.parse(
                          'http://3.25.202.52:8080/api/customers/${context.read<UserProvider>().getCurrentUser()}'));
                      if (data.statusCode == 200) {
                        var utf8DecodedBody = utf8.decode(data.bodyBytes);
                        // 디코딩된 데이터를 JSON으로 파싱
                        var jsonData = json.decode(utf8DecodedBody);
                        print("customer Data success");

                        bool purchaseConfirmation2 = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('배송정보'),
                              content: Text(
                                  '${jsonData["streetAddress"]}\n${jsonData["detailAddress"]}\n로 배송 하시겠습니까?'),
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
                                    Navigator.of(context).pop(
                                        false); // "아니오"를 눌렀을 때 false를 반환
                                  },
                                  child: Text('아니오'),
                                ),
                              ],
                            );
                          },
                        );
                        if (purchaseConfirmation2 == true) {
                          ReceiptModel RM = new ReceiptModel();

                          RM.customerEmail = context
                              .read<UserProvider>()
                              .getCurrentUser();
                          RM.status = 0; // 배송상태 설정

                          final response = await http.post(
                            Uri.parse(
                                'http://3.25.202.52:8080/api/receipt'),
                            // 적절한 엔드포인트를 사용하세요.
                            headers: <String, String>{
                              'Content-Type':
                              'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(RM.toJson()),
                          );

                          if (response.statusCode == 201) {
                            //cart에 동일 data가 없어서 해당 data가 cart에 post 된 경우
                            print('Receipt post Success for purchase!');
                            var utf8DecodedBody =
                            utf8.decode(response.bodyBytes);
                            // 디코딩된 데이터를 JSON으로 파싱
                            var jsonData = json.decode(utf8DecodedBody);

                            ReceiptDetailModel RDM =
                            new ReceiptDetailModel();
                            RDM.receiptId = jsonData["receiptId"];
                            RDM.detailId = detailId;
                            RDM.quantity = quantity;
                            RDM.status = 0;

                            final response2 = await http.post(
                              Uri.parse(
                                  'http://3.25.202.52:8080/api/receipt_detail'),
                              // 적절한 엔드포인트를 사용하세요.
                              headers: <String, String>{
                                'Content-Type':
                                'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(RDM.toJson()),
                            );

                            if (response2.statusCode == 201) {
                              // detail 까지 post완료했으므로, 개인 정보에서 확인 가능
                              print(
                                  "Receipt Detail post success for purchase");
                              print("customer purchase");
                            } else {
                              print(
                                  "Receipt Detail post fail for purchase");
                            }
                          } else {
                            print(cartModel.customerEmail);
                            print(cartModel.detailId);
                            print(cartModel.quantity);
                            print('Receipt post fail for purchase!');
                          }
                        } else {
                          print("customer cancel");
                        }
                      } else {
                        print("customer Data fail");
                      }
                    }
                  }
                },
                child: Container(
                  height: 65,
                  color: Color(0xff8e1fff),
                  child: Center(
                    child: Text(
                      '구매하기',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),

            // 추가적인 IconButton 또는 TextButton을 여기에 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }

  Widget sliderWidget() {
    double targetWidth = MediaQuery.of(context).size.width > 500 ? 600 : 350;

    return CarouselSlider(
        carouselController: _controller,
        items: detailImagesList.map((imgLink) {
          return Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                // 사용자가 이미지를 클릭했을 때 원하는 동작을 수행합니다.
                // 예를 들어, 해당 이미지에 대한 세부 정보를 표시하거나 다른 화면으로 이동할 수 있습니다.
                print('Clicked image: $_current');
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
            height: 440,
            viewportFraction: 1.0,
            autoPlay: false,
            //autoPlayInterval: const Duration(seconds: 4),
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
          children: detailImagesList.asMap().entries.map((entry) {
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