import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/sale_controller.dart';

class BlocOrder extends Bloc<EventOrder, StateOrder> {
  BlocOrder() : super(StateOrder());
  @override
  Stream<StateOrder> mapEventToState(EventOrder event) async* {
    switch (event.eventType) {
      case EventType.add:
        double totalDis = 0;
        double totalDisLine = 0;
        double total = 0;
        double subTotal = 0;
        double count = 0;
        double granTotal = 0;
        String cur = '';
        double qtys = 0;
        int masterId = 0;
        var value = await SaleController().readOrderDetail();
        dynamic local = await FlutterSession().get("localCurr");
        List<BaseQty> lsBaseQty = [];

        if (value.length != 0) {
          value.forEach(
            (element) {
              if (element.typeDis == "Percent") {
                element.total = ((element.qty * element.unitPrice) *
                    (1 - (element.discountRate / 100)));
                element.discountValue =
                    ((element.qty * element.unitPrice) * element.discountRate) /
                        100;
                if (local != null) {
                  element.totalSys = element.total * local;
                }

                totalDisLine += element.discountValue;
              } else {
                element.total =
                    ((element.qty * element.unitPrice) - element.discountRate);
                element.discountValue = element.discountRate;
                if (local != null) {
                  element.totalSys = element.total * local;
                }
                totalDisLine += element.discountValue * element.qty;
              }
              //set orderId
              masterId = element.masterId;
              //update detail
              SaleController().updateOrderDetail(element);
              subTotal += element.total;
              count += element.qty;
              cur = element.currency;
              var baseQty = new BaseQty(key: element.lineId, qty: element.qty);
              lsBaseQty.add(baseQty);
            },
          );
          // update ordre
          var order = await SaleController().readOrderKey(masterId);
          if (order.length > 0) {
            if (order.first.typeDis == "Percent") {
              order.first.discountValue =
                  ((subTotal) * order.first.discountRate) / 100;
            } else {
              order.first.discountValue = order.first.discountRate;
            }
            order.first.subTotal = subTotal;
            order.first.grandTotal =
                subTotal - order.first.taxValue - order.first.discountValue;
            if (local != null) {
              order.first.grandTotalSys = order.first.grandTotal * local;
              order.first.grandTotalDisplay = order.first.grandTotal * local;
            }

            granTotal = order.first.grandTotal;
            totalDis = order.first.discountValue;
            SaleController().updateOrder(order.first);
          }
          total = totalDisLine + totalDis;
          var data = value.firstWhere((element) => element.lineId == event.key,
              orElse: () => null);

          if (data != null) {
            if (event.itemMaster != null) {
              event.itemMaster.qty = data.qty;
            }
            qtys = data.qty;
          }
        }

        var addState = new StateOrder(
          key: event.key,
          qty: qtys,
          allQty: count,
          total: granTotal,
          currency: cur,
          subTotal: subTotal,
          disCount: total,
          baseQty: lsBaseQty,
          orderDetail: value,
        );
        yield addState;
        break;
      case EventType.delete:
        SaleController().deleteAllOrder();
        SaleController().deleteAllOrderDetail();
        var addState = new StateOrder(
          key: 0,
          qty: 0,
          allQty: 0,
          total: 0,
          currency: "",
          subTotal: 0,
          disCount: 0,
          baseQty: [],
          orderDetail: [],
        );
        yield addState;
        break;
      case EventType.update:
        break;
    }
  }
}
