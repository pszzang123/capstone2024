// CartModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

CartModel cartModelJson(String str) =>
    CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  var customerEmail;
  var detailId;
  var quantity;


  CartModel({
    this.customerEmail = '',
    this.detailId = '',
    this.quantity = ''
  });


  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    customerEmail: json["customerEmail"],
    detailId: json["detailId"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "customerEmail": customerEmail,
    "detailId": detailId,
    "quantity": quantity
  };

  String get getCustomerEmail => customerEmail;

  int get getDetailId => detailId;

  int get getQuantity => quantity;

}