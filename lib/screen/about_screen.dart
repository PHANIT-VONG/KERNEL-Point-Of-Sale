import 'package:flutter/material.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GlobleDrawerWidget(),
      appBar: AppBar(
        title: Text("About Us"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text(
            "About Screen",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
