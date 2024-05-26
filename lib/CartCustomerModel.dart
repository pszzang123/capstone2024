// CartModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

CartCustomerModel cartCustomerModelJson(String str) =>
    CartCustomerModel.fromJson(json.decode(str));

String cartCustomerModelToJson(CartCustomerModel data) => json.encode(data.toJson());

class CartCustomerModel {
  var customerEmail;
  var detailId;
  var name;
  var color;
  var size;
  var price;
  var imageUrl;
  var quantity;


  CartCustomerModel({
    this.customerEmail = '',
    this.detailId = '',
    this.name = '',
    this.color = '',
    this.size = '',
    this.price = '',
    this.imageUrl = '',
    this.quantity = '',
  });


  factory CartCustomerModel.fromJson(Map<String, dynamic> json) => CartCustomerModel(
    customerEmail: json["customerEmail"],
    detailId: json["detailId"],
    name: json["name"],
    color: json["color"],
    size: json["size"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "customerEmail": customerEmail,
    "detailId": detailId,
    "name": name,
    "color": color,
    "size": size,
    "price": price,
    "imageUrl": imageUrl,
    "quantity": quantity,
  };

  String get getCustomerEmail => customerEmail;

  int get getDetailId => detailId;

  String get getName => name;

  String get getColor => color;

  String get getSize => size;

  int get getPrice => price;

  String get getImageUrl => imageUrl;

  int get getQuantity => quantity;

}