import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class VoidOrderController {
  // check permission open  shift
  static Future<String> voidOrder(int orderId) async {
    var url = Config.voidOrder + "?orderId=$orderId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check void order');
    }
  }
}
