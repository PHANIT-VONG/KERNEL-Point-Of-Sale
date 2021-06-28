import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/modal/branch_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class BranchController {
  static Future<List<Branch>> eachBranch() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      List<Branch> item = [];
      var url = Config.branchUrl;
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var branchList = json.decode(response.body) as List;
        branchList.map((items) {
          return item.add(Branch.fromJson(items));
        }).toList();
      } else {
        return throw Exception('Failed to load branch');
      }
      return item;
    } else {
      return throw Exception('No internet');
    }
  }
}
