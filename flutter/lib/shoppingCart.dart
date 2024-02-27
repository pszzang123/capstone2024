import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class shoppingCart extends StatefulWidget {
  const shoppingCart({super.key});

  @override
  State<shoppingCart> createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('장바구니'),
        centerTitle: true,
        ),
      body: Column(
        children: [
          Text('장바구니입니다.')
        ],
      ),
    );
  }
}

// aa
// a
// a
// a
// a
// a

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataModel(),
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
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

void main() {
  runApp(MyApp());
}
