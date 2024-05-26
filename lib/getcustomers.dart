// getcustomers.dart 생성 (데이터를 불러오는 파일)
// 해당 함수를 만든 후 build() 내에서 필요할 때 호출
// 예제는 FutureBuilder의 future: getCustomers() 를 사용하여 호출함
import 'dart:convert';

import 'CustomerModel.dart';
import 'package:http/http.dart' as http;


Future<List<CustomerModel>> getCustomers() async {
  var data = await http.get(Uri.parse('http://localhost:8080/customers'));
  var jsonData = json.decode(data.body);

  List<CustomerModel> customers = [];
  for (var e in jsonData) {
    CustomerModel customer = new CustomerModel();
    customer.email = e["email"];
    customer.password = e["password"];
    customer.name = e["name"];
    customer.streetAddress = e["streetAddress"];
    customer.detailAddress = e["detailAddress"];
    customer.zipCode = e["zipCode"];
    customer.phone = e["phone"];
    customers.add(customer);
  }
  return customers;
}

Future<CustomerModel> addCustomer(CustomerModel customer) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/customers'), // 적절한 엔드포인트를 사용하세요.
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(customer.toJson()),
  );

  if (response.statusCode == 201) {
    // 만약 서버가 생성 요청을 성공적으로 처리했다면,
    // 새로운 고객 모델을 반환합니다.
    return CustomerModel.fromJson(jsonDecode(response.body));
  } else {
    // 요청이 실패했다면, 예외를 던집니다.
    throw Exception('Failed to add customer');
  }
}