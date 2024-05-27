import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Color(0xFF004B90),
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF1F8FF),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 158, 199, 246),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF176FF2),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Color(0xFF176FF2)),
  ),
);
