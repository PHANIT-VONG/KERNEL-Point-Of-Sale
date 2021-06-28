import 'dart:convert';
import 'package:point_of_sale/modal/price_list_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class PriceListController {
  static Future<List<PriceList>> eachPriceList() async {
    var url = Config.priceListUrl;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var priceList = json.decode(response.body) as List;
      List<PriceList> item = [];
      priceList.map(
        (items) {
          return item.add(PriceList.fromJson(items));
        },
      ).toList();
      return item;
    } else {
      return throw Exception('Failed to load price list');
    }
  }
}
