import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/modal/system_type.dart';
import 'package:point_of_sale/widget/config.dart';

class SystemTypeController {
  static Future<List<SystemType>> eachSystenType() async {
    var url = Config.urlSystemType;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var sysList = json.decode(response.body) as List;
      List<SystemType> item = [];
      sysList.map((items) {
        return item.add(SystemType.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load price list');
    }
  }
}
