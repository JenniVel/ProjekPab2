import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF004B90), //text judul
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color.fromARGB(255, 228, 239, 250), //background
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 55, 119, 192), //lupaaa
      iconTheme: IconThemeData(color: Colors.white), // icon
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 227, 231, 242)),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Color.fromARGB(255, 93, 152, 218)),
    ),
    backgroundColor: Color.fromARGB(255, 211, 221, 232)); //nav bawah, label
