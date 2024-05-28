import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Color(0xFF004B90),
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFA3CAEE),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 55, 119, 192),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 227, 231, 242)),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Color(0xFF176FF2)),
  ),
);
