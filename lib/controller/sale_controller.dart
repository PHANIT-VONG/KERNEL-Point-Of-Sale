import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/controller/display_currency_controller.dart';
import 'package:point_of_sale/modal/item_modal.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/modal/order_modal.dart';
import 'package:point_of_sale/modal/payment_means_modal.dart';
import 'package:point_of_sale/modal/post_server_modal.dart';
import 'package:point_of_sale/modal/setting_modal.dart';
import 'package:point_of_sale/modal/tax_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class SaleController {
  Repository _repository;
  SaleController() {
    _repository = Repository();
  }

  //get order
  static Future<List<Post>> getOrderServer(int tableId) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = Config.urlGetOrder + "?tableId=$tableId" + "&userId=$userId";
    List<Post> order = [];
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var resOrder = json.decode(response.body) as List;
      resOrder.map((items) {
        order.add(Post.fromJson(items));
      }).toList();
    }
    return order;
  }

  //new order
  newOrder(ItemMaster item, int tableId, List<PaymentMean> payment,
      List<Setting> setting, List<Tax> tax) async {
    var resDetail = await readOrderDetail();
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      var curDis = await DisplayCurrController.eachDisCurr();
      var detail = resDetail.firstWhere(
        (element) => element.lineId == item.key,
        orElse: () => null,
      );
      var responseOrder = await readOrder();
      if (detail == null) {
        var key = 0;
        var currentDate = DateTime.now();
        if (responseOrder.length <= 0) {
          Order order = new Order(
            orderId: 0,
            orderNo: "N/A",
            tableId: tableId,
            receiptNo: "N/A",
            queueNo: "1",
            dateIn: DateTime.now(),
            dateOut: DateTime.now(),
            timeIn: DateFormat('kk:mm:ss').format(currentDate).toString(),
            timeOut: DateFormat('kk:mm:ss').format(currentDate).toString(),
            waiterId: 1,
            userOrderId: 0,
            userDiscountId: 0,
            customerId: setting.length > 0 ? setting.first.customerId : 0,
            customerCount: 1,
            priceListId: setting.length > 0 ? setting.first.priceListId : 0,
            localCurrencyId:
                setting.length > 0 ? setting.first.localCurrencyId : 0,
            sysCurrencyId: setting.length > 0 ? setting.first.sysCurrencyId : 0,
            exchangeRate: setting.length > 0 ? setting.first.rateIn : 0,
            warehouseId: setting.length > 0 ? setting.first.warehouseId : 0,
            branchId: 0,
            companyId: setting.length > 0 ? setting.first.companyId : 0,
            subTotal: 0,
            discountRate: 0,
            discountValue: 0,
            typeDis: "Percent",
            taxRate: tax.length > 0 ? tax.first.rate : 0,
            taxValue: 0,
            grandTotal: 0,
            grandTotalSys: 0,
            tip: 0,
            received: 0,
            change: 0,
            currencyDisplay: curDis.length > 0 ? curDis.first.altCurr : "",
            displayRate: curDis.length > 0 ? curDis.first.rate : 0,
            grandTotalDisplay: 0,
            changeDisplay: 0,
            paymentMeansId: payment[0].id,
            checkBill: "N",
            cancel: 0,
            delete: 0,
            paymentType: "",
            receivedType: "",
            credit: 0,
            localSetRate: 0,
            plCurrencyId: 0,
            plRate: 0,
          );
          key = await saveOrder(order);
        }
        if (key == 0) {
          if (resDetail.length > 0) {
            key = resDetail.first.id;
          }
        }
        OrderDetail detail = new OrderDetail(
          masterId: key,
          orderDetailId: 0,
          orderId: 0,
          lineId: item.key,
          itemId: item.itemId,
          code: item.itemCode,
          khmerName: item.itemName,
          englishName: item.itemName,
          qty: 1,
          printQty: 1,
          unitPrice: item.unitPrice,
          cost: item.cost,
          discountRate: item.disRate,
          discountValue: item.disValue,
          typeDis: item.typeDis,
          total: 0,
          totalSys: 0,
          uomId: item.uomId,
          uomName: item.uom,
          itemStatus: "F",
          itemPrintTo: "",
          currency: item.currency,
          comment: "",
          itemType: item.itemType,
          description: "",
          parentLevel: "",
          image: item.image,
          show: 0,
        );
        saveOrderDetail(detail);
      } else {
        detail.qty += 1;
        detail.printQty += 1;
        updateOrderDetail(detail);
      }
    } else {
      // offline
    }
  }

  // save order
  saveOrder(Order order) async {
    return await _repository.insertOrder('tbOrder', order.toMap());
  }

  // save order detail
  saveOrderDetail(OrderDetail detail) async {
    return await _repository.insertOrderDetail('tbOrderDetail', detail.toMap());
  }

  // read order
  Future<List<Order>> readOrder() async {
    var res = await _repository.getOrder('tbOrder') as List;
    List<Order> list = [];
    res.map((item) {
      return list.add(Order.fromJson(item));
    }).toList();
    return list;
  }

  // read order
  Future<List<Order>> readOrderRaw() async {
    var res = await _repository.getOrderRaw() as List;
    List<Order> list = [];
    res.map((item) {
      return list.add(Order.fromJson(item));
    }).toList();
    return list;
  }

  Future<List<Order>> readOrderKey(int id) async {
    var res = await _repository.getOrderKey("tbOrder", id) as List;
    List<Order> list = [];
    res.map((item) {
      return list.add(Order.fromJson(item));
    }).toList();
    return list;
  }

  // read Order Detail
  Future<List<OrderDetail>> readOrderDetail() async {
    var res = await _repository.getOrderDetail('tbOrderDetail') as List;
    List<OrderDetail> list = [];
    res.map((item) {
      return list.add(OrderDetail.fromJson(item));
    }).toList();
    return list;
  }

  // update order
  updateOrder(Order order) {
    return _repository.updateOrder('tbOrder', order.toMap(), order.id);
  }

  // update order detail
  updateOrderDetail(OrderDetail detail) async {
    return await _repository.updateOrderDetail(
      'tbOrderDetail',
      detail.toMap(),
      detail.id,
    );
  }

  //delete all order
  deleteAllOrder() async {
    return await _repository.deleteAllOrder('tbOrder');
  }

// delete order
  deleteOrder(int id) async {
    return await _repository.deleteOrder('tbOrder', id);
  }

// delete all order detail
  deleteAllOrderDetail() async {
    return await _repository.deleteAllOrderDetail('tbOrderDetail');
  }

// delete order detail
  deleteOrderDetail(int id) async {
    return await _repository.deleteOrderDetail('tbOrderDetail', id);
  }
}
