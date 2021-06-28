import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/controller/setting_controller.dart';
import 'package:point_of_sale/modal/local_currency.dart';
import 'package:point_of_sale/widget/config.dart';

class LocalCurrencyController {
  static Future<LocalCurrency> eachLocal(int userId) async {
    var setting = await SettingController().getSetting(userId);
    var url;
    if (setting.length > 0) {
      url = Config.urlLocalCurrency + "?curId=${setting.first.localCurrencyId}";
    }
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      LocalCurrency local = LocalCurrency.fromJson(data);
      return local;
    } else {
      return throw Exception('Failed to load local currency');
    }
  }
}
