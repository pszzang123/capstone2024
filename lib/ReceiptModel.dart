// AdditionalDetailModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

ReceiptModel receiptModelJson(String str) =>
    ReceiptModel.fromJson(json.decode(str));

String receiptModelToJson(ReceiptModel data) => json.encode(data.toJson());

class ReceiptModel {
  var customerEmail;
  var status;

  ReceiptModel({
    this.customerEmail = "",
    this.status = 0,
  });


  factory ReceiptModel.fromJson(Map<String, dynamic> json) => ReceiptModel(
    customerEmail: json["customerEmail"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "customerEmail": customerEmail,
    "status": status,
  };

  String get getCustomerEmail => customerEmail;

  int get getStatus => status;

}