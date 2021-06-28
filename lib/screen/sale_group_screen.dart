import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/controller/gorup1_controller.dart';
import 'package:point_of_sale/controller/group2_controller.dart';
import 'package:point_of_sale/controller/group3_controller.dart';
import 'package:point_of_sale/controller/item_controller.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:point_of_sale/modal/item_modal.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/modal/order_modal.dart';
import 'package:point_of_sale/modal/post_server_modal.dart';
import 'package:point_of_sale/screen/home_screen.dart';
import 'package:point_of_sale/screen/table_group_screen.dart';
import 'package:point_of_sale/widget/build_item_widget.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';
import 'package:point_of_sale/widget/sale_gorup_tab_bar_widget.dart';

import 'detail_sale_group_screen.dart';

// ignore: must_be_immutable
class SaleGroupScreen extends StatefulWidget {
  List<Post> lsPost = [];
  final String type;
  final int g1Id;
  final int g2Id;
  final int tableId;
  SaleGroupScreen({this.type, this.g1Id, this.g2Id, this.tableId, this.lsPost});
  @override
  _SaleGroupScreenState createState() => _SaleGroupScreenState();
}

class _SaleGroupScreenState extends State<SaleGroupScreen> {
  List<GroupItem> lsGroupItem = [];
  String nowtype;
  String loadScreen = "";
  bool hasInternet = false;
  int countReceipt = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getGroupItem();
    checkInternet();
    if (widget.lsPost.length > 0) {
      countOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: lsGroupItem.length,
      initialIndex: 0,
      child: Scaffold(
        drawer: GlobleDrawerWidget(),
        appBar: AppBar(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    _settingModalBottomSheet(context);
                  },
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.receipt, size: 26),
                        onPressed: () {
                          _settingModalBottomSheet(context);
                        },
                      ),
                      Positioned(
                        top: 2,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          width: 20,
                          height: 20,
                          child: Center(
                            child: Text(
                              "$countReceipt",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 26,
                  ),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: DataSearch(
                        tableId: widget.tableId,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TableGroupScreen(),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
          centerTitle: true,
          title: Text(
            "Sale",
            style: GoogleFonts.mcLaren(
              textStyle: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.only(right: 40),
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: lsGroupItem.map(
              (group1) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Tab(
                    child: Text(
                      group1.name,
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            : TabBarView(
                children: lsGroupItem.map(
                  (group1) {
                    return SaleGroupTabBarWidget(group1, nowtype, hasInternet,
                        lsPost: widget.lsPost, tableId: widget.tableId);
                  },
                ).toList(),
              ),
        bottomNavigationBar: BlocBuilder<BlocOrder, StateOrder>(
          builder: (_, state) {
            if (state.qty == null) {
              return Container(
                child: Text(""),
              );
            } else {
              return state.allQty != 0
                  ? Container(
                      width: double.infinity,
                      color: Color.fromRGBO(230, 230, 230, 1),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${state.currency}  ${state.total.toStringAsFixed(2)}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailSaleGroup(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 45,
                                width: 200,
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreen,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        height: 28,
                                        width: 30,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            "${state.allQty.floor()}",
                                            style: GoogleFonts.laila(
                                              textStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                    Text(
                                      "View Cart",
                                      style: GoogleFonts.laila(
                                        textStyle: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: Text(""),
                    );
            }
          },
        ),
      ),
    );
  }

  void getGroupItem() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    if (widget.type == "G1") {
      bool result = await DataConnectionChecker().hasConnection;
      if (result) {
        Group1Controller.eachGroup1().then(
          (values) {
            setState(() {
              lsGroupItem = values;
              nowtype = "G1";
              loading = false;
            });
          },
        );
      } else {
        Group1Controller().getGroup1().then(
          (values) {
            setState(() {
              lsGroupItem = values;
              nowtype = "G1";
              loading = false;
            });
          },
        );
      }
    } else if (widget.type == "G2") {
      bool result = await DataConnectionChecker().hasConnection;
      if (result) {
        Group2Controller.eachGroup2(widget.g1Id).then(
          (values) {
            setState(() {
              lsGroupItem = values;
              nowtype = "G2";
              loading = false;
            });
          },
        );
      } else {
        Group2Controller().getGroup2(widget.g1Id).then(
          (values) {
            setState(() {
              lsGroupItem = values;
              nowtype = "G2";
              loading = false;
            });
          },
        );
      }
    } else if (widget.type == "G3") {
      bool result = await DataConnectionChecker().hasConnection;
      if (result) {
        Group3Controller.eachGroup3(widget.g1Id, widget.g2Id).then(
          (values) {
            setState(() {
              lsGroupItem = values;
              nowtype = "G3";
              loading = false;
            });
          },
        );
      } else {
        Group3Controller().getGroup3(widget.g1Id, widget.g2Id).then(
          (values) {
            setState(() {
              lsGroupItem = values;
              nowtype = "G3";
              loading = false;
            });
          },
        );
      }
    }
  }

  void checkInternet() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      setState(() {
        hasInternet = true;
      });
    } else {
      setState(() {
        hasInternet = false;
      });
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.only(top: 30),
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
                  height: 40,
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
                          "List Ordered",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      BlocProvider.of<BlocOrder>(context).add(
                        EventOrder.delete(),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(76, 175, 80, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 28, color: Colors.white),
                          Text(
                            "New Order",
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new ListView(
                    children: widget.lsPost.map(
                      (e) {
                        return ListTile(
                          leading: Icon(Icons.receipt_long),
                          title: Text(
                            e.orderNo,
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('dd/MM/yyyy')
                                    .format(e.dateIn)
                                    .toString() +
                                " " +
                                e.timeIn,
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          onTap: () {
                            buildOrder(e);
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void countOrder() {
    setState(() {
      countReceipt = widget.lsPost.length;
    });
  }

  void buildOrder(Post p) async {
    await SaleController().deleteAllOrder();
    await SaleController().deleteAllOrderDetail();
    var key = 0;
    Order order = new Order(
      orderId: p.orderId,
      orderNo: p.orderNo,
      tableId: p.tableId,
      receiptNo: p.receiptNo,
      queueNo: p.queueNo,
      dateIn: p.dateIn,
      dateOut: p.dateOut,
      timeIn: p.timeIn,
      timeOut: p.timeOut,
      waiterId: p.waiterId,
      userOrderId: p.userOrderId,
      userDiscountId: p.userDiscountId,
      customerId: p.customerId,
      customerCount: p.customerCount,
      priceListId: p.priceListId,
      localCurrencyId: p.localCurrencyId,
      sysCurrencyId: p.sysCurrencyId,
      exchangeRate: p.exchangeRate,
      warehouseId: p.warehouseId,
      branchId: p.branchId,
      companyId: p.companyId,
      subTotal: p.subTotal,
      discountRate: p.discountRate,
      discountValue: p.discountValue,
      typeDis: p.typeDis,
      taxRate: p.taxRate,
      taxValue: p.taxValue,
      grandTotal: p.grandTotal,
      grandTotalSys: p.grandTotalSys,
      tip: p.tip,
      received: p.received,
      change: p.change,
      currencyDisplay: p.currencyDisplay,
      displayRate: p.displayRate,
      grandTotalDisplay: p.grandTotalDisplay,
      changeDisplay: p.changeDisplay,
      paymentMeansId: p.paymentMeansId,
      checkBill: p.checkBill,
      cancel: p.cancel,
      delete: p.delete,
      paymentType: p.paymentType,
      receivedType: p.receivedType,
      credit: p.credit,
    );
    key = await SaleController().saveOrder(order);
    p.detail.forEach((x) {
      OrderDetail detail = new OrderDetail(
          masterId: key,
          orderDetailId: x.orderDetailId,
          orderId: x.orderId,
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
          show: 0);
      SaleController().saveOrderDetail(detail);
      BlocProvider.of<BlocOrder>(context).add(EventOrder.add(key: x.lineId));
    });
    Navigator.pop(context);
  }
}

class DataSearch extends SearchDelegate<String> {
  int tableId;
  DataSearch({this.tableId});
  List<ItemMaster> ls = [];
  List<ItemMaster> items = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "true");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == "") {
      if (items.length != 0) {
        return BuildItem(
          item: items.first,
          tableId: tableId,
        );
      }
      return Text("");
    } else {
      if (items.length > 0) {
        return BuildItem(item: items.first, tableId: tableId);
      }
      return Text("");
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ItemController.searchItem(query).then((value) {
      ls = [];
      ls.addAll(value);
    });
    return ls.isEmpty
        ? Center(
            child: Text(
              'No Results Found...',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          )
        : ListView(
            children: ls.map(
              (e) {
                return ListTile(
                  onTap: () {
                    showResults(context);
                    items = [];
                    items.add(e);
                  },
                  title: Text(
                    "${e.itemName}",
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "${e.itemCode}",
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          );
  }
}
