// CommentModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

CommentModel commentModelJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentlModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  var customerEmail;
  var clothesId;
  var comment;

  CommentModel({
    this.customerEmail = '',
    this.clothesId = 0,
    this.comment = '',
  });


  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    customerEmail: json["customerEmail"],
    clothesId: json["clothesId"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "customerEmail": customerEmail,
    "clothesId": clothesId,
    "comment": comment,
  };

  String get getCustomerEmail => customerEmail;

  int get getClothesId => clothesId;

  String get getComment => comment;


}