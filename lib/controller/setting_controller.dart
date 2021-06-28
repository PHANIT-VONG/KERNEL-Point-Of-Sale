import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/modal/setting_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class SettingController {
  Repository _repository;
  SettingController() {
    _repository = Repository();
  }
  Future<List<Setting>> getSetting(dynamic userId) async {
    if (userId == 0) {
      userId = await FlutterSession().get("userId");
    }
    var url = Config.urlSetting + "?userId=$userId";
    var response = await http.get(url);
    List<Setting> lsSet = [];
    if (response.statusCode == 200) {
      var lsRespone = json.decode(response.body) as List;
      lsRespone.map((e) {
        return lsSet.add(Setting.fromJson(e));
      }).toList();
    }
    return lsSet;
  }

  Future<int> saveSetting(Setting setting) async {
    return await _repository.insertSetting('tbSetting', setting.toMap());
  }

  Future<int> updateSetting(Setting setting, int setId) async {
    return await _repository.updateSetting('tbSetting', setting.toMap(), setId);
  }

  Future<List<Setting>> hasSetting(int id) async {
    var res = await _repository.hasSetting("tbSetting", id) as List;
    List<Setting> list = [];
    res.map((item) {
      return list.add(Setting.fromJson(item));
    }).toList();
    return list;
  }

  Future<List<Setting>> readSetting() async {
    var res = await _repository.getSetting('tbSetting') as List;
    List<Setting> lsSet = [];
    res.map((e) {
      return lsSet.add(Setting.fromJson(e));
    }).toList();
    return lsSet;
  }

  deleteSetting() async {
    return await _repository.deleteSetting('tbSetting');
  }
}
