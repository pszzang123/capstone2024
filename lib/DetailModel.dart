// DetailModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

DetailModel detailModelJson(String str) =>
    DetailModel.fromJson(json.decode(str));

String detailModelToJson(DetailModel data) => json.encode(data.toJson());

class DetailModel {
  var clothesId;
  var name;
  var detail;
  var genderCategory;
  var majorCategoryId;
  var subCategoryId;
  var price; // int 타입으로 변경
  var sellerEmail;


  DetailModel({
    this.clothesId = '',
    this.name = '',
    this.detail = '',
    this.genderCategory = '',
    this.majorCategoryId = '',
    this.subCategoryId = '',
    this.price = '',
    this.sellerEmail = '',
  });


  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
      clothesId: json["clothesId"],
      name: json["name"],
      detail: json["detail"],
      genderCategory: json["genderCategory"],
      majorCategoryId: json["majorCategoryId"],
      subCategoryId: json["subCategoryId"],
      price: json["price"], // int 타입으로 파싱
      sellerEmail: json["sellerEmail"],
  );

  Map<String, dynamic> toJson() => {
    "clothesId": clothesId,
    "name": name,
    "detail": detail, // int로 직렬화
    "genderCategory": genderCategory,
    "majorCategoryId": majorCategoryId,
    "subCategoryId": subCategoryId,
    "price": price,
    "sellerEmail": sellerEmail,
  };

  int get getClothesId => clothesId;

  String get getName => name;

  String get getDetail => detail;

  int get getGenderCategory => genderCategory;

  int get getMajorCategoryId => majorCategoryId;

  int get getSubCategoryId => subCategoryId;

  int get getPrice => price;

  String get getSellerEmail => sellerEmail;

}