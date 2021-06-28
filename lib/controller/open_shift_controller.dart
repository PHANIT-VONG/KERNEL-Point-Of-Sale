import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/modal/open_shift_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class OpenShiftController {
  // check open shift
  static Future<List<OpenShift>> checkOpenShift() async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.urlCheckOpenShift + "?userId=$userId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var res = json.decode(response.body) as List;
      List<OpenShift> lsOpen = [];
      res.map((items) {
        return lsOpen.add(OpenShift.fromJson(items));
      }).toList();
      return lsOpen;
    } else {
      return throw Exception('Failed to check open shift');
    }
  }

  //  post open shift
  Future<List<OpenShift>> postOpenShift(PostOpenShift shift) async {
    final String apiUrl = Config.urlPostOpenShift;

    final response = await http.post(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(shift.toJson()));
    List<OpenShift> result = [];
    if (response.statusCode == 200) {
      if (response.body != null) {
        var res = json.decode(response.body) as List;
        res.map((e) {
          return result.add(OpenShift.fromJson(e));
        }).toList();
        return result;
      } else {
        return result;
      }
    } else {
      return result;
    }
  }
}
