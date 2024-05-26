// AdditionalDetailModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

ReceiptDetailGetModel receiptDetailGetModelJson(String str) =>
    ReceiptDetailGetModel.fromJson(json.decode(str));

String receiptDetailModelToJson(ReceiptDetailGetModel data) => json.encode(data.toJson());

class ReceiptDetailGetModel {
  var customerEmail;
  var clothesId;
  var name;
  var color;
  var size;
  var price;
  var imageUrl;
  var quantity;
  var status;

  ReceiptDetailGetModel({
    this.customerEmail = "",
    this.clothesId = 0,
    this.name = "",
    this.color = "",
    this.size = "",
    this.price = 0,
    this.imageUrl = "",
    this.quantity = 0,
    this.status = 0,
  });


  factory ReceiptDetailGetModel.fromJson(Map<String, dynamic> json) => ReceiptDetailGetModel(
    customerEmail: json["customerEmail"],
    clothesId: json["clothesId"],
    name: json["name"],
    color: json["color"],
    size: json["size"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    quantity: json["quantity"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "customerEmail" : customerEmail,
    "clothesId": clothesId,
    "name": name,
    "color": color,
    "size": size,
    "price": price,
    "imageUrl": imageUrl,
    "quantity": quantity,
    "status": status,
  };

  String get getCustomerEmail => customerEmail;

  int get getClothesId => clothesId;

  String get getName => name;

  String get getColor => color;

  String get getSize => size;

  int get getPrice => price;

  String get getImageUrl => imageUrl;

  int get getQuantity => quantity;

  int get getStatus => status;

}