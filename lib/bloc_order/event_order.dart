import 'package:point_of_sale/modal/item_modal.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';

enum EventType { add, delete, update }

class EventOrder {
  int key;
  EventType eventType;
  ItemMaster itemMaster;
  EventOrder.add({int key, ItemMaster item}) {
    this.eventType = EventType.add;
    this.itemMaster = item;
    this.key = key;
  }

  EventOrder.delete() {
    this.eventType = EventType.delete;
  }
  EventOrder.update() {
    this.eventType = EventType.update;
  }
}

class StateOrder {
  int key;
  double qty;
  double allQty;
  double total;
  String currency;
  double subTotal;
  double disCount;
  List<BaseQty> baseQty;
  List<OrderDetail> orderDetail;
  StateOrder({
    this.key,
    this.qty,
    this.allQty,
    this.total,
    this.currency,
    this.subTotal,
    this.disCount,
    this.baseQty,
    this.orderDetail,
  });
}

class BaseQty {
  int key;
  double qty;
  BaseQty({this.key, this.qty});
}
