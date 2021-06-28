import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/controller/permission_controller.dart';
import 'package:point_of_sale/screen/login_screen.dart';
import 'package:point_of_sale/screen/open_shift_screen.dart';
import 'package:point_of_sale/screen/theme_screen.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

// ignore: must_be_immutable
class SettingScreen extends StatefulWidget {
  SettingScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  // ignore: must_call_super
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: Scaffold(
        drawer: GlobleDrawerWidget(),
        appBar: AppBar(
          title: Text(
            "Setting",
            style: GoogleFonts.laila(
              textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () async {
                  var per =
                      await PermissionController.checkPermissionOpenShift();
                  if (per == 'false') {
                    hasNotSetOpenShift("You cannot access to this function.");
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OpenShiftScreen(),
                      ),
                    );
                  }
                },
                child: Card(
                  color: Colors.white70,
                  shadowColor: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.money, size: 29, color: Colors.black54),
                    title: Text(
                      "Open Shift",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    subtitle: Text(
                      "Cash open shift",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThemeScreen()),
                  );
                },
                child: Card(
                  color: Colors.white70,
                  shadowColor: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.palette_sharp,
                        size: 29, color: Colors.black54),
                    title: Text(
                      "Theme",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      "Change template app",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: InkWell(
                onTap: () {
                  FlutterSession().set("localCurr", 0);
                  FlutterSession().set("systemType", '');
                  FlutterSession().set("userId", 0);
                  FlutterSession().set("branchId", 0);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
                child: Card(
                  color: Colors.white70,
                  shadowColor: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.login_outlined,
                        size: 29, color: Colors.black54),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      "Log out app",
                      style: GoogleFonts.laila(
                        textStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> hasNotSetOpenShift(String mess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('System Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '$mess',
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
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
                  Text(
                    'Ok',
                    style: GoogleFonts.laila(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
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
