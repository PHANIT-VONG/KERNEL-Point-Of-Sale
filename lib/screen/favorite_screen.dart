import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/favorite_controller.dart';
import 'package:point_of_sale/controller/item_controller.dart';
import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:point_of_sale/modal/item_modal.dart';
import 'package:point_of_sale/screen/detail_sale_group_screen.dart';
import 'package:point_of_sale/widget/build_item_widget.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

// ignore: must_be_immutable
class FavoriteScreen extends StatefulWidget {
  List<int> lsFavorite = [];
  FavoriteScreen({Key key, this.lsFavorite}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var pageWiseController;
  GroupItem group;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageWiseController = PagewiseLoadController(
        pageSize: 10,
        pageFuture: (index) =>
            ItemController.eachItem(group, widget.lsFavorite, 10, index + 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: GlobleDrawerWidget(),
        appBar: AppBar(
          title: Text("Favorite"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.clear, size: 25),
              onPressed: () {
                clearFavorite();
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            pageWiseController.reset();
          },
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: PagewiseListView(
                itemBuilder: (context, ItemMaster item, _) {
                  return BuildItem(item: item);
                },
                pageLoadController: pageWiseController,
              )),
        ),
        bottomNavigationBar:
            BlocBuilder<BlocOrder, StateOrder>(builder: (_, state) {
          if (state.qty == null) {
            return Container(
              child: Text(""),
            );
          } else {
            return state.allQty != 0
                ? Container(
                    width: double.infinity,
                    color: Color.fromRGBO(230, 230, 230, 1),
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                "${state.currency}  ${state.total.toStringAsFixed(2)}",
                                style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600))),
                          ),
                          Container(
                            width: 200,
                            child: RaisedButton(
                              splashColor: Colors.grey,
                              color: Colors.red,
                              child: Row(
                                children: [
                                  SizedBox(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    height: 30,
                                    width: 30,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                        "${state.allQty.floor()}",
                                        style: GoogleFonts.laila(
                                            textStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),
                                  IconButton(
                                    icon: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                    onPressed: () {},
                                  ),
                                  Expanded(
                                    child: Text("View Cart",
                                        style: GoogleFonts.laila(
                                            textStyle: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))),
                                  )
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailSaleGroup()))
                                    .then((value) {});
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(child: Text(""));
          }
        }));
  }

  Future<void> clearFavorite() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Favorite'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Do you want to clear favorite or item ordered in list favorite ?',
                    style: GoogleFonts.laila(
                        textStyle:
                            TextStyle(fontSize: 18, color: Colors.black))),
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
                  Text('Yes',
                      style: GoogleFonts.laila(
                          textStyle:
                              TextStyle(fontSize: 15, color: Colors.white))),
                ],
              ),
              onPressed: () {
                FavoriteController.removeAll('favorite');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoriteScreen(lsFavorite: [])),
                );
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
                  Text('No',
                      style: GoogleFonts.laila(
                          textStyle:
                              TextStyle(fontSize: 15, color: Colors.white))),
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
