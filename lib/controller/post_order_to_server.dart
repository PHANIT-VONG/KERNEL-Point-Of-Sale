import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/modal/post_server_modal.dart';
import 'package:point_of_sale/modal/return_from_server_modal.dart';
import 'package:point_of_sale/widget/config.dart';

class PostOrder {
  Future<ReturnFromServer> postOrder(Post posts) async {
    final String apiUrl = Config.postOrder;
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        posts.toJson(),
      ),
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      ReturnFromServer result = new ReturnFromServer();
      result = ReturnFromServer.fromJson(res);
      return result;
    } else {
      return null;
    }
  }

  Future<ReturnFromServer> beforPost(String type) async {
    var order = await SaleController().readOrder();
    List<OrderDetail> detail = await SaleController().readOrderDetail();
    List<OrderDetail> lsDetail = [];
    dynamic userId = await FlutterSession().get("userId");
    dynamic branchId = await FlutterSession().get("branchId");
    detail.where((x) => x.qty > 0).forEach((e) {
      OrderDetail d = new OrderDetail(
        orderDetailId: e.orderDetailId,
        orderId: e.orderId,
        lineId: e.lineId,
        itemId: e.itemId,
        code: e.code,
        khmerName: e.khmerName,
        englishName: e.englishName,
        qty: e.qty,
        printQty: e.printQty,
        unitPrice: e.unitPrice,
        cost: e.cost,
        discountRate: e.discountRate,
        discountValue: e.discountValue,
        typeDis: e.typeDis,
        total: e.total,
        totalSys: e.totalSys,
        uomId: e.uomId,
        uomName: e.uomName,
        itemStatus: e.itemStatus,
        itemPrintTo: e.itemPrintTo,
        currency: e.currency,
        comment: e.comment,
        itemType: e.itemType,
        description: e.description,
        parentLevel: e.parentLevel,
        image: e.image,
        show: e.show,
      );
      lsDetail.add(d);
    });
    Post post = new Post(
      orderId: order.first.orderId,
      orderNo: order.first.orderNo,
      tableId: order.first.tableId,
      receiptNo: order.first.receiptNo,
      queueNo: order.first.queueNo,
      dateIn: order.first.dateIn,
      dateOut: order.first.dateOut,
      timeIn: order.first.timeIn,
      timeOut: order.first.timeOut,
      waiterId: order.first.waiterId,
      userOrderId: userId,
      userDiscountId: userId,
      customerId: order.first.customerId,
      customerCount: order.first.customerCount,
      priceListId: order.first.priceListId,
      localCurrencyId: order.first.localCurrencyId,
      sysCurrencyId: order.first.sysCurrencyId,
      exchangeRate: order.first.exchangeRate,
      warehouseId: order.first.warehouseId,
      branchId: branchId,
      companyId: order.first.companyId,
      subTotal: order.first.subTotal,
      discountRate: order.first.discountRate,
      discountValue: order.first.discountValue,
      typeDis: order.first.typeDis,
      taxRate: order.first.taxRate,
      taxValue: order.first.taxValue,
      grandTotal: order.first.grandTotal,
      grandTotalSys: order.first.grandTotalSys,
      tip: order.first.tip,
      received: order.first.received,
      change: order.first.change,
      currencyDisplay: order.first.currencyDisplay,
      displayRate: order.first.displayRate,
      grandTotalDisplay: order.first.grandTotalDisplay,
      changeDisplay: order.first.changeDisplay,
      paymentMeansId: order.first.paymentMeansId,
      checkBill: order.first.checkBill,
      cancel: order.first.cancel,
      delete: order.first.delete,
      paymentType: order.first.paymentType,
      receivedType: order.first.receivedType,
      credit: order.first.credit,
      localSetRate: 0,
      plCurrencyId: 0,
      plRate: 0,
      typePrinter: type,
      detail: lsDetail,
    );
    var datas = await PostOrder().postOrder(post);
    ReturnFromServer ret =
        new ReturnFromServer(data: datas.data, status: datas.status);
    return ret;
  }
}
