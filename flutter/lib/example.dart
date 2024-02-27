import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './style.dart' as style;
import './Login.dart';
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

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (c) => Store1()),
    ChangeNotifierProvider(create: (c) => Store2()),
  ], child: MaterialApp(theme: style.theme, home: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var tabIndex=0;

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    var map = {'age': 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? '없는데요';

    print(jsonDecode(result)['age']);
  }

  var userContent;

  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0, myData);
    });
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    /*if(result.statusCode == 200){

    }else{

    }*/
    var result2 = jsonDecode(result.body);

    setState(() {
      data = result2;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveData();
    getData();
    initNotification(context);
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
            onPressed: (){}, ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Upload(
                          userImage: userImage,
                          setUserContent: setUserContent,
                          addMyData: addMyData)));
            },
            iconSize: 30,
          ),
        ],
      ),
      // body: [ MediaQuery.of(context).size.width > 600 ? HomeLarge() : Home(data: data, addData: addData), Shop()][tab],
      body: Column(
        children: [
          // 상단에 고정된 Container
          Container(
            height: 50.0,
            color: Colors.white,
            child: (
                Row(
                  mainAxisAlignment: MainAxisAlignment.start ,
                  children: [
                    TextButton(onPressed: (){}, child: Text('여성', style: TextStyle(color: Colors.black),)),
                    TextButton(onPressed: (){}, child: Text('남성', style: TextStyle(color: Colors.black),)),
                    TextButton(onPressed: (){}, child: Text('키즈', style: TextStyle(color: Colors.black),)),
                    TextButton(onPressed: (){}, child: Text('백&슈즈', style: TextStyle(color: Colors.black),)),
                  ],
                )

            ),
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
          // 선택된 탭의 내용
          Expanded(
            child: IndexedStack(
              index: tabIndex,
              children: [
                Home(data: data, addData: addData), // 첫 번째 탭
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

  getMore() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data[i]['image'].runtimeType == String
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i]['image']),
                GestureDetector(
                  child: Text(widget.data[i]['user']),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) => Profile(),
                          transitionsBuilder: (context, a1, a2, child) =>
                              FadeTransition(opacity: a1, child: child),
                          transitionDuration: Duration(milliseconds: 500),
                        ));
                  },
                ),
                Text('좋아요 ${widget.data[i]['likes']}'),
                Text(widget.data[i]['date']),
                Text(widget.data[i]['content'], style: TextStyle(
                    fontSize: fontSize1(context)
                ),),
              ],
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }
}

fontSize1(context){
  if(MediaQuery.of(context).size.width > 600){
    return 30;
  }else{
    return 16;
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

class ImageSlider extends StatefulWidget {
  final List<String> images;

  ImageSlider({required this.images});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // 이미지를 일정 시간 간격으로 자동으로 넘기기 위한 타이머 설정
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // 페이지 이동 애니메이션
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return Image.network(
          widget.images[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}