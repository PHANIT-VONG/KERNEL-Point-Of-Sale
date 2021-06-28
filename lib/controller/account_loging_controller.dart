import 'dart:convert';
import 'package:point_of_sale/modal/account_loging.dart';
import 'package:point_of_sale/modal/return_from_server_login.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class LoginController {
  Future<ReturnFromServerLogin> login(AccountLogin account) async {
    final String apiLogin = Config.urlLogin;
    final response = await http.post(
      apiLogin,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(account.toJson()),
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      ReturnFromServerLogin resault = ReturnFromServerLogin.fromJson(res);
      return resault;
    } else {
      return null;
    }
  }
}
