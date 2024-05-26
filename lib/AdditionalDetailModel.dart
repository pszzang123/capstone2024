// AdditionalDetailModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

AdditionalDetailModel additionalDetailModelJson(String str) =>
    AdditionalDetailModel.fromJson(json.decode(str));

String additionalDetailModelToJson(AdditionalDetailModel data) => json.encode(data.toJson());

class AdditionalDetailModel {
  int detailId;
  var color;
  var size;
  int remaining;
  int clothesId;

  AdditionalDetailModel({
    this.detailId = 0,
    this.color = '',
    this.size = '',
    this.remaining = 0,
    this.clothesId = 0,
  });


  factory AdditionalDetailModel.fromJson(Map<String, dynamic> json) => AdditionalDetailModel(
    detailId: json["detailId"],
    color: json["color"],
    size: json["size"],
    remaining: json["remaining"],
    clothesId: json["clothesId"],
  );

  Map<String, dynamic> toJson() => {
    "detailId": detailId,
    "color": color,
    "size": size,
    "remaining": remaining,
    "clothesId": clothesId,
  };

  int get getDetailId => detailId;

  String get getColor => color;

  String get getSize => size;

  int get getRemaining => remaining;

  int get getClothesId => clothesId;

}