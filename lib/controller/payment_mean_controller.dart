import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:point_of_sale/modal/payment_means_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';

class PaymentMeanController {
  Repository _repository;
  PaymentMeanController() {
    _repository = Repository();
  }
  static Future<List<PaymentMean>> eachPayment() async {
    var url = Config.paymentMean;
    var response = await http.get(url);
    var resPayment = json.decode(response.body) as List;
    List<PaymentMean> pay = [];
    resPayment.map((pays) {
      return pay.add(PaymentMean.fromJson(pays));
    }).toList();
    return pay;
  }

  insertPayment(PaymentMean pay) async {
    return await _repository.insertPayment("tbPayment", pay.toMap());
  }

  updatePayment(PaymentMean pay, int id) async {
    return await _repository.updatePayment("tbPayment", pay.toMap(), id);
  }

  Future<List<PaymentMean>> hasPayment(int id) async {
    var res = await _repository.hasPayment("tbPayment", id) as List;
    List<PaymentMean> payList = [];
    res.map((e) {
      return payList.add(PaymentMean.fromJson(e));
    }).toList();
    return payList;
  }

  Future<List<PaymentMean>> getPayment() async {
    var res = await _repository.getPayment("tbPayment") as List;
    List<PaymentMean> payList = [];
    res.map((e) {
      return payList.add(PaymentMean.fromJson(e));
    }).toList();
    return payList;
  }
}
