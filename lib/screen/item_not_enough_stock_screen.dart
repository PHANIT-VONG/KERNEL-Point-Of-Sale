import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/modal/return_from_server_modal.dart';

// ignore: must_be_immutable
class NotEnoughStockScreen extends StatefulWidget {
  List<ItemReturn> lsItemReturn = [];
  NotEnoughStockScreen({this.lsItemReturn});
  @override
  _NotEnoughStockState createState() => _NotEnoughStockState();
}

class _NotEnoughStockState extends State<NotEnoughStockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Not Enuogh Stock",
          style: GoogleFonts.laila(
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: widget.lsItemReturn.map((e) {
          return InkWell(
            onTap: () {
              dailog(e);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Text(
                    e.code,
                    style: GoogleFonts.laila(
                      textStyle:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                  title: Text(
                    e.khmerName,
                    style: GoogleFonts.laila(
                      textStyle:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                  trailing: Text(
                    "${e.inStock}",
                    style: GoogleFonts.laila(
                      textStyle:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> dailog(ItemReturn re) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Code",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.code}",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Name",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.khmerName}",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "In Stock",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.inStock}",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 110,
                            child: Text(
                              "Ordered Qty",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.orderQty}",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 125,
                            child: Text(
                              "Commited Qty",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.committed}",
                              style: GoogleFonts.laila(
                                textStyle: TextStyle(fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Positioned(
                  top: -30,
                  child: Center(
                    child: Icon(
                      Icons.info,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  )),
              Positioned(
                right: 5,
                bottom: 0,
                child: RaisedButton(
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
                          textStyle:
                              TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
