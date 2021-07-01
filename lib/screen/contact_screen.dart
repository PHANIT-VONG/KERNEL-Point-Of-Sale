import 'package:flutter/material.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GlobleDrawerWidget(),
      appBar: AppBar(
        title: Text("Contact Us"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "0962342667",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "sonsoeum.webdev@gmail.com",
              style: TextStyle(fontSize: 20),
            )
          ],
        )),
      ),
    );
  }
}
