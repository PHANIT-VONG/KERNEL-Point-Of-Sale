import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';

class Group1Controller {
  Repository _repository;

  Group1Controller() {
    _repository = Repository();
  }

  static Future<List<GroupItem>> eachGroup1() async {
    var response = await http.get(Config.group1Url);
    if (response.statusCode == 200) {
      var responseGroup1List = json.decode(response.body) as List;
      List<GroupItem> tempGorup1 = [];
      responseGroup1List.map((gorup) {
        return tempGorup1.add(GroupItem.fromJson(gorup));
      }).toList();
      return tempGorup1;
    } else {
      return throw Exception('Failed to load group1');
    }
  }

  insertGroup1(GroupItem group1) async {
    return await _repository.insertGroup1("tbGroup1", group1.toMap());
  }

  updateGroup1(GroupItem item, int g1Id) async {
    return await _repository.updateGroup1("tbGroup1", item.toMap(), g1Id);
  }

  Future<List<GroupItem>> hasGroup1(int g1Id) async {
    var res = await _repository.hasGroup1("tbGroup1", g1Id) as List;
    List<GroupItem> tempGorup1 = [];
    res.map((gorup) {
      return tempGorup1.add(GroupItem.fromJson(gorup));
    }).toList();
    return tempGorup1;
  }

  Future<List<GroupItem>> getGroup1() async {
    var res = await _repository.getGorup1("tbGroup1") as List;
    List<GroupItem> tempGorup1 = [];
    res.map((gorup) {
      return tempGorup1.add(GroupItem.fromJson(gorup));
    }).toList();
    return tempGorup1;
  }
}
