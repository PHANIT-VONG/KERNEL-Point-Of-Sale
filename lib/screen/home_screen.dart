import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer timer;
  double progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GlobleDrawerWidget(),
      appBar: AppBar(
        title: Text("POINT OF SALE"),
        centerTitle: true,
      ),
    );
  }
}
