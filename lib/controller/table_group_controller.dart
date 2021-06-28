import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/modal/group_table_modal.dart';
import 'package:point_of_sale/modal/table_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class GroupTableController {
  static Future<List<GroupTable>> eachGroupTable() async {
    dynamic branch = await FlutterSession().get("branchId");
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      List<GroupTable> item = [];
      var url = Config.urlGroupTable + "?branchId=$branch";
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var groupList = json.decode(response.body) as List;
        groupList.map((items) {
          return item.add(GroupTable.fromJson(items));
        }).toList();
      } else {
        return throw Exception('Failed to load group table');
      }
      return item;
    } else {
      return throw Exception('No internet');
    }
  }
}

class TableController {
  static Future<List<TableOrder>> eachTable(int groupId, String type) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      dynamic branchId = await FlutterSession().get("branchId");
      List<TableOrder> item = [];
      var url = Config.urlTable +
          "?groupId=$groupId" +
          "&type=$type" +
          "&branchId=$branchId";
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var tableList = json.decode(response.body) as List;
        tableList.map((items) {
          return item.add(TableOrder.fromJson(items));
        }).toList();
      } else {
        return throw Exception('Failed to load table');
      }
      return item;
    } else {
      return throw Exception('No internet');
    }
  }

  static Future<List<TableOrder>> searchTable(String name) async {
    List<GroupTable> groupTable = [];
    List<TableOrder> item = [];
    groupTable = await GroupTableController.eachGroupTable();

    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      var url = Config.urlSearchTable;
      url = url + "?groupId=-1";
      groupTable.forEach((element) {
        url = url + "&groupId=${element.groupId}";
      });
      url = url + "&name=$name";
      var response = await http.get(url);
      var res = json.decode(response.body) as List;
      res.map((items) {
        return item.add(TableOrder.fromJson(items));
      }).toList();
    }
    return item;
  }

  static Future<List<TableOrder>> getTableInfo(int tableId) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      List<TableOrder> item = [];
      var url = Config.getTableInfo + "?tableId=$tableId";
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var tableList = json.decode(response.body) as List;
        tableList.map((items) {
          return item.add(TableOrder.fromJson(items));
        }).toList();
      } else {
        return throw Exception('Failed to load table');
      }
      return item;
    } else {
      return throw Exception('No internet');
    }
  }

  static Future<List<TableOrder>> getTableMove() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      List<TableOrder> item = [];
      dynamic branchId = await FlutterSession().get("branchId");
      var url = Config.getTableMove + "?branchId=$branchId";
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var tableList = json.decode(response.body) as List;
        tableList.map((items) {
          return item.add(TableOrder.fromJson(items));
        }).toList();
      } else {
        return throw Exception('Failed to load table');
      }
      return item;
    } else {
      return throw Exception('No internet');
    }
  }

  static Future<String> moveTable(int oldId, int newId) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      var url = Config.movTable + "?oldId=$oldId" + "&newId=$newId";
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return throw Exception('Failed to load table');
      }
    } else {
      return throw Exception('No internet');
    }
  }
}
