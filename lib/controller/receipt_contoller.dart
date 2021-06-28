import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/modal/receip_detail.dart';
import 'package:point_of_sale/modal/receipts.dart';
import 'package:point_of_sale/modal/return_receipt_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class ReceiptController {
  static Future<List<Receipts>> eatchReceipt(int page, int index) async {
    var url = Config.receipt + "?page=$page" + "&index=$index";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var resList = json.decode(response.body) as List;
      List<Receipts> lsRe = [];
      resList.map((e) => lsRe.add(Receipts.fromJson(e))).toList();
      return lsRe;
    } else {
      return throw Exception('Failed to receipt');
    }
  }

  static Future<List<ReceiptDetail>> eatchReceiptDetail(int receiptId) async {
    var url = Config.receiptDetail + "?receiptid=$receiptId";
    var response = await http.get(url);
    var resList = json.decode(response.body) as List;
    List<ReceiptDetail> lsRe = [];
    resList.map((items) {
      return lsRe.add(ReceiptDetail.fromJson(items));
    }).toList();
    return lsRe;
  }

  static Future<List<Receipts>> eatchCancelReceipt(
      String dateFrom, String dateTo, int page, int index) async {
    dynamic branchId = FlutterSession().get("branchId");
    var url = Config.receipt +
        "?branchId=$branchId" +
        "&dateFrom=$dateFrom" +
        "&dateTo=$dateTo" +
        "&page=$page" +
        "&index=$index";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var resList = json.decode(response.body) as List;
      List<Receipts> lsRe = [];
      resList.map((e) => lsRe.add(Receipts.fromJson(e))).toList();
      return lsRe;
    } else {
      return throw Exception('Failed to receipt');
    }
  }

  static Future<List<ReturnReceipts>> eatchReturnReceipt(
      String dateFrom, String dateTo, int page, int index) async {
    dynamic branchId = FlutterSession().get("branchId");
    var url = Config.receipt +
        "?branchId=$branchId" +
        "&dateFrom=$dateFrom" +
        "&dateTo=$dateTo" +
        "&page=$page" +
        "&index=$index";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var resList = json.decode(response.body) as List;
      List<ReturnReceipts> lsRe = [];
      resList.map((e) => lsRe.add(ReturnReceipts.fromJson(e))).toList();
      return lsRe;
    } else {
      return throw Exception('Failed to receipt');
    }
  }
}
