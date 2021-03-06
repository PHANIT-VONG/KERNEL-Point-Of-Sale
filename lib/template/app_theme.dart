import 'package:flutter/material.dart';

enum AppTheme { GreenLight, GreenDark, BlueLight, BlueDark }
final appThemeData = {
  AppTheme.GreenLight:
      ThemeData(brightness: Brightness.light, primaryColor: Colors.green),
  AppTheme.GreenDark:
      ThemeData(brightness: Brightness.light, primaryColor: Colors.green[700]),
  AppTheme.BlueLight:
      ThemeData(brightness: Brightness.light, primaryColor: Colors.green),
  AppTheme.BlueDark:
      ThemeData(brightness: Brightness.light, primaryColor: Colors.green[700])
};
