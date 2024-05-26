// CommentModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

CommentGetModel commentGetModelJson(String str) =>
    CommentGetModel.fromJson(json.decode(str));

String commentlGetModelToJson(CommentGetModel data) => json.encode(data.toJson());

class CommentGetModel {
  var customerEmail;
  var clothesId;
  var comment;
  var date;

  CommentGetModel({
    this.customerEmail = '',
    this.clothesId = 0,
    this.comment = '',
    this.date = '',
  });


  factory CommentGetModel.fromJson(Map<String, dynamic> json) => CommentGetModel(
    customerEmail: json["customerEmail"],
    clothesId: json["clothesId"],
    comment: json["comment"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "customerEmail": customerEmail,
    "clothesId": clothesId,
    "comment": comment,
    "date": date,
  };

  String get getCustomerEmail => customerEmail;

  int get getClothesId => clothesId;

  String get getComment => comment;

  String get getDate => date;


}