import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF93A1B1),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF0F0E13),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF21262B),
      iconTheme: IconThemeData(color: Color(0xFF93A1B1)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF303239),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Color(0xFF93A1B1)),
    ),
    backgroundColor: Color(0xFF21262B));
