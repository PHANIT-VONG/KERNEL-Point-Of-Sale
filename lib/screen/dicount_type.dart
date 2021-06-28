import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';

class DiscountType extends StatefulWidget {
  final OrderDetail detail;
  DiscountType({this.detail});
  @override
  _DiscountTypeState createState() => _DiscountTypeState();
}

class _DiscountTypeState extends State<DiscountType> {
  bool cash = false;
  bool percent = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.detail.typeDis == "Cash") {
      if (mounted) {
        setState(() {
          cash = true;
          percent = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          percent = true;
          cash = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Discount Type"),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("Percent",
                    style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500))),
                trailing: FlutterSwitch(
                  showOnOff: true,
                  activeTextColor: Colors.black,
                  inactiveTextColor: Colors.blue[50],
                  value: percent,
                  onToggle: (val) {
                    setState(() {
                      if (val) {
                        percent = true;
                        widget.detail.typeDis = "Percent";
                        cash = false;
                      } else {
                        percent = false;
                        cash = true;
                        widget.detail.typeDis = "Cash";
                      }
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Cash",
                    style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500))),
                trailing: FlutterSwitch(
                  showOnOff: true,
                  activeTextColor: Colors.black,
                  inactiveTextColor: Colors.blue[50],
                  value: cash,
                  onToggle: (val) {
                    setState(() {
                      if (val) {
                        percent = false;
                        widget.detail.typeDis = "Cash";
                        cash = true;
                      } else {
                        percent = true;
                        widget.detail.typeDis = "Percent";
                        cash = false;
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
