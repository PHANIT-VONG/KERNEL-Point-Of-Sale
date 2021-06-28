import 'dart:async';
import 'dart:ui';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/open_shift_controller.dart';
import 'package:point_of_sale/controller/permission_controller.dart';
import 'package:point_of_sale/controller/post_order_to_server.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/controller/table_group_controller.dart';
import 'package:point_of_sale/controller/void_order_controller.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/screen/combine_screen.dart';
import 'package:point_of_sale/screen/detail_by_item_screen.dart';
import 'package:point_of_sale/screen/discount_item.dart';
import 'package:point_of_sale/screen/discount_member_card_screen.dart';
import 'package:point_of_sale/screen/item_not_enough_stock_screen.dart';
import 'package:point_of_sale/screen/move_table_screen.dart';
import 'package:point_of_sale/screen/open_shift_screen.dart';
import 'package:point_of_sale/screen/payorder_screen.dart';
import 'package:point_of_sale/screen/sale_group_screen.dart';
import 'package:point_of_sale/screen/split_receipt.dart';
import 'package:point_of_sale/screen/table_group_screen.dart';

class DetailSaleGroup extends StatefulWidget {
  @override
  _DetailSaleGroupState createState() => _DetailSaleGroupState();
}

class _DetailSaleGroupState extends State<DetailSaleGroup> {
  SaleController _sale = new SaleController();
  List<OrderDetail> lsDetail = [];
  Timer _timer;
  double count = 0;
  final controller = ScrollController();
  List<ShowHied> lsShow = [];
  String systemType;
  @override
  void initState() {
    super.initState();
    bineShowHied();
    getItemOrder();
    getSystemType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, "T");
          },
        ),
        title: Text("Cart",
            style: GoogleFonts.mcLaren(textStyle: TextStyle(fontSize: 20))),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.more_vert, size: 30),
              onPressed: () {
                _settingModalBottomSheet(context);
              })
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: lsDetail.where((x) => x.qty > 0).map((e) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailByItem(lsDetail: e)))
                      .then((value) {
                    getItemOrder();
                  });
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                            child: Stack(
                          children: [
                            Container(
                              child: Text(
                                "${e.khmerName} ( ${e.uomName} )",
                                style: GoogleFonts.laila(
                                    textStyle: TextStyle(fontSize: 17)),
                                textAlign: TextAlign.start,
                              ),
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              height: 70,
                            ),
                            lsShow.firstWhere((s) => s.key == e.lineId).show ==
                                    1
                                ? Positioned(
                                    top: 15,
                                    right: 2,
                                    child: Container(
                                      width: 45,
                                      height: 40,
                                      color: Colors.white,
                                      child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                          padding: EdgeInsets.only(),
                                          color: Colors.white,
                                          onPressed: () async {
                                            var masterId =
                                                await _sale.readOrder();
                                            if (masterId.first.orderId == 0) {
                                              if (count.floor() == 1) {
                                                hasNotPermission(
                                                    "Cannot empty cart !");
                                              } else {
                                                BlocProvider.of<BlocOrder>(
                                                        context)
                                                    .add(EventOrder.add(
                                                        key: e.lineId));
                                                e.qty -= 1;
                                                e.printQty -= 1;
                                                _sale.updateOrderDetail(e);
                                              }
                                            } else {
                                              //check permission
                                              var per =
                                                  await PermissionController
                                                      .permissionDeleteItem();
                                              if (per == "true") {
                                                if (count.floor() == 1) {
                                                  hasNotPermission(
                                                      "Cannot empty cart !");
                                                } else {
                                                  BlocProvider.of<BlocOrder>(
                                                          context)
                                                      .add(EventOrder.add(
                                                          key: e.lineId));
                                                  e.qty -= 1;
                                                  e.printQty -= 1;
                                                  _sale.updateOrderDetail(e);
                                                  getItemOrder();
                                                }
                                              } else {
                                                hasNotPermission(
                                                    "You cannot delete item after save! Please confirm with admin.");
                                              }
                                            }

                                            if (_timer != null) {
                                              _timer.cancel();
                                            }
                                            _timer = new Timer(
                                                Duration(seconds: 2), () {
                                              if (mounted) {
                                                setState(() {
                                                  lsShow
                                                      .firstWhere((s) =>
                                                          s.key == e.lineId)
                                                      .show = 0;
                                                });
                                              }
                                            });
                                            getItemOrder();
                                          },
                                          child: new Icon(
                                            Icons.remove,
                                            size: 20,
                                            color: Colors.red,
                                          )),
                                    ))
                                : Text(""),
                            lsShow.firstWhere((s) => s.key == e.lineId).show ==
                                    1
                                ? Positioned(
                                    top: 15,
                                    right: 50,
                                    child: Container(
                                      width: 45,
                                      height: 40,
                                      color: Colors.white,
                                      child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                          padding: EdgeInsets.only(),
                                          color: Colors.white,
                                          onPressed: () async {
                                            var masterId =
                                                await _sale.readOrder();
                                            if (masterId.first.orderId == 0) {
                                              if (lsDetail.length == 1) {
                                                hasNotPermission(
                                                    "Cannot empty cart !");
                                              } else {
                                                e.qty = 0;
                                                e.printQty = 0;
                                                _sale.updateOrderDetail(e);
                                                BlocProvider.of<BlocOrder>(
                                                        context)
                                                    .add(EventOrder.add(
                                                        key: e.lineId));
                                                getItemOrder();
                                              }
                                            } else {
                                              //check permission
                                              var per =
                                                  await PermissionController
                                                      .permissionDeleteItem();
                                              if (per == 'true') {
                                                if (lsDetail.length == 1) {
                                                  hasNotPermission(
                                                      "Cannot empty cart !");
                                                } else {
                                                  e.qty = 0;
                                                  e.printQty = 0;
                                                  _sale.updateOrderDetail(e);
                                                  BlocProvider.of<BlocOrder>(
                                                          context)
                                                      .add(EventOrder.add(
                                                          key: e.lineId));
                                                  getItemOrder();
                                                }
                                              } else {
                                                hasNotPermission(
                                                    "You cannot delete item after save! Please confirm with admin.");
                                              }
                                            }
                                          },
                                          child: new Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red,
                                          )),
                                    ))
                                : Text(""),
                          ],
                        )),
                        Container(
                            width: 45,
                            height: 40,
                            color: Colors.white,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                padding: EdgeInsets.only(),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    for (var data in lsDetail) {
                                      if (data.lineId == e.lineId) {
                                        lsShow
                                            .firstWhere(
                                                (s) => s.key == data.lineId)
                                            .show = 1;
                                      } else {
                                        lsShow
                                            .firstWhere(
                                                (s) => s.key == data.lineId)
                                            .show = 0;
                                      }
                                    }
                                    if (_timer != null) {
                                      _timer.cancel();
                                    }
                                    _timer = Timer(Duration(seconds: 2), () {
                                      if (mounted) {
                                        setState(() {
                                          lsShow
                                              .firstWhere(
                                                  (s) => s.key == e.lineId)
                                              .show = 0;
                                        });
                                      }
                                    });
                                  });
                                },
                                child: BlocBuilder<BlocOrder, StateOrder>(
                                    builder: (_, state) {
                                  var baseQty = state.baseQty.firstWhere(
                                      (x) => x.key == e.lineId,
                                      orElse: () => null);
                                  return Text(
                                    "${baseQty != null ? baseQty.qty.floor() : 0}",
                                    style: GoogleFonts.laila(
                                        textStyle: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                  );
                                }))),
                        Container(
                            width: 140,
                            child: Stack(
                              children: [
                                Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerRight,
                                    height: 70,
                                    child: Column(
                                      children: [
                                        Text(
                                            "${e.currency} ${(e.unitPrice * e.qty).toStringAsFixed(2)}",
                                            style: GoogleFonts.laila(
                                                textStyle: TextStyle(
                                                    fontSize: 16,
                                                    decoration:
                                                        e.discountRate != 0
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none)),
                                            textAlign: TextAlign.end),
                                        e.discountRate != 0
                                            ? Text(
                                                "${e.currency}  ${e.typeDis == "Percent" ? ((e.unitPrice * e.qty) - (e.discountRate * e.qty * e.unitPrice) / 100).toStringAsFixed(2) : ((e.unitPrice * e.qty) - (e.discountRate * e.qty)).toStringAsFixed(2)}",
                                                style: GoogleFonts.laila(
                                                    textStyle: TextStyle(
                                                        fontSize: 16)),
                                                textAlign: TextAlign.end)
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(''),
                                              ),
                                      ],
                                      mainAxisAlignment: e.discountValue != 0
                                          ? MainAxisAlignment.spaceAround
                                          : MainAxisAlignment.end,
                                    )),
                                lsShow
                                            .firstWhere(
                                                (s) => s.key == e.lineId)
                                            .show ==
                                        1
                                    ? Positioned(
                                        top: 15,
                                        left: 2,
                                        child: Container(
                                          width: 45,
                                          height: 40,
                                          color: Colors.white,
                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                              ),
                                              padding: EdgeInsets.only(),
                                              color: Colors.white,
                                              onPressed: () {
                                                BlocProvider.of<BlocOrder>(
                                                        context)
                                                    .add(EventOrder.add(
                                                        key: e.lineId));
                                                e.qty += 1;
                                                e.printQty += 1;
                                                _sale.updateOrderDetail(e);
                                                getItemOrder();
                                                if (_timer != null) {
                                                  _timer.cancel();
                                                }
                                                _timer = Timer(
                                                    Duration(seconds: 2), () {
                                                  if (mounted) {
                                                    setState(() {
                                                      lsShow
                                                          .firstWhere((s) =>
                                                              s.key == e.lineId)
                                                          .show = 0;
                                                    });
                                                  }
                                                });
                                              },
                                              child: new Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.red,
                                              )),
                                        ))
                                    : Text(""),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Container(
            height: 50,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("SubTotal :",
                      style: GoogleFonts.laila(
                          textStyle: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w600))),
                  BlocBuilder<BlocOrder, StateOrder>(builder: (_, state) {
                    count = state.allQty;
                    return Text(
                        "${state.currency} ${state.subTotal.toStringAsFixed(2)}",
                        style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w600)));
                  })
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Discount :",
                      style: GoogleFonts.laila(
                          textStyle: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w600))),
                  BlocBuilder<BlocOrder, StateOrder>(builder: (_, state) {
                    return Text(
                        "${state.currency} ${state.disCount.toStringAsFixed(2)}",
                        style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w600)));
                  })
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
          width: double.infinity,
          height: 48,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 5),
                  child: Container(
                    height: 45,
                    color: Color.fromRGBO(230, 230, 230, 1),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Total",
                              style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          BlocBuilder<BlocOrder, StateOrder>(
                              builder: (_, state) {
                            return Text(
                              "${state.currency} ${state.total.toStringAsFixed(2)}",
                              style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)),
                              textAlign: TextAlign.center,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                  color: Colors.red,
                  width: 150,
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 6, top: 6, bottom: 6),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayOrder(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                          Text(
                            "CHECKOUT",
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  void getItemOrder() {
    _sale.readOrderDetail().then((value) {
      if (mounted) {
        setState(() {
          lsDetail = value;
        });
      }
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 232, 232, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(
                            "Functions",
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          new IconButton(
                            icon: Icon(Icons.close, size: 30),
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: new ListView(
                      children: <Widget>[
                        systemType == "krms"
                            ? new Card(
                                child: new ListTile(
                                    leading: new Icon(
                                      Icons.save,
                                      size: 25,
                                      color: Colors.black87,
                                    ),
                                    title: new Text(
                                      'Save Order',
                                      style: GoogleFonts.laila(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    onTap: () {
                                      showAlertDialog(context);
                                      saveOrder();
                                    }),
                              )
                            : Container(),
                        systemType == "krms"
                            ? new Card(
                                child: new ListTile(
                                    leading: new Icon(
                                      Icons.print,
                                      size: 25,
                                      color: Colors.black87,
                                    ),
                                    title: new Text(
                                      'Bill',
                                      style: GoogleFonts.laila(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    onTap: () {
                                      showAlertDialog(context);
                                      billOrder();
                                    }),
                              )
                            : Container(),
                        new Card(
                          child: new ListTile(
                              leading: new Icon(
                                Icons.brush_sharp,
                                size: 25,
                                color: Colors.black87,
                              ),
                              title: new Text(
                                'Void Order',
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              onTap: () async {
                                var permissVoidOrder =
                                    await PermissionController
                                        .permissionVoidOrder();
                                if (permissVoidOrder == "true") {
                                  voidOrder();
                                } else {
                                  hasNotPermission(
                                      "You cannot access to this function.");
                                }
                              }),
                        ),
                        systemType == "krms"
                            ? new Card(
                                child: new ListTile(
                                    leading: new Icon(
                                      Icons.compare_arrows_outlined,
                                      size: 25,
                                      color: Colors.black87,
                                    ),
                                    title: new Text(
                                      'Move Table',
                                      style: GoogleFonts.laila(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    onTap: () async {
                                      var check = await PermissionController
                                          .permissionMoveTable();
                                      if (check == "true") {
                                        var order = await _sale.readOrder();
                                        if (order.first.orderId != 0) {
                                          var getTableInfro =
                                              await TableController
                                                  .getTableInfo(
                                                      order.first.tableId);
                                          if (getTableInfro.length > 0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MoveTable(
                                                    table: getTableInfro.first),
                                              ),
                                            );
                                          }
                                        } else {
                                          hasNotPermission(
                                              "Can not move this table...!");
                                        }
                                      } else {
                                        hasNotPermission(
                                            "You cannot access to this function .");
                                      }
                                    }),
                              )
                            : Container(),
                        systemType == "krms"
                            ? new Card(
                                child: new ListTile(
                                    leading: new Icon(
                                      Icons.markunread_mailbox_outlined,
                                      size: 25,
                                      color: Colors.black87,
                                    ),
                                    title: new Text(
                                      'Combine Receipt',
                                      style: GoogleFonts.laila(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    onTap: () async {
                                      var check = await PermissionController
                                          .permissionCombineReceipt();
                                      if (check == "true") {
                                        var orders = await _sale.readOrder();
                                        if (orders.first.orderId != 0) {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CombineScreen(
                                                      order: orders.first),
                                            ),
                                          );
                                        } else {
                                          hasNotPermission(
                                              "Please send data before combine...!");
                                        }
                                      } else {
                                        hasNotPermission(
                                            "You cannot access to this function.");
                                      }
                                    }),
                              )
                            : Container(),
                        systemType == "krms"
                            ? new Card(
                                child: new ListTile(
                                    leading: new Icon(
                                      Icons.filter_none_sharp,
                                      size: 25,
                                      color: Colors.black87,
                                    ),
                                    title: new Text(
                                      'Split Receipt',
                                      style: GoogleFonts.laila(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    onTap: () async {
                                      var check = await PermissionController
                                          .permissionSplitReceipt();
                                      if (check == 'true') {
                                        var orders = await _sale.readOrder();
                                        if (orders.first.orderId != 0) {
                                          var detail =
                                              await _sale.readOrderDetail();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SplitReceiptScreen(
                                                detail: detail,
                                                orderNo: orders.first.orderNo,
                                              ),
                                            ),
                                          );
                                        } else {
                                          hasNotPermission(
                                              "Please send data before combine...!");
                                        }
                                      } else {
                                        hasNotPermission(
                                            "You cannot access to this function.");
                                      }
                                    }),
                              )
                            : Container(),
                        new Card(
                          child: new ListTile(
                              leading: new Icon(
                                Icons.people_alt_rounded,
                                size: 25,
                                color: Colors.black87,
                              ),
                              title: new Text(
                                'Discount Member Card',
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              onTap: () async {
                                var check = await PermissionController
                                    .permissionMemberCard();
                                if (check == 'true') {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DiscountMemberCard(),
                                    ),
                                  );
                                } else {
                                  hasNotPermission(
                                      "You cannot access to this function .");
                                }
                              }),
                        ),
                        new Card(
                          child: new ListTile(
                              leading: new Icon(
                                Icons.monetization_on_outlined,
                                size: 25,
                                color: Colors.black87,
                              ),
                              title: new Text(
                                'Discount Item',
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              onTap: () async {
                                var check = await PermissionController
                                    .permissionDiscountItem();
                                if (check == 'true') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DiscountItemScreen(),
                                    ),
                                  );
                                } else {
                                  hasNotPermission(
                                      "You cannot access to this function .");
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void saveOrder() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      var checkOpenShift = await OpenShiftController.checkOpenShift();
      if (checkOpenShift.length > 0) {
        var data = await PostOrder().beforPost("");
        await Future.delayed(Duration(seconds: 1));
        if (data.status == "T") {
          if (data.data.length > 0) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NotEnoughStockScreen(lsItemReturn: data.data),
              ),
            );
            // has stork
          } else {
            if (systemType == "krms") {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TableGroupScreen(),
                  ),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaleGroupScreen(type: "G1"),
                  ),
                  (route) => false);
            }
          }
        } else {
          Navigator.pop(context);
          messBackSaveOrder("${data.status}", data.status);
        }
      } else {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
        notOpenShift(
            "Please open shift before save order! Do you  want to set open shift ?");
      }
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
    }
  }

  void billOrder() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      var permisBill = await PermissionController.permissionBill();
      if (permisBill == "true") {
        var checkOpenShift = await OpenShiftController.checkOpenShift();
        if (checkOpenShift.length > 0) {
          var data = await PostOrder().beforPost("Bill");
          await Future.delayed(Duration(seconds: 1));
          if (data.status == "T") {
            if (data.data.length > 0) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotEnoughStockScreen(lsItemReturn: data.data),
                ),
              );
              // has stork
            } else {
              if (systemType == "krms") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => TableGroupScreen()),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaleGroupScreen(type: "G1"),
                    ),
                    (route) => false);
              }
            }
          } else {
            Navigator.pop(context);
            messBackSaveOrder("${data.status}", data.status);
          }
        } else {
          await Future.delayed(
            Duration(seconds: 1),
          );
          Navigator.pop(context);
          notOpenShift(
              "Please open shift before bill order! Do you  want to set open shift ?");
        }
      } else {
        hasNotPermission("You cannot access to this function.");
      }
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
    }
  }

  Future<void> voidOrder() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('System Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to void this order ?',
                    style: GoogleFonts.laila(
                        textStyle:
                            TextStyle(fontSize: 18, color: Colors.black))),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color.fromRGBO(75, 181, 69, 1),
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text('Yes',
                      style: GoogleFonts.laila(
                          textStyle:
                              TextStyle(fontSize: 15, color: Colors.white))),
                ],
              ),
              onPressed: () async {
                bool result = await DataConnectionChecker().hasConnection;
                if (result) {
                  showAlertDialog(context);
                  await Future.delayed(Duration(seconds: 1));
                  bool isTrue = false;
                  var order = await _sale.readOrder();
                  if (order.first.orderId == 0) {
                    _sale.deleteAllOrder();
                    _sale.deleteAllOrderDetail();
                    isTrue = true;
                  } else {
                    var checkVoid = await VoidOrderController.voidOrder(
                        order.first.orderId);
                    if (checkVoid == "N") {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      hasNotPermission(
                          "Please get authorization from administrator to cancel...!");
                    } else {
                      _sale.deleteAllOrder();
                      _sale.deleteAllOrderDetail();
                      isTrue = true;
                    }
                  }
                  if (isTrue) {
                    if (systemType == "krms") {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TableGroupScreen(),
                          ),
                          (route) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaleGroupScreen(type: "G1"),
                          ),
                          (route) => false);
                    }
                  }
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No Internet Connection !"),
                    ),
                  );
                }
              },
            ),
            SizedBox(width: 5),
            RaisedButton(
              color: Colors.red,
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'No',
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> notOpenShift(String mess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('System Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '$mess',
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color.fromRGBO(75, 181, 69, 1),
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Yes',
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                var per = await PermissionController.checkPermissionOpenShift();
                if (per == 'false') {
                  Navigator.of(context).pop();
                  hasNotPermission("You cannot access to this function.");
                } else {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenShiftScreen(),
                    ),
                  );
                }
              },
            ),
            SizedBox(width: 5),
            RaisedButton(
              color: Colors.red,
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'No',
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> hasNotPermission(String mess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('System Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '$mess',
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color.fromRGBO(75, 181, 69, 1),
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Ok',
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          width: 110.0,
          height: 92.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(
                  "Loading...",
                  style: GoogleFonts.laila(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> messBackSaveOrder(String mes, String status) async {
    dynamic sys = await FlutterSession().get('systemType');
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('System Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '$mes',
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color.fromRGBO(75, 181, 69, 1),
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Ok',
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void getSystemType() async {
    dynamic system = await FlutterSession().get("systemType");
    setState(() {
      systemType = system;
    });
  }

  void bineShowHied() async {
    var detail = await _sale.readOrderDetail();
    detail.forEach((e) {
      ShowHied sh = new ShowHied(show: 0, key: e.lineId);
      lsShow.add(sh);
    });
  }
}
