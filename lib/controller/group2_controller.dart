import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';

class Group2Controller {
  Repository _repository;
  Group2Controller() {
    _repository = Repository();
  }
  static Future<List<GroupItem>> eachGroup2(int group1Id) async {
    var url = Config.group2Url + "?g1Id=$group1Id";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var responseGroup2List = json.decode(response.body) as List;
      List<GroupItem> tempGorup2 = [];
      responseGroup2List.map((gorup) {
        return tempGorup2.add(GroupItem.fromJson(gorup));
      }).toList();
      return tempGorup2;
    } else {
      return throw Exception('Failed to load group2');
    }
  }

  static Future<List<GroupItem>> eachGroup2Local() async {
    var url = Config.group2UrlLocal;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var responseGroup2List = json.decode(response.body) as List;
      List<GroupItem> tempGorup2 = [];
      responseGroup2List.map((gorup) {
        return tempGorup2.add(GroupItem.fromJson(gorup));
      }).toList();
      return tempGorup2;
    } else {
      return throw Exception('Failed to load group2');
    }
  }

  insertGroup2(GroupItem item) async {
    return await _repository.insertGroup2("tbGroup2", item.toMap());
  }

  updateGroup2(GroupItem item, int g2Id) async {
    return await _repository.updateGroup2("tbGroup2", item.toMap(), g2Id);
  }

  Future<List<GroupItem>> hasGroup2(int g2Id) async {
    var res = await _repository.hasGroup2("tbGroup2", g2Id) as List;
    List<GroupItem> tempGorup2 = [];
    res.map((gorup) {
      return tempGorup2.add(GroupItem.fromJson(gorup));
    }).toList();
    return tempGorup2;
  }

  Future<List<GroupItem>> getGroup2(int g1Id) async {
    var res = await _repository.getGorup2("tbGroup2", g1Id) as List;
    List<GroupItem> tempGorup2 = [];
    res.map((gorup) {
      return tempGorup2.add(GroupItem.fromJson(gorup));
    }).toList();
    return tempGorup2;
  }
}
