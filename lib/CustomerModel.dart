// CustomerModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

CustomerModel customerModelJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  String email;
  String password;
  String name;
  String phone;
  String streetAddress;
  String detailAddress;
  String zipCode;

  CustomerModel({this.email = '', this.password = '', this.name = '', this.phone = '', this.streetAddress = '', this.detailAddress = '', this.zipCode = ''});

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
      email: json["email"], password: json["password"], name: json["name"], phone: json["phone"], streetAddress: json["streetAddress"], detailAddress : json["detailAddress"], zipCode : json["zipCode"]);

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "name": name,
    "phone": phone,
    "streetAddress" : streetAddress,
    "detailAddress" : detailAddress,
    "zipCode" : zipCode,
  };

  String get getEmail => email;

  String get getPassword => password;

  String get getName => name;

  String get getPhone => phone;

  String get getStreetAddress => streetAddress;

  String get getDetailAddress => detailAddress;

  String get getZipCode => zipCode;
}
