import 'dart:convert';

import 'package:capstone/ClothesModel.dart';
import 'package:capstone/productDetail.dart';
import 'package:capstone/search.dart';
import 'package:capstone/shoppingCart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'main.dart';




class category extends StatefulWidget {
  category({Key? key, this.gender, this.majorCategory}) : super(key: key);
  final gender;
  final majorCategory;

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  var scroll = ScrollController();

  bool isLoading = true;

  List<ClothesModel> categoryItems = [];
  List<String> subCategoryList = [];
  List<dynamic> subCategory = [];

  var selectedSubCategory;




  Future <void> changeCategory(int selectedSubCategoryNum) async{
    var data = await http.get(Uri.parse(
        'http://3.25.202.52:8080/api/clothes?gender=${widget.gender}&major_category=${widget.majorCategory}&sub_category=${selectedSubCategoryNum}'));
    if(data.statusCode ==200){
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      //해당 검색어를 의류명으로 가진 data get
      var jsonData = json.decode(utf8DecodedBody);

      List <ClothesModel> list = [];

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];
        list.add(box);

        print("category clothesData exist");
      }
      setState(() {
        categoryItems = list;
      });
    }else{
      throw ("category clothesData not exist");
    }
  }

  Future<void> getClothesData() async{
    var data;

    if(widget.majorCategory==0){ // 전체 상품의 경우
      data = await http.get(Uri.parse(
          'http://3.25.202.52:8080/api/clothes?gender=${widget.gender}&major_category=&sub_category='));

    }else{ // majorCategory를 선택한 경우
      data = await http.get(Uri.parse(
          'http://3.25.202.52:8080/api/clothes?gender=${widget.gender}&major_category=${widget.majorCategory}&sub_category=${subCategory[0]}'));
    }

    if(data.statusCode ==200){
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      //해당 검색어를 의류명으로 가진 data get
      var jsonData = json.decode(utf8DecodedBody);

      for (var e in jsonData) {
        ClothesModel box = new ClothesModel();
        box.clothesId = e["clothesId"];
        box.name = e["name"];
        box.price = e["price"];
        box.companyName = e["companyName"];
        box.imageUrl = e["imageUrl"];

        categoryItems.add(box);

        print("category clothesData exist");
      }

      setState(() {
        isLoading = false;
      });
    }else{
      throw ("category clothesData not exist");
    }

    //일단 세부 카테고리 없이 해당 majorcategory 전부 출력.
  }

  void getData() async {
    await getClothesData();
  }

  void setCategory() {
    switch (widget.majorCategory){
      case 0:
        break;
      case 1:
        setState(() {
          subCategoryList = ["점퍼", "코트", "다운/패딩", "레더재킷", "퍼"];
          subCategory = [1,2,3,4,5];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 2:
        setState(() {
          subCategoryList = ["정장재킷", "정장팬츠", "드레스셔츠", "정장베스트"];
          subCategory = [6,7,8,9];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 3:
        setState(() {
          subCategoryList = ["치노", "슬렉스", "수트팬츠", "조거/스웻", "데님", "쇼츠", "와이드팬츠", "스트레이트팬츠", "슬림", "조거"];
          subCategory = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 4:
        setState(() {
          subCategoryList = ["재킷", "블레이저", "레더재킷", "베스트"];
          subCategory = [20, 21, 22, 23];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 5:
        setState(() {
          subCategoryList = ["긴팔셔츠", "반팔셔츠"];
          subCategory = [24,25];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 6:
        setState(() {
          subCategoryList = ["풀오버", "가디건", "베스트"];
          subCategory = [26,27,28];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 7:
        setState(() {
          subCategoryList = ["반팔티셔츠", "긴팔티셔츠", "민소매"];
          subCategory = [29,30,31];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 8:
        setState(() {
          subCategoryList = ["모자", "벨트", "스카프/머플러", "양말"];
          subCategory = [32,33,34,35];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 9:
        setState(() {
          subCategoryList = ["언더웨어"];
          subCategory = [36];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 10:
        setState(() {
          subCategoryList = ["쥬얼리", "귀걸이", "목걸이", "반지", "시계"];
          subCategory = [37,38,39,40,41];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 11:
        setState(() {
          subCategoryList = ["셔츠", "블라우스"];
          subCategory = [42,43];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 12:
        setState(() {
          subCategoryList = ["긴팔", "반팔/민소매"];
          subCategory = [44,45];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 13:
        setState(() {
          subCategoryList = ["롱/미디", "미니"];
          subCategory = [46,47];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 14:
        setState(() {
          subCategoryList = ["파자마", "로브", "브라", "팬티", "세트"];
          subCategory = [48,49,50,51,52];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 15:
        setState(() {
          subCategoryList = ["스윔수트", "비키니"];
          subCategory = [53,54];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 16:
        setState(() {
          subCategoryList = ["다운/패딩", "점퍼", "코트", "재킷/베스트"];
          subCategory = [55,56,57,58];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 17:
        setState(() {
          subCategoryList = ["긴팔", "반팔/민소매"];
          subCategory = [59,60];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 18:
        setState(() {
          subCategoryList = ["긴팔", "반팔"];
          subCategory = [61,62];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 19:
        setState(() {
          subCategoryList = ["긴팔", "반팔"];
          subCategory = [63,64];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 20:
        setState(() {
          subCategoryList = ["풀오버", "카디건/베스트"];
          subCategory = [65,66];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 21:
        setState(() {
          subCategoryList = ["롱팬츠", "쇼트팬츠"];
          subCategory = [67,68];
          selectedSubCategory = subCategory[0];
        });
        break;
      case 22:
        setState(() {
          subCategoryList = ["운동화/스니커즈", "워커/부츠", "슬리퍼/뮬", "슬립온", "구두", "샌들", "등산화/골프화", "펌프스/힐", "플랫/로퍼"];
          subCategory = [69,70,71,72,73,74,75,76,77];
          selectedSubCategory = subCategory[0];
        });
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCategory(); // 선택한 majorCategory에 따라 표시할 subCategory 정렬
    getData();

  }



  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '카테고리',
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

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 25,
                ),
              ),


              if(widget.majorCategory!=0)
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<int>(
                          value: selectedSubCategory,
                          items: List.generate(subCategoryList.length, (index) {
                            return DropdownMenuItem<int>(
                              value: subCategory[index],
                              child: Text(subCategoryList[index]),
                            );
                          }),
                          onChanged: (newValue) async {

                            setState(() {
                              selectedSubCategory = newValue!;
                            });

                            await changeCategory(selectedSubCategory);
                          },
                        ),
                        SizedBox(height: 8,),
                        Text("${NumberFormat('#,##0').format(categoryItems.length)}개 상품")
                      ],
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Container(
                  height: 25,
                ),
              ),

              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (c, i) => GestureDetector(
                      onTap: (){
                        print(
                            "searchedItem is ${categoryItems[i].getClothesId}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    productDetail(item: categoryItems[i].getClothesId)));
                      },
                      child: ShopItem(clothes: categoryItems[i])),
                  childCount: categoryItems.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.45,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 15
                ),
              ),
            ]
        ),
      ),








    );
  }


}
