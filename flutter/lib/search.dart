import 'package:flutter/material.dart';
import 'dart:async';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;

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
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        hintText: '브랜드, 상품, 프로필, 태그 등...',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: _showClearButton
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  // SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      // TODO: 검색 버튼 클릭 시 수행할 작업 추가
                      onSearch();
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.0), // 간격 추가

            // 검색 버튼

            SizedBox(height: 16.0), // 간격 추가

            // 인기 검색어 및 현재 시간 표시

            SizedBox(height: 8.0),
            FutureBuilder(
              future: getCurrentTime(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return Text(
                    '인기 검색어: ${snapshot.data}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
            SizedBox(
              height: 100,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(
                          '1 ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Container(
                            width: 100,
                            child: Text(generatePopularSearches(0))),
                        Container(
                            child: Text(
                          '6 ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Container(child: Text(generatePopularSearches(5))),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            '2 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            width: 100, child: Text(generatePopularSearches(1))),
                        Container(
                          child: Text(
                            '7 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(generatePopularSearches(6)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            '3 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Text(generatePopularSearches(2)),
                        ),
                        Container(
                          child: Text(
                            '8 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(generatePopularSearches(7)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            '4 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Text(generatePopularSearches(3)),
                        ),
                        Container(
                          child: Text(
                            '9 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(generatePopularSearches(8)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            '5',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            width: 100, child: Text(generatePopularSearches(4))),
                        Container(
                          child: Text(
                            '10',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(generatePopularSearches(9)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 검색 버튼 클릭 시 호출되는 함수
  void onSearch() {
    // TODO: 검색 기능 구현
    print('Searching... Query: ${_searchController.text}');
  }

  // 인기 검색어 생성
  String generatePopularSearches(index) {
    List<String> popularSearches = [
      '문스타',
      '덩크로우',
      '스페지알',
      '후드집업',
      '나이키 덩크',
      '뉴발',
      '레고',
      '어그',
      '마뗑킴',
      '이미스'
    ];
    return popularSearches[index];
  }

  // 현재 시간 가져오기
  Future<String> getCurrentTime() async {
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}';
  }
}
