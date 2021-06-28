import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/controller/setting_controller.dart';
import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:point_of_sale/modal/item_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';

class ItemController {
  Repository _repository;
  ItemController() {
    _repository = Repository();
  }
  static Future<List<ItemMaster>> eachItem(
      GroupItem group, List<int> keys, int pageSize, int pageIndex) async {
    bool result = await DataConnectionChecker().hasConnection;
    var setting;
    if (!result) {
      setting = await SettingController().readSetting();
    } else {
      setting = await SettingController().getSetting(0);
    }
    var url = Config.itemUrl;
    url = url + "?plid=${setting.first.priceListId}";
    if (keys == null) {
      url = url +
          "&key=$keys" +
          "&g1id=${group.g1Id}" +
          "&g2id=${group.g2Id}" +
          "&g3id=${group.g3Id}" +
          "&type=item" +
          "&page=$pageSize" +
          "&index=$pageIndex";
    } else if (keys.length > 0) {
      keys.forEach((i) {
        url = url + "&key=$i";
      });
      url = url +
          "&g1id=0" +
          "&g2id=0" +
          "&g3id=0}" +
          "&type=item" +
          "&page=$pageSize" +
          "&index=$pageIndex";
    }
    var response = await http.get(url);
    var responseItemList = json.decode(response.body) as List;
    List<ItemMaster> item = [];
    responseItemList.map((items) {
      return item.add(ItemMaster.fromJson(items));
    }).toList();
    return item;
  }

  static Future<List<ItemMaster>> eachItemLocal() async {
    var url = Config.itemUrlLocal;
    var response = await http.get(url);
    var responseItemList = json.decode(response.body) as List;
    List<ItemMaster> item = [];
    responseItemList.map((items) {
      return item.add(ItemMaster.fromJson(items));
    }).toList();
    return item;
  }

  static Future<List<ItemMaster>> searchItem(String name) async {
    bool result = await DataConnectionChecker().hasConnection;
    var setting;
    if (!result) {
      setting = await SettingController().readSetting();
    } else {
      setting = await SettingController().getSetting(0);
    }
    var url = Config.searchItemUrl + "?plid=${setting.first.priceListId}";
    url = url + "&name=$name";
    var response = await http.get(url);
    var responseItemList = json.decode(response.body) as List;
    List<ItemMaster> item = [];
    responseItemList.map((items) {
      return item.add(ItemMaster.fromJson(items));
    }).toList();
    return item;
  }

  // get local stor

  insertItem(ItemMaster item) async {
    return await _repository.insertItem("tbItem", item.toMap());
  }

  update(ItemMaster item) async {
    return await _repository.updateItem("tbItem", item.toMap(), item.key);
  }

  Future<List<ItemMaster>> getItems(
      GroupItem group, int page, int index) async {
    bool result = await DataConnectionChecker().hasConnection;
    var settting;
    if (!result) {
      settting = await SettingController().readSetting();
    } else {
      settting = await SettingController().getSetting(0);
    }

    var res = await _repository.getitem(
        'tbItem', group, settting.first.priceListId) as List;
    List<ItemMaster> list = [];
    res.map((item) {
      return list.add(ItemMaster.fromJson(item));
    }).toList();
    int totalPage = list.length;
    totalPage = (totalPage / page).floor();
    List<ItemMaster> itemList = new List<ItemMaster>();
    if (list.length % page != 0) {
      totalPage += 1;
    }
    if (totalPage >= index) {
      itemList = list.skip((index - 1) * page).take(page).toList();
    }
    return itemList;
  }

  Future<List<ItemMaster>> hasItem(int key) async {
    var res = await _repository.hasitem("tbItem", key) as List;
    List<ItemMaster> list = [];
    res.map((item) {
      return list.add(ItemMaster.fromJson(item));
    }).toList();
    return list;
  }
}
