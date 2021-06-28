import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/controller/gorup1_controller.dart';
import 'package:point_of_sale/controller/group2_controller.dart';
import 'package:point_of_sale/controller/group3_controller.dart';
import 'package:point_of_sale/controller/item_controller.dart';
import 'package:point_of_sale/controller/payment_mean_controller.dart';
import 'package:point_of_sale/controller/receipt_information_controller.dart';
import 'package:point_of_sale/controller/setting_controller.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool isLoadingItem = false;
  bool isLoadingGorup1 = false;
  bool isLoadingGroup2 = false;
  bool isLoadingGroup3 = false;
  bool isLoadingPayment = false;
  bool isLoadingReceipt = false;
  bool isLoadingSetting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: GlobleDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Synchronization",
            style: GoogleFonts.laila(
                textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await Future.delayed(Duration(seconds: 2));
        },
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Item Master Data",
                style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                "download item master data",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              trailing: isLoadingItem
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : RaisedButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingItem = true;
                        });
                        downloadItem();
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Item Category 1",
                style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                "download item category 1",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              trailing: isLoadingGorup1
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : RaisedButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingGorup1 = true;
                        });
                        downloadCategoey1();
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Item Category 2",
                style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                "download item category 2",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              trailing: isLoadingGroup2
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : RaisedButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingGroup2 = true;
                        });
                        downloadCategory2();
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Item Category 3",
                style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                "download item category 3",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              trailing: isLoadingGroup3
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : RaisedButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingGroup3 = true;
                        });
                        downloadCategory3();
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Payment Master Data",
                style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                "download payment master data",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              trailing: isLoadingPayment
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : RaisedButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingPayment = true;
                        });
                        downloadPaymentMaster();
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Receipt Master",
                style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                "download receipt master data",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              trailing: isLoadingReceipt
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : RaisedButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingReceipt = true;
                        });
                        downloadReceiptMaster();
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "System Setting",
                style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                "download setting master data",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              trailing: isLoadingReceipt
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : RaisedButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingSetting = true;
                        });
                        downloadSetting();
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  void downloadItem() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await ItemController.eachItemLocal().then((value) {
        value.forEach((e) async {
          var data = await ItemController().hasItem(e.key);
          if (data.length == 0) {
            ItemController().insertItem(e);
          } else {
            ItemController().update(e);
          }
        });
      });
      setState(() {
        isLoadingItem = false;
      });
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingItem = false;
      });
    }
  }

  void downloadCategoey1() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await Group1Controller.eachGroup1().then((value) {
        value.forEach((e) async {
          var has = await Group1Controller().hasGroup1(e.g1Id);
          if (has.length == 0) {
            Group1Controller().insertGroup1(e);
          } else {
            Group1Controller().updateGroup1(e, e.g1Id);
          }
        });
        setState(() {
          isLoadingGorup1 = false;
        });
      });
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingGorup1 = false;
      });
    }
  }

  void downloadCategory2() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await Group2Controller.eachGroup2Local().then((value) {
        value.forEach((e) async {
          var has = await Group2Controller().hasGroup2(e.g2Id);
          if (has.length == 0) {
            Group2Controller().insertGroup2(e);
          } else {
            Group2Controller().updateGroup2(e, e.g2Id);
          }
        });
        setState(() {
          isLoadingGroup2 = false;
        });
      });
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingGroup2 = false;
      });
    }
  }

  void downloadCategory3() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await Group3Controller.eachGroup3Local().then((value) {
        value.forEach((e) async {
          var has = await Group3Controller().hasGroup3(e.g3Id);
          if (has.length == 0) {
            Group3Controller().insertGroup3(e);
          } else {
            Group3Controller().updateGorup3(e, e.g3Id);
          }
        });
        setState(() {
          isLoadingGroup3 = false;
        });
      });
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingGroup3 = false;
      });
    }
  }

  void downloadPaymentMaster() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await PaymentMeanController.eachPayment().then((value) {
        value.forEach((e) async {
          var has = await PaymentMeanController().hasPayment(e.id);
          if (has.length == 0) {
            PaymentMeanController().insertPayment(e);
          } else {
            PaymentMeanController().updatePayment(e, e.id);
          }
        });
        setState(() {
          isLoadingPayment = false;
        });
      });
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingPayment = false;
      });
    }
  }

  void downloadReceiptMaster() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await ReceiptInformationController.eatchRI().then((value) {
        value.forEach((e) async {
          var has = await ReceiptInformationController().hasReceipt(e.id);
          if (has.length == 0) {
            ReceiptInformationController().insertReceipt(e);
          } else {
            ReceiptInformationController().updateReceipt(e, e.id);
          }
        });
        setState(() {
          isLoadingReceipt = false;
        });
      });
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingReceipt = false;
      });
    }
  }

  void downloadSetting() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await SettingController().getSetting(0).then((value) {
        value.forEach((e) async {
          var has = await SettingController().hasSetting(e.id);
          if (has.length == 0) {
            SettingController().saveSetting(e);
          } else {
            SettingController().updateSetting(e, e.id);
          }
        });
        setState(() {
          isLoadingSetting = false;
        });
      });
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingSetting = false;
      });
    }
  }
}
