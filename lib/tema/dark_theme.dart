import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  primaryColor: Color(0xFF176FF2),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF176FF2),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF176FF2),
  ),
);
