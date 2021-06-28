import 'dart:convert';

import 'package:point_of_sale/modal/receipt_information.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class ReceiptInformationController {
  Repository _repository;
  ReceiptInformationController() {
    _repository = Repository();
  }

  static Future<List<ReceiptInformation>> eatchRI() async {
    var url = Config.receiptInfo;
    var response = await http.get(url);
    var resList = json.decode(response.body) as List;
    List<ReceiptInformation> lsRe = [];
    resList.map((items) {
      return lsRe.add(ReceiptInformation.fromJson(items));
    }).toList();
    return lsRe;
  }

  insertReceipt(ReceiptInformation res) async {
    return await _repository.insertReceipt("tbReceipt", res.toMap());
  }

  updateReceipt(ReceiptInformation res, int id) async {
    return await _repository.updateReceipt("tbReceipt", res.toMap(), id);
  }

  Future<List<ReceiptInformation>> hasReceipt(int id) async {
    var res = await _repository.hasReceipt("tbReceipt", id) as List;
    List<ReceiptInformation> reList = [];
    res.map((e) {
      return reList.add(ReceiptInformation.fromJson(e));
    }).toList();
    return reList;
  }

  Future<List<ReceiptInformation>> getReceipt() async {
    var res = await _repository.getReceipt("tbReceipt") as List;
    List<ReceiptInformation> reList = [];
    res.map((e) {
      return reList.add(ReceiptInformation.fromJson(e));
    }).toList();
    return reList;
  }
}
