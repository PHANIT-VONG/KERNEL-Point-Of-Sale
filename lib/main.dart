import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/bloc_order/bloc_order.dart';
import 'package:point_of_sale/bloc_theme/bloc_theme.dart';
import 'package:point_of_sale/screen/home_screen.dart';
import 'package:point_of_sale/screen/login_screen.dart';
import 'package:point_of_sale/screen/setting_screen.dart';

void main() {
  runApp(Dashboard());
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _connectionStatus = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          _connectionStatus = true;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          _connectionStatus = true;
        });
      } else if (result == ConnectivityResult.none) {
        setState(() {
          _connectionStatus = false;
        });
      } else {
        setState(() {
          _connectionStatus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocOrder>(
          create: (BuildContext context) => BlocOrder(),
        ),
        BlocProvider<BlocTheme>(
          create: (BuildContext context) => BlocTheme(),
        )
      ],
      child: BlocBuilder<BlocTheme, ThemeData>(
        builder: (_, state) {
          return MaterialApp(
            home: new LoginScreen(),
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => new HomeScreen(),
              '/setting': (BuildContext context) => new SettingScreen(),
            },
            builder: (context, screen) => Scaffold(
              appBar: _connectionStatus
                  ? null
                  : PreferredSize(
                      preferredSize: Size.fromHeight(25),
                      child: AppBar(
                        backgroundColor: Colors.red,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.signal_cellular_connected_no_internet_4_bar,
                              size: 17,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              _connectionStatus ? "Connected" : "No Connected",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ],
                        ),
                        centerTitle: true,
                      ),
                    ),
              body: screen,
            ),
            title: "POS",
            theme: state,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
