import 'dart:convert';

import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class Group3Controller {
  Repository _repository;
  Group3Controller() {
    _repository = Repository();
  }
  static Future<List<GroupItem>> eachGroup3(int group1Id, int group2Id) async {
    var url = Config.group3Url + "?g1Id=$group1Id" + "&g2Id=$group2Id";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var responseGroup3List = json.decode(response.body) as List;
      List<GroupItem> tempGorup3 = [];
      responseGroup3List.map((gorup) {
        return tempGorup3.add(GroupItem.fromJson(gorup));
      }).toList();
      return tempGorup3;
    } else {
      return throw Exception('Failed to load group3');
    }
  }

  static Future<List<GroupItem>> eachGroup3Local() async {
    var url = Config.group3UrlLocal;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var responseGroup3List = json.decode(response.body) as List;
      List<GroupItem> tempGorup3 = [];
      responseGroup3List.map((gorup) {
        return tempGorup3.add(GroupItem.fromJson(gorup));
      }).toList();
      return tempGorup3;
    } else {
      return throw Exception('Failed to load group3');
    }
  }

  insertGroup3(GroupItem item) async {
    return await _repository.insertGroup3("tbGroup3", item.toMap());
  }

  updateGorup3(GroupItem item, int g3Id) async {
    return await _repository.updateGroup3("tbGroup3", item.toMap(), g3Id);
  }

  Future<List<GroupItem>> hasGroup3(int g3Id) async {
    var res = await _repository.hasGroup3("tbGroup3", g3Id) as List;
    List<GroupItem> tempGorup3 = [];
    res.map((gorup) {
      return tempGorup3.add(GroupItem.fromJson(gorup));
    }).toList();
    return tempGorup3;
  }

  Future<List<GroupItem>> getGroup3(int g1Id, int g2Id) async {
    var res = await _repository.getGorup3("tbGroup3", g1Id, g2Id) as List;
    List<GroupItem> tempGorup3 = [];
    res.map((gorup) {
      return tempGorup3.add(GroupItem.fromJson(gorup));
    }).toList();
    return tempGorup3;
  }
}
