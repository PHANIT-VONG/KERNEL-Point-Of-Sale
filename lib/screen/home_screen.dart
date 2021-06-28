import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  HomeScreen({this.name});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer timer;
  double progress;

  @override
  Widget build(BuildContext context) {
    print('PageName = ${widget.name}');
    return Scaffold(
      drawer: GlobleDrawerWidget(),
      appBar: AppBar(
        title: Text("POINT OF SALE"),
        centerTitle: true,
      ),
    );
  }
}
