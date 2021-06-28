import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class PermissionController {
  // check permission open  shift
  static Future<String> checkPermissionOpenShift() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.urlCheckPerOpenShift + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission open shift');
    }
  }

  // check permission bill
  static Future<String> permissionBill() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisBill + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission bill');
    }
  }

  // check permission Pay
  static Future<String> permissionPay() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisPay + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission pay');
    }
  }

  // check permission void order
  static Future<String> permissionVoidOrder() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisVoidOrder + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission void order');
    }
  }

  // check permission move table
  static Future<String> permissionMoveTable() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisMoveTable + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission move table');
    }
  }

  // check permission combine receipt
  static Future<String> permissionCombineReceipt() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permiscombine + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission combine receipt');
    }
  }

  // check permission split receipt
  static Future<String> permissionSplitReceipt() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permissplit + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission split receipt');
    }
  }

  // check permission delete item
  static Future<String> permissionDeleteItem() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisDeleteItem + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission split receipt');
    }
  }

  // check permission member card
  static Future<String> permissionMemberCard() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisMemberCard + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission member card');
    }
  }

  // check permission return order
  static Future<String> permissionReturnOrder() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisReturnOrder + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission return order');
    }
  }

  // check permission cancel order
  static Future<String> permissionCancelOrder() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisCancelOrder + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission cancel order');
    }
  }

  // check permission discount item
  static Future<String> permissionDiscountItem() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.permisDiscountItem + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission discount item');
    }
  }
}
