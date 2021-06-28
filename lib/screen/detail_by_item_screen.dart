import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/permission_controller.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/modal/order_detail_modal.dart';
import 'package:point_of_sale/widget/config.dart';

// ignore: must_be_immutable
class DetailByItem extends StatefulWidget {
  OrderDetail lsDetail = new OrderDetail();
  DetailByItem({this.lsDetail});
  @override
  _DetailByItemState createState() => _DetailByItemState();
}

class _DetailByItemState extends State<DetailByItem> {
  double _ordered = 0;
  String description = "";
  double disValue = 0;
  int dropDownValue = 0;
  bool checkDis = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _ordered = widget.lsDetail.qty;
    });
    if (widget.lsDetail.typeDis == "Cash") {
      setState(() {
        dropDownValue = 0;
        disValue = widget.lsDetail.discountRate;
      });
    } else {
      setState(() {
        dropDownValue = 1;
        disValue = widget.lsDetail.discountRate;
      });
    }
    PermissionController.permissionDiscountItem().then((value) {
      if (mounted) {
        if (value == "true") {
          setState(() {
            checkDis = true;
          });
        } else {
          setState(() {
            checkDis = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            onStretchTrigger: () {
              return;
            },
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.lsDetail.image != null
                      ? CachedNetworkImage(
                          imageUrl:
                              "${Config.image + "//Images/" + widget.lsDetail.image}",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            backgroundColor: Colors.green,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        )
                      : Image.asset("images/no_image.png"),
                  const DecoratedBox(
                    decoration: BoxDecoration(),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                  title: Text(
                    "${widget.lsDetail.khmerName}",
                    style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                  ),
                  subtitle: Text("Item",
                      style: GoogleFonts.laila(
                          textStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey))),
                  trailing: Text(
                    "${widget.lsDetail.currency}  ${(widget.lsDetail.unitPrice).toStringAsFixed(2)}",
                    style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600)),
                  )),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                height: 70,
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 50,
                      color: Colors.white,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Icon(Icons.remove),
                          onPressed: _ordered == 1
                              ? null
                              : () {
                                  setState(() {
                                    _ordered -= 1;
                                  });
                                }),
                    ),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontSize: 20),
                        key: Key(_ordered.toString()),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(),
                        initialValue: _ordered.toString(),
                        onChanged: (value) {
                          _ordered = double.parse(value);
                        },
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 50,
                      color: Colors.white,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _ordered += 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        title: Text(
                          "Discount",
                          style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600)),
                        ),
                        subtitle: Text("(Discount by item)",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.grey))),
                        trailing: DropdownButton(
                          value: dropDownValue,
                          dropdownColor: Colors.white,
                          onChanged: (int newVal) {
                            setState(() {
                              dropDownValue = newVal;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: 0,
                              child: Text('Cash'),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Percent'),
                            ),
                          ],
                        )),
                    TextFormField(
                      readOnly: checkDis ? true : false,
                      style: TextStyle(fontSize: 20),
                      key: Key(disValue.toString()),
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.red)),
                      ),
                      initialValue: disValue.toString(),
                      onChanged: (value) {
                        if (value == '') {
                          disValue = 0;
                        } else {
                          disValue = double.parse(value);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Descriptions",
                        style: GoogleFonts.laila(
                            textStyle: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w600)),
                      ),
                      subtitle: Text("(Express your interest in the item)",
                          style: GoogleFonts.laila(
                              textStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.grey))),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.red)),
                      ),
                      onChanged: (value) {
                        description = value.toString();
                      },
                      maxLength: 1000,
                      maxLines: 5,
                    ),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5),
        child: RaisedButton(
          color: Colors.lightGreen,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          onPressed: () {
            setState(() {
              widget.lsDetail.qty = _ordered;
              widget.lsDetail.printQty = _ordered;
              widget.lsDetail.comment = description;

              widget.lsDetail.discountRate = disValue;
              if (dropDownValue == 0) {
                widget.lsDetail.typeDis = "Cash";
              } else {
                widget.lsDetail.typeDis = "Percent";
              }
              SaleController().updateOrderDetail(widget.lsDetail);
              BlocProvider.of<BlocOrder>(context)
                  .add(EventOrder.add(key: widget.lsDetail.lineId));
            });
            Navigator.pop(context, "T");
          },
          child: Text("Update",
              style: GoogleFonts.laila(
                  textStyle:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }
}
