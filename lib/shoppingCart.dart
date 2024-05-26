import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'CartCustomerModel.dart';
import 'ReceiptDetailModel.dart';
import 'ReceiptModel.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class shoppingCart extends StatefulWidget {
  const shoppingCart({super.key});

  @override
  State<shoppingCart> createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  bool isLoading = true;
  var scroll = ScrollController();
  var totalPrice = 0;

  List<CartCustomerModel> CCM = [];

  getTotalPrice(){
    setState(() {
      totalPrice=0;
    });
    for(var e in CCM){
      setState(() {
        totalPrice += e.getPrice * e.getQuantity;
      });
    }
  }

  Future<void> getCartData() async{
    var data = await http.get(Uri.parse(
        'http://3.25.202.52:8080/api/cart/${context.read<UserProvider>().getCurrentUser()}'));
    if(data.statusCode ==200){
      var utf8DecodedBody = utf8.decode(data.bodyBytes);
      // 디코딩된 데이터를 JSON으로 파싱
      var jsonData = json.decode(utf8DecodedBody);

      for(var e in jsonData){
        CartCustomerModel list = new CartCustomerModel();
        list.customerEmail = e["customerEmail"];
        list.detailId = e["detailId"];
        list.name = e["name"];
        list.color = e["color"];
        list.size = e["size"];
        list.price = e["price"];
        list.imageUrl = e["imageUrl"];
        list.quantity = e["quantity"];
        CCM.add(list);
      }

      getTotalPrice();


      print("success");
      setState(() {
        isLoading = false;
      });
    }else{
      print("error");
      setState(() {
        isLoading = true;
      });
    }
  }

  void getData() async {
    await getCartData();
  }

  Future<void> deleteThisCartItem(int detailId) async{
    final data = await http.delete(Uri.parse(
        'http://3.25.202.52:8080/api/cart/${context.read<UserProvider>().getCurrentUser()}/${detailId}'));
    if(data.statusCode ==200){

      print("delete Item success");
    }else{
      print("delete Item fail");
    }

    var data2 = await http.get(Uri.parse(
        'http://3.25.202.52:8080/api/cart/${context.read<UserProvider>().getCurrentUser()}'));
    if(data2.statusCode ==200){
      var utf8DecodedBody = utf8.decode(data2.bodyBytes);
      // 디코딩된 데이터를 JSON으로 파싱
      var jsonData = json.decode(utf8DecodedBody);

      CCM.clear();

      for(var e in jsonData){
        CartCustomerModel list = new CartCustomerModel();
        list.customerEmail = e["customerEmail"];
        list.detailId = e["detailId"];
        list.name = e["name"];
        list.color = e["color"];
        list.size = e["size"];
        list.price = e["price"];
        list.imageUrl = e["imageUrl"];
        list.quantity = e["quantity"];
        CCM.add(list);
      }


      getTotalPrice();

      print("success");
      setState(() {
        isLoading = false;
      });
    }else{
      print("error");
      setState(() {
        isLoading = true;
      });
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
    return isLoading ? Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:  Text("장바구니"),
      ),
      body: ListView.builder(
        itemCount: CCM.length,
        controller: scroll,
        itemBuilder: (c,i){
          // 각 아이템의 가격 * 수량을 totalPrice에 누적
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 150,
                child: Row(
                  children: [
                    SizedBox(
                      child: Image.network(
                        CCM[i].getImageUrl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    CCM[i].getName,
                                    maxLines: 1,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () async {
                                    // setState(() {
                                    //   totalPrice = 0;
                                    // });
                                    await deleteThisCartItem(CCM[i].getDetailId);
                                  },
                                ),
                              ]
                          ),
                          Row(
                            children: [
                              Text(
                                "${CCM[i].getColor}, ${CCM[i].getSize}, ${CCM[i].getQuantity.toString()}개",
                                style: TextStyle(color: Colors.black38
                                ),
                                //style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${NumberFormat("#,##0").format(CCM[i].getPrice*CCM[i].getQuantity)} 원',
                                style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15),
                              ),
                            ],
                          ),

                        ],

                      ),
                    )
                  ],
                ),
              ),
              Divider()
            ],
          );

        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 110,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("총 ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    Text(CCM.length.toString(),style: TextStyle(color: Colors.purple[500]),),
                    Text("건",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                Text("${NumberFormat("#,##0").format(totalPrice)}원")
              ],
            ),
            SizedBox(height: 5,),
            TextButton(
              onPressed: () async {
                //recepit API
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
                  if(data.statusCode ==200){
                    var utf8DecodedBody = utf8.decode(data.bodyBytes);
                    // 디코딩된 데이터를 JSON으로 파싱
                    var jsonData = json.decode(utf8DecodedBody);
                    print("customer Data success");

                    bool purchaseConfirmation2 = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('배송정보'),
                          content: Text('${jsonData["streetAddress"]}\n${jsonData["detailAddress"]}\n로 배송 하시겠습니까?'),
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
                    if(purchaseConfirmation2 ==true){
                      ReceiptModel RM = new ReceiptModel();
                      RM.customerEmail = context.read<UserProvider>().getCurrentUser();
                      RM.status = 0; // 배송상태 설정

                      final response = await http.post(
                        Uri.parse('http://3.25.202.52:8080/api/receipt'),
                        // 적절한 엔드포인트를 사용하세요.
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(RM.toJson()),
                      );

                      if (response.statusCode == 201) {
                        //cart에 동일 data가 없어서 해당 data가 cart에 post 된 경우
                        print('Receipt post Success for purchase!');
                        var utf8DecodedBody = utf8.decode(response.bodyBytes);
                        // 디코딩된 데이터를 JSON으로 파싱
                        var jsonData = json.decode(utf8DecodedBody);

                        for(var i =0; i<CCM.length;i++){
                          ReceiptDetailModel RDM = new ReceiptDetailModel();
                          RDM.receiptId = jsonData["receiptId"];
                          RDM.detailId = CCM[i].getDetailId;
                          RDM.quantity = CCM[i].getQuantity;
                          RDM.status = 0;

                          final response2 = await http.post(
                            Uri.parse('http://3.25.202.52:8080/api/receipt_detail'),
                            // 적절한 엔드포인트를 사용하세요.
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(RDM.toJson()),
                          );

                          if(response2.statusCode == 201){
                            // detail 까지 post완료했으므로, 개인 정보에서 확인 가능
                            print("${i} index Receipt Detail post success for purchase");
                            print("customer purchase");


                            final response3 = await http.delete(Uri.parse('http://3.25.202.52:8080/api/cart/${context.read<UserProvider>().getCurrentUser()}/${CCM[i].getDetailId}'));
                            if(response3.statusCode == 200){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Create dialog content
                                  return AlertDialog(
                                    title: Text("구매 완료"),
                                    content: Text("구매가 완료되었습니다."),
                                  );
                                },
                              );

                              // Close dialog after 3 seconds
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a1, a2) => MyApp(),
                                      transitionsBuilder: (context, a1, a2, child) =>
                                          FadeTransition(opacity: a1, child: child),
                                      transitionDuration: Duration(milliseconds: 500),
                                    )); // Close dialog
                              });

                              print("delete cart data success");
                            }else{
                              print("delete cart data fail");
                            }




                          }else{

                            print("${i} index Receipt Detail post fail for purchase");

                          }

                        }





                      } else {
                        print('Receipt post fail for purchase!');
                      }


                    }
                    else{
                      print("customer cancel");
                    }
                  }
                  else{
                    print("customer Data fail");
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Column(
                  children: [
                    Text("결제하기",style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),


    );


  }
}