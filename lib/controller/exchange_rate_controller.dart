import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/modal/exchange_rate_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class ExchangeRateController {
  static Future<ExchangRate> eachExchange() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.urlExchange + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      ExchangRate ex = ExchangRate.fromJson(res);
      return ex;
    } else {
      return throw Exception('Failed to exchange');
    }
  }
}
