import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/modal/combine_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class CombineReceiptController {
  static Future<List<CombineReceipt>> eachCombine(int orderId) async {
    dynamic branchId = await FlutterSession().get("branchId");
    var url =
        Config.getReceiptCombine + "?branchId=$branchId" + "&orderId=$orderId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var comList = json.decode(response.body) as List;
      List<CombineReceipt> item = [];
      comList.map((items) {
        return item.add(CombineReceipt.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load combine receipt');
    }
  }

  Future<String> postOrder(CombineReceipt receipt) async {
    final String apiUrl = Config.postCombineReceipt;
    final response = await http.post(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(receipt.toJson()));

    if (response.statusCode == 200) {
      var res = response.body;
      return res;
    } else {
      return null;
    }
  }
}
