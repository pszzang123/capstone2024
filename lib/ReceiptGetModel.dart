// AdditionalDetailModel.dart 생성 (데이터를 json 형식과 객체 형식으로 변환하는 파일)

import 'dart:convert';

ReceiptGetModel receiptGetModelJson(String str) =>
    ReceiptGetModel.fromJson(json.decode(str));

String receiptGetModelToJson(ReceiptGetModel data) => json.encode(data.toJson());

class ReceiptGetModel {
  var receiptId;
  var customerEmail;
  var status;
  var date;

  ReceiptGetModel({
    this.receiptId = 0,
    this.customerEmail = "",
    this.status = 0,
    this.date = "",
  });


  factory ReceiptGetModel.fromJson(Map<String, dynamic> json) => ReceiptGetModel(
    customerEmail: json["customerEmail"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "receiptId": receiptId,
    "customerEmail": customerEmail,
    "status": status,
    "date": date,
  };

  int get getReceiptId => receiptId;

  String get getCustomerEmail => customerEmail;

  int get getStatus => status;

  String get getDate => date;

}