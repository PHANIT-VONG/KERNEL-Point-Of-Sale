import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/bloc_theme/bloc_theme_event.dart';

class BlocTheme extends Bloc<EventTheme, ThemeData> {
  BlocTheme()
      : super(
          ThemeData(
            primaryColor: Color.fromRGBO(76, 175, 80, 1),
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.white,
          ),
        );

  @override
  Stream<ThemeData> mapEventToState(EventTheme event) async* {
    switch (event.eventType) {
      case TypeEvent.green:
        yield ThemeData(
          primaryColor: Color.fromRGBO(76, 175, 80, 1),
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        );
        break;
      case TypeEvent.red:
        yield ThemeData(
          primaryColor: Colors.red,
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        );
        break;
      case TypeEvent.blue:
        yield ThemeData(
          primaryColor: Colors.blue,
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        );
        break;
      case TypeEvent.black:
        yield ThemeData(
          primaryColor: Colors.black,
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        );
        break;
      case TypeEvent.tor:
        yield ThemeData(
          primaryColor: Color.fromRGBO(159, 122, 94, 1),
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        );
        break;
      case TypeEvent.teal:
        yield ThemeData(
          primaryColor: Colors.teal,
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        );
        break;
    }
  }
}
