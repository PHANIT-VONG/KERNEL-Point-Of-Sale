import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/controller/receipt_contoller.dart';
import 'package:point_of_sale/modal/receipts.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';
import 'package:point_of_sale/widget/review_receipt_widget.dart';

class SummarySale extends StatefulWidget {
  @override
  _SummarySaleState createState() => _SummarySaleState();
}

class _SummarySaleState extends State<SummarySale> {
  PagewiseLoadController<Receipts> pageWiseController;
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  @override
  void initState() {
    super.initState();
    pageWiseController = PagewiseLoadController(
      pageSize: 10,
      pageFuture: (index) => ReceiptController.eatchReceipt(10, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GlobleDrawerWidget(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 28,
            ),
            onPressed: () {},
          )
        ],
        title: Text(
          "Summary Receipt",
          style: GoogleFonts.laila(
            textStyle: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pageWiseController.reset();
        },
        child: Container(
          width: double.infinity,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date From",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.green,
                              readOnly: true,
                              onTap: () {
                                _selectDateFrom(context);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8.0),
                                hintText: DateFormat("dd-MM-yyyy")
                                    .format(dateFrom)
                                    .toString(),
                                hintStyle: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.green,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date To",
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextFormField(
                            cursorColor: Colors.green,
                            readOnly: true,
                            onTap: () {
                              _selectDateTo(context);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: DateFormat("dd-MM-yyyy")
                                  .format(dateTo)
                                  .toString(),
                              hintStyle: GoogleFonts.laila(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  child: Center(
                    child: Text(
                      "RECEIPT",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  height: 30,
                ),
              ),
              PagewiseListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, Receipts receipts, _) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewReceipt(
                            receiptId: receipts.receiptID,
                            receipts: receipts,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.receipt, size: 35),
                        title: Text(
                          "R* ${receipts.receiptNo}",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          "${DateFormat("dd-MM-yyyy").format(DateTime.parse(receipts.dateIn))} (${receipts.timeIn})",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        trailing: Text(
                          "${receipts.currencyDisplay} ${receipts.grandTotal}",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                pageLoadController: pageWiseController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDateFrom(BuildContext context) async {
    DateTime datePicker = await showDatePicker(
      context: context,
      initialDate: dateFrom,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Colors.green,
            accentColor: Colors.green,
          ),
          child: child,
        );
      },
    );
    if (datePicker != null && datePicker != dateFrom) {
      setState(() {
        dateFrom = datePicker;
      });
    }
  }

  Future<Null> _selectDateTo(BuildContext context) async {
    DateTime datePicker = await showDatePicker(
      context: context,
      initialDate: dateTo,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primarySwatch: Colors.green,
              primaryColor: Colors.green,
              accentColor: Colors.green),
          child: child,
        );
      },
    );
    if (datePicker != null && datePicker != dateTo) {
      setState(() {
        dateTo = datePicker;
      });
    }
  }
}
