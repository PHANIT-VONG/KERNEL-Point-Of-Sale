import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  final String branchName;
  final String userName;

  const HomeScreen({Key key, this.branchName, this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer timer;
  double progress;

  @override
  Widget build(BuildContext context) {
    print('PageName = ${widget.branchName}');
    return Scaffold(
      drawer: GlobleDrawerWidget(
        branchName: widget.branchName,
        userName: widget.userName,
      ),
      appBar: AppBar(
        title: Text("POINT OF SALE"),
        centerTitle: true,
      ),
    );
  }
}
