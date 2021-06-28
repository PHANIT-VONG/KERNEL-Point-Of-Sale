import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_order/event_order.dart';
import 'package:point_of_sale/controller/member_card_controller.dart';
import 'package:point_of_sale/controller/sale_controller.dart';
import 'package:point_of_sale/modal/member_card.dart';

class DiscountMemberCard extends StatefulWidget {
  @override
  _DiscountMemberCardState createState() => _DiscountMemberCardState();
}

class _DiscountMemberCardState extends State<DiscountMemberCard> {
  List<MemberCard> lsMember = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMemberCard();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Discount Member",
            style: GoogleFonts.laila(
                textStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchTable());
              })
        ],
      ),
      body: loading
          ? lsMember.length > 0
              ? Card(
                  color: Colors.white,
                  child: ListView(
                      children: lsMember.map((e) {
                    return BuinMember(mem: e);
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
    );
  }

  void getMemberCard() {
    MemberCardController.eachMember().then((value) {
      if (value.length > 0) {
        if (mounted) {
          setState(() {
            lsMember = value;
            loading = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            loading = true;
          });
        }
      }
    });
  }
}

class BuinMember extends StatelessWidget {
  final MemberCard mem;
  BuinMember({this.mem});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        title: Text("${mem.name}",
            style: GoogleFonts.laila(
                textStyle:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
        trailing: Text("${mem.refNo}",
            style: GoogleFonts.laila(
                textStyle:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
        subtitle: Text("${mem.cardType.name}",
            style: GoogleFonts.laila(
                textStyle: TextStyle(fontSize: 15, color: Colors.grey))),
        leading: Icon(
          Icons.person_outline,
          size: 30,
          color: Colors.black87,
        ),
        onTap: () {
          _settingModalBottomSheet(context, mem,"");
        },
      ),
    );
  }
}

void _settingModalBottomSheet(context, MemberCard m,String from) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 232, 232, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text("Detail Card",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700))),
                        new IconButton(
                            icon: Icon(Icons.close, size: 30),
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: new ListView(
                    children: [
                      ListTile(
                        title: Text("ID :",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                        trailing: Text("${m.refNo}",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                      ),
                      ListTile(
                        title: Text("Name :",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                        trailing: Text("${m.name}",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                      ),
                      ListTile(
                        title: Text("Card Type :",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                        trailing: Text("${m.cardType.name}",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                      ),
                      ListTile(
                        title: Text("Discount :",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                        trailing: Text(
                            "${m.cardType.discount}  ${m.cardType.typeDis == "Percent" ? "%" : "cash"}",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                      ),
                      ListTile(
                        title: Text("Expire Date :",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                        trailing: Text(
                            "${DateFormat('dd-MM-yyyy').format(DateTime.parse(m.expireDate)).toString()}",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                      ),
                      ListTile(
                        title: Text("Discription :",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                        trailing: Text("${m.description}",
                            style: GoogleFonts.laila(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: RaisedButton(
                          color: Color.fromRGBO(76, 175, 80, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Apply",
                                style: GoogleFonts.laila(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))),
                          ),
                          onPressed: () {
                            SaleController().readOrder().then((value) {
                              if (value.length > 0) {
                                value.first.discountRate =
                                    m.cardType.discount;
                                value.first.typeDis = m.cardType.typeDis;
                                SaleController().updateOrder(value.first);
                              }
                            });
                            BlocProvider.of<BlocOrder>(context)
                                .add(EventOrder.add());
                            if(from=="S"){
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }else{
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
class SearchTable extends SearchDelegate<String> {
  List<MemberCard> ls = [];
  List<MemberCard> member = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "true");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == "") {
      if (member.length != 0) {
        return Card(
            child: ListTile(
              title: Text("${member.first.name}",
                  style: GoogleFonts.laila(
                      textStyle:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
              trailing: Text("${member.first.refNo}",
                  style: GoogleFonts.laila(
                      textStyle:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
              subtitle: Text("${member.first.cardType.name}",
                  style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.grey))),
              leading: Icon(
                Icons.person_outline,
                size: 30,
                color: Colors.black87,
              ),
              onTap: () {
                _settingModalBottomSheet(context, member.first,"S");
              },
            )
        );
      }
      return Text("");
    } else {
      return Text("");
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    MemberCardController.searchMember(query).then((value) {
      ls = [];
      ls.addAll(value);
    });
    return ls.isEmpty
        ? Center(
            child: Text('No Results Found...',
                style: TextStyle(fontSize: 20, color: Colors.black)),
          )
        : ListView(
            children: ls.map((e) {
              return ListTile(
                onTap: () {
                  showResults(context);
                  member = [];
                  member.add(e);
                },
                title: Text(
                  "${e.name}",
                  style: GoogleFonts.laila(
                      textStyle: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500)),
                ),
                subtitle: Text("${e.refNo}",
                    style: GoogleFonts.laila(
                        textStyle:
                            TextStyle(fontSize: 15.0, color: Colors.grey))),
              );
            }).toList(),
          );
  }
}
