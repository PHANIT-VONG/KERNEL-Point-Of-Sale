import 'dart:ui';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/open_shift_controller.dart';
import 'package:point_of_sale/controller/payment_mean_controller.dart';
import 'package:point_of_sale/controller/permission_controller.dart';
import 'package:point_of_sale/controller/post_order_to_server.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/controller/setting_controller.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/modal/order_modal.dart';
import 'package:point_of_sale/modal/payment_means_modal.dart';
import 'package:point_of_sale/screen/open_shift_screen.dart';
import 'package:point_of_sale/screen/payment_success.dart';
import 'package:point_of_sale/screen/sale_group_screen.dart';
import 'package:point_of_sale/screen/table_group_screen.dart';
import 'package:point_of_sale/widget/connect_bluetooth.dart';
import 'package:point_of_sale/widget/print_receipt.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'item_not_enough_stock_screen.dart';

class PayOrder extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<PayOrder> {
  SaleController _sale = new SaleController();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  double cashValue = 0;
  double bankValue = 0;
  double total = 0;
  String currency = "";
  double credit = 0;
  List<OrderDetail> lsDetail = [];
  List<PaymentMean> lsPay = [];
  PrintReceipt prints;
  String pathImage;
  Order orderBill;
  bool _isCash = false;
  bool _isBank = false;
  int _isChecked = 0;
  String typeBank = "";
  bool isPost = true;

  List<OrderDetail> detailBill = [];
  @override
  void initState() {
    super.initState();
    prints = PrintReceipt();
    initSaveToPath();
    getPaymentMean();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CheckOut",
          style: GoogleFonts.laila(
            textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<BlocOrder, StateOrder>(
                  builder: (_, state) {
                    total = state.total;
                    currency = state.currency;
                    return Text(
                      "${state.currency} ${state.total.toStringAsFixed(2)}",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 26.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                Text(
                  "Total Amount due",
                  style: GoogleFonts.laila(
                    textStyle:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            //color: Colors.teal,
            width: double.infinity,
            height: 500,
            child: Column(
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.attach_money,
                        size: 28,
                      ),
                      title: Text(
                        "Cash",
                        style: GoogleFonts.laila(
                          textStyle: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      selected: _isCash,
                      trailing: CupertinoSwitch(
                        value: _isCash,
                        onChanged: (bool value) {
                          setState(() {
                            if (value == true) {
                              _isCash = value;
                              cashValue = total - bankValue;
                            } else {
                              cashValue = 0;
                              _isCash = value;
                            }
                          });
                        },
                      ),
                    ),
                    _isCash == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              width: double.infinity,
                              child: TextFormField(
                                style: TextStyle(fontSize: 18),
                                key: Key(cashValue.toStringAsFixed(2)),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(5)),
                                initialValue: cashValue.toStringAsFixed(2),
                                onChanged: (value) {
                                  if (value != "") {
                                    cashValue = double.parse(value);
                                  } else {
                                    cashValue = 0;
                                  }
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Bank Transfer",
                        style: GoogleFonts.laila(
                          textStyle: TextStyle(
                              fontSize: 19.0, fontWeight: FontWeight.w400),
                        ),
                      ),
                      leading: Icon(
                        Icons.account_balance_rounded,
                        size: 28,
                      ),
                      selected: _isBank,
                      trailing: CupertinoSwitch(
                        value: _isBank,
                        onChanged: (bool value) {
                          setState(() {
                            if (value == true) {
                              _isBank = value;
                              bankValue = total - cashValue;
                            } else {
                              _isBank = value;
                              bankValue = 0;
                            }
                          });
                        },
                      ),
                    ),
                    _isBank == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Column(
                                    children: lsPay.map(
                                      (e) {
                                        return ListTile(
                                          title: Text(
                                            '${e.type}',
                                            style: GoogleFonts.laila(
                                              textStyle: TextStyle(
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          trailing: Radio(
                                            value: lsPay.indexOf(e) + 1,
                                            groupValue: _isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                _isChecked = value;
                                                typeBank = e.type;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 20),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 18),
                                      key: Key(bankValue.toStringAsFixed(2)),
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(5)),
                                      initialValue:
                                          bankValue.toStringAsFixed(2),
                                      onChanged: (value) {
                                        if (value != "") {
                                          bankValue = double.parse(value);
                                        } else {
                                          bankValue = 0;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          height: 50,
          child: RaisedButton(
            splashColor: Colors.green,
            color: Colors.red,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  "CONFIRM ORDER",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onPressed: () async {
              if (_isCash == false && _isBank == false) {
                dialoadOK("Payment empty! Please select payment method.");
              } else if (_isCash == true && _isBank == false) {
                if (cashValue < total) {
                  dialoadOK("Insufficient payment​​​ !");
                } else {
                  await _sale.readOrder().then((value) {
                    value.first.paymentType = "Cash";
                    value.first.receivedType = cashValue.toStringAsFixed(2);
                    value.first.received = cashValue;
                    if (cashValue > total) {
                      value.first.change = cashValue - total;
                    }
                    _sale.updateOrder(value.first);
                  });
                  confirmOrder();
                }
              } else if (_isCash == false && _isBank == true) {
                if (typeBank == "") {
                  dialoadOK("Please select your bank!");
                } else {
                  if (bankValue < total) {
                    dialoadOK("Insufficient payment​​​ !");
                  } else {
                    await _sale.readOrder().then((value) {
                      value.first.paymentType = typeBank;
                      value.first.receivedType = bankValue.toStringAsFixed(2);
                      value.first.paymentMeansId = _isChecked;
                      value.first.received = bankValue;
                      if (bankValue > total) {
                        value.first.change = bankValue - total;
                      }
                      _sale.updateOrder(value.first);
                    });
                    confirmOrder();
                  }
                }
              } else if (_isCash == true && _isBank == true) {
                var sum = cashValue + bankValue;
                if (typeBank == "") {
                  dialoadOK("Please select your bank!");
                } else {
                  if (sum < total) {
                    dialoadOK("Insufficient payment​​​ !");
                  } else {
                    await _sale.readOrder().then((value) {
                      value.first.paymentType = "Cash" + ',' + typeBank;
                      value.first.receivedType = cashValue.toStringAsFixed(2) +
                          ',' +
                          bankValue.toStringAsFixed(2);
                      value.first.paymentMeansId = _isChecked;
                      value.first.received = cashValue + bankValue;
                      if ((bankValue + cashValue) > total) {
                        value.first.change = (bankValue + cashValue) - total;
                      }
                      _sale.updateOrder(value.first);
                    });
                    confirmOrder();
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }

  initSaveToPath() async {
    final filename = 'logo.png';
    var bytes = await rootBundle.load("images/logo.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  void getPaymentMean() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      PaymentMeanController.eachPayment().then((value) {
        if (mounted) {
          setState(() {
            lsPay = value;
          });
        }
      });
    } else {
      PaymentMeanController().getPayment().then((value) {
        if (mounted) {
          setState(() {
            lsPay = value;
          });
        }
      });
    }
  }

  Future<void> dialoadOK(des) async {
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
                  '$des',
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
                    'OK',
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _sale.readOrder().then((value) {
                  value.first.credit = 0;
                  _sale.updateOrder(value.first);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void confirmOrder() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      showAlertDialog(context);
      await Future.delayed(Duration(seconds: 1));
      var checkOpenShift = await OpenShiftController.checkOpenShift();
      if (checkOpenShift.length > 0) {
        var data = await PostOrder().beforPost("Pay");
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
            var set = await SettingController().getSetting(0);
            if (set.first.printReceiptTender) {
              bluetooth.isConnected.then(
                (isConnected) async {
                  if (isConnected) {
                    await prints.sample(pathImage, result);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentSuccess("Payment successful", data.status),
                        ),
                        (route) => false);
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConnectionBluetooth(),
                      ),
                    );
                  }
                },
              );
            } else {
              // not print pay
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentSuccess("Payment successful", data.status),
                  ),
                  (route) => false);
            }
          }
        } else {
          print(data.status);
          // can not post to server
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PaymentSuccess("Payment Wrong", data.status),
            ),
          );
        }
      } else {
        Navigator.pop(context);
        notOpenShift(
          "Please open shift before save order! Do you  want to set open shift ?",
        );
      }
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );

      //trancesion offline
      // var order = await SaleController().readOrder();
      // order.first.orderNo = "Offline";
      // SaleController().updateOrder(order.first);
      // var set = await SettingController().readSetting();
      // if (set.first.printReceiptTender) {
      //   bluetooth.isConnected.then((isConnected) async {
      //     if (isConnected) {
      //       await prints.sample(pathImage, result);
      //       Navigator.push(
      //           context, MaterialPageRoute(builder: (context) => HomeScreen()));
      //     } else {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => ConnectionBluetooth()));
      //     }
      //   });
      // } else {
      //   // not print pay
      //   await BillController().newBill();
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // }
    }
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
          child: Column(
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
}
