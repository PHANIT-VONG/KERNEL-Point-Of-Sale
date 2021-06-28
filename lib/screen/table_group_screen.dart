import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/controller/table_group_controller.dart';
import 'package:point_of_sale/modal/group_table_modal.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/modal/order_modal.dart';
import 'package:point_of_sale/modal/post_server_modal.dart';
import 'package:point_of_sale/modal/table_modal.dart';
import 'package:point_of_sale/screen/sale_group_screen.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class TableGroupScreen extends StatefulWidget {
  @override
  _TableGroupScreenState createState() => _TableGroupScreenState();
}

class _TableGroupScreenState extends State<TableGroupScreen> {
  var image = 2;
  GroupTable group =
      new GroupTable(branchId: -1, name: "All", groupId: -1, image: "");
  List<GroupTable> groupTable = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getGroupTable();
  }

  void getGroupTable() async {
    await Future.delayed(Duration(seconds: 1));
    groupTable.add(group);
    GroupTableController.eachGroupTable().then((value) {
      if (mounted) {
        setState(() {
          groupTable.addAll(value);
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: groupTable.length,
      initialIndex: 0,
      child: Scaffold(
        drawer: GlobleDrawerWidget(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Table Group",
            style: GoogleFonts.laila(
              textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                size: 28,
              ),
              onPressed: () {
                showSearch(context: context, delegate: SearchTable());
              },
            )
          ],
          bottom: TabBar(
            labelPadding: EdgeInsets.only(right: 40),
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: groupTable.map((g) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Tab(
                  child: Text(
                    g.name,
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
            }).toList(),
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
                children: groupTable.map((e) {
                  return BiudTable(group: e);
                }).toList(),
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BiudTable extends StatefulWidget {
  GroupTable group;
  BiudTable({this.group});

  @override
  _BiudTableState createState() => _BiudTableState();
}

class _BiudTableState extends State<BiudTable> {
  List<TableOrder> table = [];
  @override
  void initState() {
    super.initState();
    getTable();
  }

  void getTable() {
    if (widget.group.groupId == -1 && widget.group.name == 'All') {
      TableController.eachTable(-1, 'All').then((value) {
        if (mounted) {
          setState(() {
            table = value;
          });
        }
      });
    } else {
      TableController.eachTable(widget.group.groupId, 'Also').then(
        (value) {
          if (mounted) {
            setState(() {
              table = value;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return merageTable(table: table);
  }
}

// ignore: camel_case_types
class merageTable extends StatelessWidget {
  const merageTable({
    Key key,
    @required this.table,
  }) : super(key: key);

  final List<TableOrder> table;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: table.map(
        (e) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () async {
                  var checkOrder = await SaleController().readOrderDetail();
                  if (checkOrder.length > 0) {
                    SaleController().deleteAllOrder();
                    SaleController().deleteAllOrderDetail();
                  }
                  var getOrder = await SaleController.getOrderServer(e.tableId);

                  //has order on table
                  if (getOrder.length > 0) {
                    buildOrder(getOrder[0]);
                  } // no order on  table
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaleGroupScreen(
                        type: "G1",
                        tableId: e.tableId,
                        lsPost: getOrder,
                      ),
                    ),
                  );
                },
                child: Card(
                  shadowColor: Colors.grey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: e.image != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      "${Config.image + "/Images/table/" + e.image}",
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: new CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "images/no_image.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        color: e.status == "A"
                            ? Colors.grey[300]
                            : e.status == "B"
                                ? Colors.red
                                : e.status == "P"
                                    ? Color.fromRGBO(76, 175, 80, 1)
                                    : Colors.grey[300],
                        child: Center(
                          child: Text(
                            "${e.name}",
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  void buildOrder(Post p) async {
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
        credit: p.credit);
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
        uomName: x.uomName,
        itemStatus: x.itemStatus,
        itemPrintTo: x.itemPrintTo,
        currency: x.currency,
        comment: x.comment,
        itemType: x.itemType,
        description: x.description,
        parentLevel: x.parentLevel,
        image: x.image,
        show: 0,
      );
      SaleController().saveOrderDetail(detail);
    });
  }
}

class SearchTable extends SearchDelegate<String> {
  List<TableOrder> ls = [];
  List<TableOrder> tables = [];

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
      if (tables.length != 0) {
        return merageTable(table: tables);
      }
      return Text("");
    } else {
      return merageTable(table: tables);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    TableController.searchTable(query).then((value) {
      ls = [];
      ls.addAll(value);
    });
    return ls.isEmpty
        ? Center(
            child: Text(
              'No Results Found...',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        : ListView(
            children: ls.map(
              (e) {
                return ListTile(
                  onTap: () {
                    showResults(context);
                    tables = [];
                    tables.add(e);
                  },
                  title: Text(
                    "${e.name}",
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ).toList(),
          );
  }
}
