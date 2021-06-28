import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:point_of_sale/modal/tax_modal.dart';
import 'package:point_of_sale/widget/config.dart';

class TaxController {
  static Future<List<Tax>> eachTax() async {
    var url = Config.urlTax;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var taxList = json.decode(response.body) as List;
      List<Tax> item = [];
      taxList.map((items) {
        return item.add(Tax.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load price list');
    }
  }
}
