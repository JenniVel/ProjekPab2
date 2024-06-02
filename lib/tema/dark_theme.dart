import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  primaryColor: const Color(0xFF93A1B1), //judul
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color.fromARGB(133, 6, 6, 6),//container awl msuk/dftr, dn background pages lain
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF21262B),
    // backgroundColor:  Color.fromARGB(136, 0, 0, 0), //background awl msuk/dftr
    iconTheme: IconThemeData(color: Color(0xFF93A1B1)), //icon
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF303239), //button dpn masuk/daftar &label atas
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Color(0xFF93A1B1)), //text deskripsi
  ),
  backgroundColor: Color.fromARGB(255, 37, 42, 51), //navigasi bwh
);
