import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram/example.dart';
import 'package:instagram/search.dart';
import 'package:instagram/shoppingCart.dart';

final auth = FirebaseAuth.instance;

final firestore = FirebaseFirestore.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var firstAccess = true;

  signOut() async {
    await FirebaseAuth.instance.signOut();
    // 이후 로그아웃 후 처리할 작업을 추가할 수 있습니다.
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        // 로딩 중일 때의 화면을 반환합니다.
        return CircularProgressIndicator();
      }
      else{
        if (snapshot.hasData && snapshot.data!.uid != null){

          return Column(
            children: [
              SizedBox(
                height: 35,
              ),
              SizedBox(
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.account_circle,
                          size: MediaQuery.of(context).size.width / 4,
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: TextButton(
                              child: Text(
                                '로그아웃 >',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async{
                                await signOut();
                                firstAccess = false;

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a1, a2) =>
                                          Login(),
                                      transitionsBuilder:
                                          (context, a1, a2, child) =>
                                          FadeTransition(
                                              opacity: a1, child: child),
                                      transitionDuration:
                                      Duration(milliseconds: 100),
                                    ));
                              }),
                        ),
                        SizedBox(
                            height: 50,
                            child: Text('${auth.currentUser?.email}님 반갑습니다.')
                        ),
                        SizedBox(
                          height: 50,
                          child: Text('주문/혜택 등의 정보를 빠르게 확인할 수 있습니다.',
                              style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
            ],
          );
        }
        else{
          if(firstAccess){
            return Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.account_circle,
                            size: MediaQuery.of(context).size.width / 4,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextButton(
                                child: Text(
                                  '로그인 >',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, a1, a2) =>
                                            idAndPassword(),
                                        transitionsBuilder:
                                            (context, a1, a2, child) =>
                                            FadeTransition(
                                                opacity: a1, child: child),
                                        transitionDuration:
                                        Duration(milliseconds: 200),
                                      ));
                                }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/2,
                            height: 50,
                            child: Text('주문/혜택 등의 정보를 빠르게 확인할 수 있습니다.',
                                style: TextStyle(color: Colors.grey, fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  width: double.infinity, // 부모 위젯의 가로 길이만큼
                  height: 4, // Divider의 두께 설정
                  color: Colors.grey.shade300, // 회색 배경색 설정
                ),
              ],
            );
          }
          else{
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  '로그인',
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






            );
          }
        }
      }
    });


  }
}

class idAndPassword extends StatefulWidget {
  const idAndPassword({super.key});

  @override
  State<idAndPassword> createState() => _idAndPasswordState();
}

class _idAndPasswordState extends State<idAndPassword> {
  var id = '';
  var passWord = '';

  alreadyLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return auth.currentUser?.uid != null
        ? alreadyLogin()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                '로그인',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: SizedBox(
                    width: 200,
                    child: Text('로그인',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                        textAlign: TextAlign.start),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '아이디',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      id = value; // 사용자가 입력한 값을 id 변수에 저장
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    obscureText: true, // 비밀번호 입력 시 텍스트 감춤 설정
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      border: OutlineInputBorder(),
                    ),

                    onChanged: (value) {
                      passWord = value; // 사용자가 입력한 값을 id 변수에 저장
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          login();
                          // 로그인 버튼 클릭 시 실행될 로직 작성
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 50),
                          backgroundColor:
                              Colors.black, // 배경색을 검정으로 설정// 버튼의 높이와 너비 조절
                        ),
                        child: Text(
                          '로그인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a1, a2) =>
                                    registration(),
                                transitionsBuilder: (context, a1, a2, child) =>
                                    FadeTransition(opacity: a1, child: child),
                                transitionDuration: Duration(milliseconds: 200),
                              ));
                          // 회원가입 버튼 클릭 시 실행될 로직 작성
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 50),
                          backgroundColor:
                              Colors.white, // 배경색을 검정으로 설정// 버튼의 높이와 너비 조절
                        ),
                        child: Text(
                          '회원가입',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  bool isValidEmail(String email) {
    // 이메일 유효성 검사를 위한 정규표현식 사용
    // 여기서는 간단한 형태의 정규표현식을 사용하였습니다. 실제 프로덕션 환경에 맞게 수정해야 합니다.
    // 이메일 형식이 잘못된 경우 false를 반환합니다.
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  //로그인
  login() async {
    try {
      if (id.isEmpty || passWord.isEmpty) {
        throw '이메일과 비밀번호를 모두 입력해주세요.';
      }

      if (!isValidEmail(id)) {
        throw '올바른 이메일 주소를 입력해주세요.';
      }

      await auth.signInWithEmailAndPassword(
        email: id,
        password: passWord,
      );

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('로그인'),
            content: Text('로그인 되었습니다.'),
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
      // 2초 후에 화면 전환 수행
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('존재하지 않는 계정입니다.'),
            content: Text(e.toString()),
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
}

//회원가입
class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  var id = '';
  var passWord = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '회원가입',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: SizedBox(
                width: 200,
                child: Text('회원가입',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.start),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  id = value; // 사용자가 입력한 값을 id 변수에 저장
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                obscureText: true, // 비밀번호 입력 시 텍스트 감춤 설정
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),

                onChanged: (value) {
                  passWord = value; // 사용자가 입력한 값을 id 변수에 저장
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 로그인 버튼 클릭 시 실행될 로직 작성
                      firebaseRegistration();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                      backgroundColor:
                          Colors.black, // 배경색을 검정으로 설정// 버튼의 높이와 너비 조절
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ));
  }

  bool isValidEmail(String email) {
    // 이메일 유효성 검사를 위한 정규표현식 사용
    // 여기서는 간단한 형태의 정규표현식을 사용하였습니다. 실제 프로덕션 환경에 맞게 수정해야 합니다.
    // 이메일 형식이 잘못된 경우 false를 반환합니다.
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  firebaseRegistration() async {
    try {
      if (id.isEmpty || passWord.isEmpty) {
        throw '이메일과 비밀번호를 모두 입력해주세요.';
      }

      if (!isValidEmail(id)) {
        throw '올바른 이메일 주소를 입력해주세요.';
      }

      await auth.createUserWithEmailAndPassword(
        email: id,
        password: passWord,
      );
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원가입'),
            content: Text('회원가입이 완료되었습니다.'),
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
      // 2초 후에 화면 전환 수행
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$e 이미 존재하는 계정입니다.'),
            content: Text(e.toString()),
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

    print('4124');
  }
}

// Navigator.push(
// context,
// PageRouteBuilder(
// pageBuilder: (context, a1, a2) => idAndPassword(),
// transitionsBuilder: (context, a1, a2, child) =>
// FadeTransition(opacity: a1, child: child),
// transitionDuration: Duration(milliseconds: 200),
// ));
getData() async {
  // await firestore.collection('product').add({'name' : '바지', });
  await firestore.collection('product').get();

  // await auth.signOut(); 로그아웃

  try {
    await auth.signInWithEmailAndPassword(
      // var result = await auth.createUserWithEmailAndPassword(
      email: "kim@test.com",
      password: "123456",
    );
    // result.user?.updateDisplayName('john');
    // print(result.user);
    if (auth.currentUser?.uid == null) {
      print('로그인 안된 상태');
    } else {
      print('로그인 하셨네');
    }
  } catch (e) {
    print(e);
  }
}
