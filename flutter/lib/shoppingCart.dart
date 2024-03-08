import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class shoppingCart extends StatefulWidget {
  const shoppingCart({Key? key});

  @override
  State<shoppingCart> createState() => _shoppingCartState();
}
class DataModel with ChangeNotifier {
  String _data = '';
  Dio _dio = Dio();

  String get data => _data;

  Future<void> fetchData() async {
    try {
      Response response = await _dio.get('https://localhost:8080/api/data');
      if (response.statusCode == 200) {
        _data = response.data['data'];
        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data from Backend'),
      ),
      body: Center(
        child: Consumer<DataModel>(
          builder: (context, dataModel, _) {
            if (dataModel.data.isEmpty) {
              return CircularProgressIndicator();
            }
            return Text(dataModel.data);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<DataModel>(context, listen: false).fetchData();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _shoppingCartState extends State<shoppingCart> {
  List<Product> cartItems = []; // 장바구니 상품 목록

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        // 상품 사진
                        backgroundImage: NetworkImage(cartItems[index].image),
                      ),
                      title: Text(cartItems[index].name),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (cartItems[index].quantity > 1) {
                                  cartItems[index].quantity--;
                                }
                              });
                            },
                          ),
                          Text('${cartItems[index].quantity}'), // 수량 표시
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                cartItems[index].quantity++;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                cartItems.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      trailing: Text(
                          '${cartItems[index].price.toStringAsFixed(0)}원'), // 가격 표시 (원 단위)
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('총 결제금액: ${calculateTotalPrice()}원'), // 총 결제금액 표시 (원 단위)
                ElevatedButton(
                  onPressed: () {
                    // 결제하기 버튼 클릭 시 동작
                    // 여기에서 결제 로직을 처리할 수 있습니다.
                  },
                  child: Text('결제하기'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 장바구니에 상품 추가 기능
          // 여기에서 데이터를 가져와서 장바구니에 추가할 수 있습니다.
          fetchDataAndAddToCart();
        },
        child: Icon(Icons.add),
      ),
    );
  }



  // 데이터 가져와서 장바구니에 추가하는 함수
  Future<void> fetchDataAndAddToCart() async {
    // 데이터를 가져오는 로직 (여기서는 간단한 시뮬레이션으로 대체)
    List<Product> newItems = await simulateFetchingData();
    setState(() {
      cartItems.addAll(newItems);
    });
  }

  // 시뮬레이션을 통해 임의의 상품 데이터를 가져오는 함수
  Future<List<Product>> simulateFetchingData() async {
    // 시간 지연을 통해 데이터를 가져온다고 가정
    await Future.delayed(Duration(seconds: 2));
    // 시뮬레이션을 위해 임의의 상품 데이터 생성
    return [
      Product(name: '상품 1', image: 'https://via.placeholder.com/150', price: 50000),
      Product(name: '상품 2', image: 'https://via.placeholder.com/150', price: 100000),
      Product(name: '상품 3', image: 'https://via.placeholder.com/150', price: 140000),
    ];
  }

  // 장바구니에 있는 상품들의 총 가격을 계산하는 함수
  String calculateTotalPrice() {
    int total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total.toString();
  }
}

// 장바구니에 담길 상품을 나타내는 클래스
class Product {
  final String name; // 상품 이름
  final String image; // 상품 이미지 URL
  final int price; // 상품 가격 (원 단위)
  int quantity; // 상품 수량

  Product({required this.name, required this.image, required this.price, this.quantity = 1});
}

void main() {
  runApp(MaterialApp(
    home: shoppingCart(),
  ));
}
