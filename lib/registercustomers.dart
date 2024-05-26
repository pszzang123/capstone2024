// registercustomers.dart 생성 (데이터를 생성하는 파일)
// 해당 함수를 버튼에 넣어 작동하는 방식 등으로 사용

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CustomerModel.dart';

Future<CustomerModel?> registerCustomers(
    String email, String password, String name, String address, String phone, BuildContext context) async {
  var Url = "http://localhost:8080/customers";
  var response = await http.post(Uri.parse(Url),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
        "name": name,
        "address": address,
        "phone": phone,
      }));

  String responseString = response.body;
  if (response.statusCode == 200) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Backend Response'),
          content: Text('response.body'),
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
  return null;
}

