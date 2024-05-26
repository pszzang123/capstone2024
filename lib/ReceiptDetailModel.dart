// AdditionalDetailModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

ReceiptDetailModel receiptDetailModelJson(String str) =>
    ReceiptDetailModel.fromJson(json.decode(str));

String receiptDetailModelToJson(ReceiptDetailModel data) => json.encode(data.toJson());

class ReceiptDetailModel {
  var receiptId;
  var detailId;
  var quantity;
  var status;

  ReceiptDetailModel({
    this.receiptId = 0,
    this.detailId = 0,
    this.quantity = 0,
    this.status = 0,
  });


  factory ReceiptDetailModel.fromJson(Map<String, dynamic> json) => ReceiptDetailModel(
    receiptId: json["receiptId"],
    detailId: json["detailId"],
    quantity: json["quantity"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "receiptId" : receiptId,
    "detailId": detailId,
    "quantity": quantity,
    "status": status,
  };

  int get getReceiptId => receiptId;

  int get getDetailId => detailId;

  int get getQuantity => quantity;

  int get getStatus => status;

}