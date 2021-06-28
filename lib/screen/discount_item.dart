import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/screen/detail_sale_group_screen.dart';
import 'package:point_of_sale/screen/dicount_type.dart';

class DiscountItemScreen extends StatefulWidget {
  @override
  _DiscountItemScreenState createState() => _DiscountItemScreenState();
}

class _DiscountItemScreenState extends State<DiscountItemScreen> {
  List<OrderDetail> lsDetail = [];
  bool loading = false;
  bool status3 = false;
  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discount Item"),
        centerTitle: true,
      ),
      body: loading
          ? lsDetail.length > 0
              ? Card(
                  color: Colors.white,
                  child: ListView(
                      children: lsDetail.where((x) => x.qty > 0).map((e) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiscountType(detail: e)));
                      },
                      child: Card(
                        child: ListTile(
                            title: Text("${e.khmerName} ( ${e.uomName})",
                                style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500))),
                            subtitle: Text("${e.code}",
                                style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500))),
                            trailing: Container(
                              width: 100,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 19),
                                initialValue: e.discountRate.toString(),
                                decoration: InputDecoration(
                                  hintText: '0.0',
                                  labelStyle: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[350])),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                obscureText: false,
                                onChanged: (String cash) {
                                  e.discountRate = double.parse(cash);
                                },
                              ),
                            )),
                      ),
                    );
                  }).toList()))
              : Center(
                  child: Text("Data is empty !",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
        child: FlatButton(
          color: Color.fromRGBO(76, 175, 80, 1),
          padding: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Confirm",
                style: GoogleFonts.laila(
                    textStyle: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w500))),
          ),
          onPressed: () async {
            showAlertDialog(context);
            await Future.delayed(Duration(seconds: 2));
            lsDetail.forEach((e) {
              SaleController().updateOrderDetail(e);
              BlocProvider.of<BlocOrder>(context)
                  .add(EventOrder.add(key: e.lineId));
            });
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailSaleGroup()));
          },
        ),
      ),
    );
  }

  void getItems() {
    SaleController().readOrderDetail().then((value) {
      setState(() {
        if (mounted) {
          lsDetail = value;
          loading = true;
        }
      });
    });
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
                    borderRadius: BorderRadius.circular(8)),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.green,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text("Loading...",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)))),
                  ],
                ))));
  }
}
