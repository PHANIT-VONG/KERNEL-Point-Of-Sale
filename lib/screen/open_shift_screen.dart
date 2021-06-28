import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/controller/exchange_rate_controller.dart';
import 'package:point_of_sale/controller/open_shift_controller.dart';
import 'package:point_of_sale/modal/exchange_rate_modal.dart';
import 'package:point_of_sale/modal/open_shift_modal.dart';

class OpenShiftScreen extends StatefulWidget {
  @override
  _OpenShiftScreenState createState() => _OpenShiftScreenState();
}

class _OpenShiftScreenState extends State<OpenShiftScreen> {
  bool valid = true;
  double total = 0;
  ExchangRate exchangRate = new ExchangRate();
  List<SummaryOpenShift> summary = [];
  @override
  void initState() {
    // TODO: implement initState
    getExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Open Shift",
          style: GoogleFonts.laila(
            textStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 35,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                "CURRENCY",
                style: GoogleFonts.laila(
                  textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          exchangRate.shiftForms != null
              ? ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  children: exchangRate.shiftForms.map((e) {
                    if (summary.length != exchangRate.shiftForms.length) {
                      var sum = new SummaryOpenShift(e.id, 0);
                      summary.add(sum);
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 19),
                            decoration: InputDecoration(
                              hintText: '0.00',
                              labelText: "${e.currency}",
                              labelStyle:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[350])),
                              prefixIcon: Icon(Icons.money),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: valid ? Colors.grey[400] : Colors.red,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: false,
                            onChanged: (String cash) {
                              summmary(e.id, cash, e.rateIn);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        valid == false
                            ? Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  child: Text(
                                    "field is required",
                                    style: GoogleFonts.laila(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  }).toList(),
                )
              : Container(),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 35,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                "SUMMARY",
                style: GoogleFonts.laila(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            height: 40,
            color: Colors.grey[200],
            child: Row(
              children: [
                Text(
                  "Total Cash In :",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    "${total.toStringAsFixed(2)}",
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  child: Text(
                    "${exchangRate.systemCurrency}",
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: FlatButton(
              height: 45,
              color: Color.fromRGBO(76, 175, 80, 1),
              onPressed: () async {
                if (total == 0) {
                  setState(() {
                    valid = false;
                  });
                } else {
                  setState(() {
                    valid = true;
                  });
                  showAlertDialog(context);
                  dynamic userId = await FlutterSession().get("userId");
                  PostOpenShift shift =
                      new PostOpenShift(userId: userId, cash: total);
                  await OpenShiftController().postOpenShift(shift);
                  saveSetOpenShift("Open shift save success!!!");
                }
              },
              child: Text(
                "Save",
                style: GoogleFonts.laila(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void summmary(int id, String cash, double rete) {
    double sum = 0;
    summary.forEach((x) {
      if (x.id == id) {
        if (cash == "") {
          x.value = 0;
        } else {
          x.value = double.tryParse(cash) * rete;
        }
      }
      sum += x.value;
    });
    setState(() {
      total = sum;
    });
  }

  Future<void> saveSetOpenShift(String mess) async {
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getExchangeRate() async {
    var ex = await ExchangeRateController.eachExchange();
    if (ex != null) {
      if (mounted) {
        setState(() {
          exchangRate = ex;
        });
      }
    }
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          width: 110.0,
          height: 92.0,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
}

class SummaryOpenShift {
  int id;
  double value;
  SummaryOpenShift(this.id, this.value);
}

class ShowHied {
  int show;
  int key;
  double qty;
  ShowHied({this.show, this.key, this.qty});
}
