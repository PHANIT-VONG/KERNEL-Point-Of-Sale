import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/controller/permission_controller.dart';
import 'package:point_of_sale/controller/receipt_contoller.dart';
import 'package:point_of_sale/controller/receipt_information_controller.dart';
import 'package:point_of_sale/modal/receip_detail.dart';
import 'package:point_of_sale/modal/receipt_information.dart';
import 'package:point_of_sale/modal/receipts.dart';

class ReviewReceipt extends StatefulWidget {
  final Receipts receipts;
  final int receiptId;
  ReviewReceipt({this.receiptId, this.receipts});

  @override
  _ReviewReceiptState createState() => _ReviewReceiptState();
}

class _ReviewReceiptState extends State<ReviewReceipt> {
  List<ReceiptDetail> lsDetail = [];
  String type;
  bool loading = false;
  ReceiptInformation receiptInfo = new ReceiptInformation();
  @override
  void initState() {
    super.initState();
    ReceiptController.eatchReceiptDetail(widget.receiptId).then(
      (value) {
        if (value.length > 0) {
          if (mounted) {
            setState(() {
              lsDetail = value;
              loading = true;
            });
          }
        }
      },
    );
    getReceiptInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.more_vert, size: 30),
              onPressed: () {
                _settingModalBottomSheet(context);
              })
        ],
        title: Text(
          "Review Receipt (${widget.receipts.receiptNo})",
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
      body: loading
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        child: Image.asset("images/logo.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          width: 100,
                          height: 120,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Branch :",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Address :",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Phone 1:",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Phone 2:",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${receiptInfo.branchName != null ? receiptInfo.branchName : ""}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${receiptInfo.address != null ? receiptInfo.address : " "}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${receiptInfo.phone1 != null ? receiptInfo.phone1 : ""}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${receiptInfo.phone2 != null ? receiptInfo.phone2 : " "}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Center(
                    child: Text(
                      "RECEIPT",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Cashier",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.userAccount.employee.name}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Queue",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.queueNo}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Pay By",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.paymentType}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Transaction",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.orderNo}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Receipt No #",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.receiptNo}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Date In",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.receipts.dateIn)).toString()}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Date Out",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.receipts.dateOut)).toString()}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Time In",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.timeIn}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Time Out",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.timeOut}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "---------------------------------------------------"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Text(
                          "№ ",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Name",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 38,
                        height: 25,
                        child: Text(
                          "Qty",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 25,
                        child: Text(
                          "Price",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 25,
                        child: Text(
                          "Dis.",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 85,
                        height: 25,
                        child: Text(
                          "Total",
                          style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lsDetail.length,
                    itemBuilder: (BuildContext context, int e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 20,
                              child: Text(
                                "${e + 1}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${lsDetail[e].khmerName}(${lsDetail[e].unitofMeansure.name})",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 38,
                              height: 25,
                              child: Text(
                                "${lsDetail[e].qty.floor()}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              height: 25,
                              child: Text(
                                "${lsDetail[e].unitPrice.toStringAsFixed(2)}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              height: 25,
                              child: Text(
                                "${lsDetail[e].discountRate.toStringAsFixed(1)} ${lsDetail[e].typeDis == "Percent" ? "%" : "Cash"}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 85,
                              height: 25,
                              child: Text(
                                "${lsDetail[e].total.toStringAsFixed(2)}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "---------------------------------------------------"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "SUB-TOTAL :",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.subTotal.toStringAsFixed(2),
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "DISCOUNT (${widget.receipts.typeDis == "Percent" ? "%" : "Cash"}):",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.discountRate.toStringAsFixed(2),
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "GRAND-TOTAL :",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.currencyDisplay +
                          " " +
                          widget.receipts.grandTotal.toStringAsFixed(2),
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "---------------------------------------------------"),
                  ),
                ),

                // widget.receipts.paymentType.contains(',') == true
                widget.receipts.paymentType == null
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Cash Pay :",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              trailing: Text(
                                //"${widget.receipts.receivedType.split(',')[0]}",
                                'Null',
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Bank Pay :",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              trailing: Text(
                                //"${widget.receipts.receivedType.split(',')[1]}",
                                'Null',
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : widget.receipts.paymentType == "Cash"
                        ? Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Cash Pay :",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              trailing: Text(
                                "${widget.receipts.receivedType}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Bank Pay :",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              trailing: Text(
                                "${widget.receipts.receivedType}",
                                style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "Received :",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.received.toStringAsFixed(2),
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15),
                //   child: ListTile(
                //     title: Text("Credit :",
                //         style: GoogleFonts.laila(
                //             textStyle: TextStyle(
                //                 fontSize: 17.0, fontWeight: FontWeight.w500))),
                //     trailing: Text(widget.receipts.credit.toStringAsFixed(2),
                //         style: GoogleFonts.laila(
                //             textStyle: TextStyle(
                //                 fontSize: 17.0, fontWeight: FontWeight.w500))),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "Change :",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 19.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.currencyDisplay +
                          " " +
                          widget.receipts.change.toStringAsFixed(2),
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 19.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Center(
                    child: Text(
                      "${receiptInfo.desEnglish}",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
    );
  }

  void getReceiptInfo() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      ReceiptInformationController.eatchRI().then((value) {
        if (value.length > 0) {
          if (mounted) {
            setState(() {
              receiptInfo = value.first;
            });
          }
        }
      });
    } else {
      ReceiptInformationController().getReceipt().then((value) {
        if (value.length > 0) {
          if (mounted) {
            setState(() {
              receiptInfo = value.first;
            });
          }
        }
      });
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.all(0),
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
                      new Card(
                        child: new ListTile(
                          leading: new Icon(
                            Icons.print,
                            size: 30,
                            color: Colors.black87,
                          ),
                          title: new Text(
                            'Print Receipt',
                            style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      new Card(
                        child: new ListTile(
                            leading: new Icon(
                              Icons.cancel,
                              size: 30,
                              color: Colors.black87,
                            ),
                            title: new Text(
                              'Cancal Receipt',
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            onTap: () async {
                              var check = await PermissionController
                                  .permissionCancelOrder();
                              if (check == 'true') {
                              } else {
                                hasNotPermission(
                                    "You cannot access to this function .");
                              }
                            }),
                      ),
                      new Card(
                        child: new ListTile(
                            leading: new Icon(
                              Icons.assignment_return,
                              size: 30,
                              color: Colors.black87,
                            ),
                            title: new Text(
                              'Return Receipt',
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            onTap: () async {
                              var check = await PermissionController
                                  .permissionReturnOrder();
                              if (check == 'true') {
                                print('Permission true');
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
}
