// DetailImagesModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

DetailImagesModel detailImagesModelJson(String str) =>
    DetailImagesModel.fromJson(json.decode(str));

String detailImagesModelToJson(DetailImagesModel data) => json.encode(data.toJson());

class DetailImagesModel {
  var clothesId;
  var imageUrl;
  var order;


  DetailImagesModel({
    this.clothesId = '',
    this.imageUrl = '',
    this.order = ''
  });


  factory DetailImagesModel.fromJson(Map<String, dynamic> json) => DetailImagesModel(
      clothesId: json["clothesId"],
      imageUrl: json["imageUrl"],
      order: json["order"]
  );

  Map<String, dynamic> toJson() => {
    "clothesId": clothesId,
    "imageUrl": imageUrl,
    "order": order
  };

  int get getClothesId => clothesId;

  String get getImageUrl => imageUrl;

  int get getOrder => order;

}