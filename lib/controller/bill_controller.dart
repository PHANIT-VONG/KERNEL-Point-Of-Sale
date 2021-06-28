import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/modal/order_modal.dart';
import 'package:point_of_sale/repository/repositorys.dart';

class BillController {
  Repository _repository;

  BillController() {
    _repository = Repository();
  }

  insertBill(Order order) async {
    return await _repository.insertBill("tbBill", order.toMap());
  }

  insertBillDetail(OrderDetail detail) async {
    return await _repository.insertBillDetail("tbBillDetail", detail.toMap());
  }

  Future<List<Order>> getBill(int page, int index) async {
    var res = await _repository.getBill('tbBill') as List;
    List<Order> list = [];
    res.map((item) {
      return list.add(Order.fromJson(item));
    }).toList();

    int totalPage = list.length;
    totalPage = (totalPage / page).floor();
    List<Order> orderList = new List<Order>();
    if (list.length % page != 0) {
      totalPage += 1;
    }
    if (totalPage >= index) {
      orderList = list.skip((index - 1) * page).take(page).toList();
    }
    return orderList;
  }

  Future<List<Order>> getFirstBii(int orderId) async {
    var res = await _repository.getFirstBill("tbBill", orderId) as List;
    List<Order> lsOrder = [];
    res.map((item) {
      return lsOrder.add(Order.fromJson(item));
    }).toList();
    return lsOrder;
  }

  Future<List<OrderDetail>> getBillDetail(int orderId) async {
    var res = await _repository.getBillDetail('tbBillDetail', orderId) as List;
    List<OrderDetail> list = [];
    res.map((item) {
      return list.add(OrderDetail.fromJson(item));
    }).toList();
    return list;
  }

  Future<List<OrderDetail>> getFirstBillDetail() async {
    var res = await _repository.getFirstBillDetail("tbBillDetail") as List;
    List<OrderDetail> list = [];
    res.map((item) {
      return list.add(OrderDetail.fromJson(item));
    }).toList();
    return list;
  }

  updateBill(Order order, orderId) async {
    return await _repository.updateBill("tbBill", order, orderId);
  }

  updateBillDetail(OrderDetail detail, detailId) async {
    return await _repository.updateBillDetail("tbBillDetail", detail, detailId);
  }

  deleteBill() async {
    return await _repository.deleteBill("tbBill");
  }

  deleteBillDetail() async {
    return await _repository.deleteBillDetail("tbBillDetail");
  }

  newBill() async {
    SaleController().readOrder().then((order) async {
      var orderId = 0;
      Order orders = new Order(
          orderNo: order.first.orderNo,
          tableId: order.first.tableId,
          receiptNo: order.first.receiptNo,
          queueNo: order.first.queueNo,
          dateIn: order.first.dateIn,
          dateOut: order.first.dateOut,
          timeIn: order.first.timeIn,
          timeOut: order.first.timeOut,
          waiterId: order.first.waiterId,
          userOrderId: order.first.userOrderId,
          userDiscountId: order.first.userDiscountId,
          customerId: order.first.customerId,
          customerCount: order.first.customerCount,
          priceListId: order.first.priceListId,
          localCurrencyId: order.first.localCurrencyId,
          sysCurrencyId: order.first.sysCurrencyId,
          exchangeRate: order.first.exchangeRate,
          warehouseId: order.first.waiterId,
          branchId: order.first.branchId,
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
          credit: order.first.credit);

      orderId = await insertBill(orders);

      SaleController().readOrderDetail().then((details) async {
        details.forEach((x) async {
          OrderDetail detail = new OrderDetail(
              orderId: orderId,
              lineId: x.lineId,
              itemId: x.itemId,
              code: x.code,
              khmerName: x.khmerName,
              englishName: x.englishName,
              qty: x.qty,
              printQty: x.printQty,
              unitPrice: x.unitPrice,
              cost: x.cost,
              discountRate: x.discountRate,
              discountValue: x.discountValue,
              typeDis: x.typeDis,
              total: x.total,
              totalSys: x.totalSys,
              uomId: x.uomId,
              itemStatus: x.itemStatus,
              itemPrintTo: x.itemPrintTo,
              currency: x.currency,
              comment: x.comment,
              itemType: x.itemType,
              description: x.description,
              parentLevel: x.parentLevel,
              image: x.image,
              show: x.show);
          await insertBillDetail(detail);
        });
        SaleController().deleteAllOrder();
        SaleController().deleteAllOrderDetail();
      });
    });
  }
}
