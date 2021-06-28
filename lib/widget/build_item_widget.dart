import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/favorite_controller.dart';
import 'package:point_of_sale/controller/payment_mean_controller.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/controller/setting_controller.dart';
import 'package:point_of_sale/controller/tax_controller.dart';
import 'package:point_of_sale/modal/item_modal.dart';
import 'package:point_of_sale/modal/payment_means_modal.dart';
import 'package:point_of_sale/modal/setting_modal.dart';
import 'package:point_of_sale/modal/tax_modal.dart';
import 'package:point_of_sale/widget/config.dart';

// ignore: must_be_immutable
class BuildItem extends StatefulWidget {
  ItemMaster item;
  int tableId;
  BuildItem({this.item, this.tableId});
  @override
  _BuildItemState createState() => _BuildItemState();
}

class _BuildItemState extends State<BuildItem> {
  bool isFavorite = false;
  double count = 0;
  List<PaymentMean> lsPayment = [];
  List<Setting> lsSetting = [];
  List<Tax> lsTax = [];
  @override
  void initState() {
    super.initState();
    FavoriteController.isFavorite(widget.item.key).then((value) {
      if (value) {
        if (mounted) {
          setState(() {
            isFavorite = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isFavorite = false;
          });
        }
      }
    });
    getOrdered();
    getPayment();
    getSetting();
    getTax();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await SaleController()
            .newOrder(widget.item, widget.tableId, lsPayment, lsSetting, lsTax);
        BlocProvider.of<BlocOrder>(context)
            .add(EventOrder.add(key: widget.item.key, item: widget.item));
      },
      child: Card(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              child: SizedBox(
                height: 100,
                width: 120,
                child: widget.item.image != null
                    ? CachedNetworkImage(
                        imageUrl:
                            "${Config.image + "//Images/" + widget.item.image}",
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: new CircularProgressIndicator(
                              backgroundColor: Colors.green,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "images/no_image.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.item.itemName} (${widget.item.uom})",
                              style: GoogleFonts.laila(
                                  textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              )),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          BlocBuilder<BlocOrder, StateOrder>(
                            builder: (_, state) {
                              if (state.allQty == 0) {
                                widget.item.qty = 0;
                              }
                              if (state.qty == null) {
                                return SizedBox();
                              } else if (state.qty == 0 &&
                                  state.key == widget.item.key) {
                                widget.item.qty = state.qty;
                                return SizedBox();
                              } else {
                                if (state.qty != 0 &&
                                    state.key == widget.item.key) {
                                  widget.item.qty = state.qty;
                                }
                                return state.qty != 0 &&
                                        state.key == widget.item.key
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreen,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        height: 30,
                                        width: 30,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Text(
                                            "${state.qty.floor()}",
                                            style: GoogleFonts.laila(
                                                textStyle: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : widget.item.qty != 0
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.lightGreen,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            height: 30,
                                            width: 30,
                                            child: Center(
                                              child: Text(
                                                "${widget.item.qty.floor()}",
                                                style: GoogleFonts.laila(
                                                    textStyle: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : SizedBox();
                              }
                            },
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  "${widget.item.currency} ${widget.item.typeDis == "Percent" ? (widget.item.unitPrice - (widget.item.unitPrice * widget.item.disRate) / 100).toStringAsFixed(2) : (widget.item.unitPrice - widget.item.disRate).toStringAsFixed(2)}",
                                  style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              widget.item.disRate != 0
                                  ? Text(
                                      "${widget.item.currency} ${(widget.item.unitPrice).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  : Text(""),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                        ),

                        IconButton(
                          icon: isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(Icons.favorite_border),
                          onPressed: () {
                            if (isFavorite) {
                              FavoriteController.remove(widget.item.key);
                              setState(() {
                                isFavorite = false;
                              });
                            } else {
                              FavoriteController.save(widget.item.key);
                              setState(() {
                                isFavorite = true;
                              });
                            }
                          },
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     Share.share('${widget.item.itemName}',
                        //         subject:
                        //             '${(widget.item.unitPrice).toStringAsFixed(2)}');
                        //   },
                        //   icon: Icon(Icons.share),
                        // )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getOrdered() async {
    BlocProvider.of<BlocOrder>(context)
        .add(EventOrder.add(key: widget.item.key, item: widget.item));
  }

  void getPayment() {
    PaymentMeanController.eachPayment().then((value) {
      if (mounted) {
        setState(() {
          lsPayment = value;
        });
      }
    });
  }

  void getSetting() {
    SettingController().getSetting(0).then((value) {
      if (mounted) {
        setState(() {
          lsSetting = value;
        });
      }
    });
  }

  void getTax() {
    TaxController.eachTax().then((value) {
      if (mounted) {
        setState(() {
          lsTax = value;
        });
      }
    });
  }
}
