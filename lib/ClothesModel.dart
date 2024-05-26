// ClothesMdoel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

ClothesModel clothesModelJson(String str) =>
    ClothesModel.fromJson(json.decode(str));

String clothesModelToJson(ClothesModel data) => json.encode(data.toJson());

class ClothesModel {
  var clothesId;
  var name;
  int price; // int 타입으로 변경
  var companyName;
  var imageUrl;

  ClothesModel({this.clothesId = '', this.name = '', this.price = 0, this.companyName = '', this.imageUrl = ''});

  factory ClothesModel.fromJson(Map<String, dynamic> json) => ClothesModel(
      clothesId: json["clothesId"],
      name: json["name"],
      price: json["price"], // int 타입으로 파싱
      companyName: json["companyName"],
      imageUrl: json["imageUrl"]);

  Map<String, dynamic> toJson() => {
    "clothesId": clothesId,
    "name": name,
    "price": price, // int로 직렬화
    "companyName": companyName,
    "imageUrl": imageUrl
  };

  int get getClothesId => clothesId;

  String get getName => name;

  int get getPrice => price; // int 반환 타입으로 변경

  String get getCompanyName => companyName;

  String get getImageUrl => imageUrl;

}