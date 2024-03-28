import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  ProductDetailPage(this.productId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSlider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '제품 이름',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '제품에 대한 설명이 들어갈 곳',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '20000원',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                      QuantityControl(), // 수량 증가/감소 위젯 추가
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 장바구니에 추가 로직
                    },
                    child: Text('장바구니에 담기'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // 바로 구매 로직
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                    ),
                    child: Text('즉시 구매'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300, // 이미지 크기 조정
          child: PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
            children: [
              Image.network(
                'https://via.placeholder.com/400',
                width: MediaQuery.of(context).size.width, // 이미지 폭을 화면 폭과 동일하게 설정
                fit: BoxFit.cover,
              ),
              Image.network(
                'https://via.placeholder.com/400',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Image.network(
                'https://via.placeholder.com/400',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CirclePageIndicator(
            itemCount: 3,
            currentPageNotifier: _currentPageNotifier,
          ),
        ),
      ],
    );
  }
}

class QuantityControl extends StatefulWidget {
  @override
  _QuantityControlState createState() => _QuantityControlState();
}

class _QuantityControlState extends State<QuantityControl> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '수량:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: _decrementQuantity,
        ),
        Text(
          '$_quantity',
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _incrementQuantity,
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProductDetailPage('product_id'),
  ));
}
