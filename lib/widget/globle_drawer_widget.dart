import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/controller/favorite_controller.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/modal/order_modal.dart';
import 'package:point_of_sale/modal/post_server_modal.dart';
import 'package:point_of_sale/screen/contact_screen.dart';
import 'package:point_of_sale/screen/favorite_screen.dart';
import 'package:point_of_sale/screen/home_screen.dart';
import 'package:point_of_sale/screen/sale_group_screen.dart';
import 'package:point_of_sale/screen/setting_screen.dart';
import 'package:point_of_sale/screen/summary_sale_screen.dart';
import 'package:point_of_sale/screen/table_group_screen.dart';
import 'pos_list_tile_widget.dart';

class GlobleDrawerWidget extends StatefulWidget {
  const GlobleDrawerWidget({
    Key key,
  }) : super(key: key);

  @override
  _GlobleDrawerWidgetState createState() => _GlobleDrawerWidgetState();
}

class _GlobleDrawerWidgetState extends State<GlobleDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  "Kernel Computer",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                accountEmail: Text(
                  "Kernel@gmail.com",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://www.liveblogspot.com/wp-content/uploads/2020/03/POS-System.jpg",
                  ),
                  backgroundColor: Colors.lightGreen,
                ),
                otherAccountsPictures: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  Icon(
                    Icons.thumb_up,
                  )
                ],
              ),
            ),
            PosListTile(
              leading: Icons.home,
              title: "Home",
              subTitle: "home screen",
              trailing: Icons.arrow_forward_ios,
              action: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
            ),
            PosListTile(
              leading: Icons.monetization_on_outlined,
              title: "Sale",
              subTitle: "More sale",
              trailing: Icons.arrow_forward_ios,
              action: () async {
                dynamic systemType = await FlutterSession().get("systemType");
                if (systemType == "krms") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TableGroupScreen(),
                    ),
                    (route) => false,
                  );
                } else if (systemType == "kbms") {
                  var checkOrder = await SaleController().readOrderDetail();
                  if (checkOrder.length > 0) {
                    SaleController().deleteAllOrder();
                    SaleController().deleteAllOrderDetail();
                  }
                  var getOrder = await SaleController.getOrderServer(0);
                  //has order on table
                  if (getOrder.length > 0) {
                    buildOrder(getOrder[0]);
                  } // no order on  table

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SaleGroupScreen(type: "G1", lsPost: getOrder),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
            PosListTile(
              leading: Icons.history,
              title: "Summary Receipt",
              subTitle: "more summary receipt",
              trailing: Icons.arrow_forward_ios,
              action: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SummarySale()),
                    (route) => false);
              },
            ),
            // PosListTile(
            //   leading: Icons.info,
            //   title: "About",
            //   subTitle: "more about us",
            //   trailing: Icons.arrow_forward_ios,
            //   action: () async {
            //     Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(builder: (context) => AboutScreen()),
            //         (route) => false);
            //   },
            // ),
            PosListTile(
              leading: Icons.phone,
              title: "Contact Us",
              subTitle: "get in touch",
              trailing: Icons.arrow_forward_ios,
              action: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            PosListTile(
              leading: Icons.favorite,
              title: "Favorite",
              subTitle: "more favorite",
              trailing: Icons.arrow_forward_ios,
              action: () async {
                FavoriteController.read().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteScreen(lsFavorite: value),
                    ),
                    (route) => false,
                  );
                });
              },
            ),
            PosListTile(
              leading: Icons.settings,
              title: "Setting",
              subTitle: "more setting",
              trailing: Icons.arrow_forward_ios,
              action: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SettingScreen()),
                    (route) => false);
              },
            ),
            // PosListTile(
            //   leading: Icons.sync,
            //   title: "Print",
            //   subTitle: "upload data to local",
            //   trailing: Icons.arrow_forward_ios,
            //   action: () async {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => PrintHome(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
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
          uomName: x.uomName,
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
    });
  }
}
