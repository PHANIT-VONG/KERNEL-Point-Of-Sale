import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/controller/group2_controller.dart';
import 'package:point_of_sale/controller/group3_controller.dart';
import 'package:point_of_sale/controller/item_controller.dart';
import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:point_of_sale/modal/item_modal.dart';
import 'package:point_of_sale/modal/post_server_modal.dart';
import 'package:point_of_sale/screen/sale_group_screen.dart';
import 'package:point_of_sale/screen/table_group_screen.dart';
import 'package:point_of_sale/widget/build_item_widget.dart';
import 'package:point_of_sale/widget/config.dart';

// ignore: must_be_immutable
class SaleGroupTabBarWidget extends StatefulWidget {
  GroupItem lsGroupItem;
  String type;
  bool checkInternet;
  int tableId;
  List<Post> lsPost = [];
  SaleGroupTabBarWidget(this.lsGroupItem, this.type, this.checkInternet,
      {Key key, this.tableId, this.lsPost})
      : super(key: key);

  @override
  _SaleGroupTabBarWidgetState createState() =>
      _SaleGroupTabBarWidgetState(startGroup: this.lsGroupItem);
}

class _SaleGroupTabBarWidgetState extends State<SaleGroupTabBarWidget> {
  final GroupItem startGroup;
  var pageWiseController;
  List<int> keys;
  _SaleGroupTabBarWidgetState({this.startGroup});
  List<GroupItem> nexGroup = [];
  var isloading = true;
  @override
  void initState() {
    super.initState();
    getGroupItem();
    if (widget.checkInternet == true) {
      pageWiseController = PagewiseLoadController(
        pageSize: 10,
        pageFuture: (index) =>
            ItemController.eachItem(startGroup, keys, 10, index + 1),
      );
    } else {
      pageWiseController = PagewiseLoadController(
        pageSize: 10,
        pageFuture: (index) =>
            ItemController().getItems(startGroup, 10, index + 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TableGroupScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Container(
                          color: Colors.grey,
                          child: widget.lsGroupItem.image != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      "${Config.image + "//Images/itemgroup/" + widget.lsGroupItem.image}",
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: new CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'images/no_image.png',
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'images/no_image.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      nexGroup.length != 0
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: nexGroup.map((e) {
                                    return InkWell(
                                      onTap: () {
                                        if (widget.type == "G1") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SaleGroupScreen(
                                                type: "G2",
                                                lsPost: widget.lsPost,
                                                tableId: widget.tableId,
                                                g1Id: widget.lsGroupItem.g1Id,
                                              ),
                                            ),
                                          );
                                        } else if (widget.type == "G2") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SaleGroupScreen(
                                                type: "G3",
                                                lsPost: widget.lsPost,
                                                tableId: widget.tableId,
                                                g1Id: widget.lsGroupItem.g1Id,
                                                g2Id: widget.lsGroupItem.g2Id,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 150,
                                            width: 135,
                                            child: e.image != null
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        "${Config.image + "//Images/itemgroup/" + e.image}",
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child: SizedBox(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        child:
                                                            new CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.green,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'images/no_image.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          Positioned(
                                            //height: 50,
                                            bottom: 0,
                                            child: Container(
                                              height: 50,
                                              width: 135,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                              child: Text(
                                                '${e.name}',
                                                maxLines: 2,
                                                style: GoogleFonts.laila(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
            PagewiseSliverList(
              itemBuilder: (context, ItemMaster item, _) {
                return BuildItem(item: item, tableId: widget.tableId);
              },
              pageLoadController: pageWiseController,
            ),
          ],
        ),
      ),
    );
  }

  void getGroupItem() async {
    if (widget.type == "G1") {
      bool result = await DataConnectionChecker().hasConnection;
      if (result) {
        Group2Controller.eachGroup2(startGroup.g1Id).then(
          (value) {
            if (value.length != 0) {
              if (mounted) {
                setState(() {
                  nexGroup = value;
                });
              }
            }
          },
        );
      } else {
        Group2Controller().getGroup2(startGroup.g1Id).then(
          (value) {
            if (mounted) {
              setState(() {
                nexGroup = value;
              });
            }
          },
        );
      }
    } else if (widget.type == "G2") {
      bool result = await DataConnectionChecker().hasConnection;
      if (result) {
        Group3Controller.eachGroup3(startGroup.g1Id, startGroup.g2Id).then(
          (value) {
            if (value.length != 0) {
              if (mounted) {
                setState(() {
                  nexGroup = value;
                });
              }
            }
          },
        );
      } else {
        Group3Controller().getGroup3(startGroup.g1Id, startGroup.g2Id).then(
          (value) {
            if (mounted) {
              setState(() {
                nexGroup = value;
              });
            }
          },
        );
      }
    }
  }
}
