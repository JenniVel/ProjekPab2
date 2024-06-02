import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: const Color(0xFF004B90), //text judul
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color.fromARGB(
      255, 228, 239, 250), //background & container di masuk/dftr
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFAFD4F5), //di bg masuk/daftar bgian luar
    iconTheme: IconThemeData(color: Colors.white), // icon
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor:
          Color(0xFF5D9EFF)), //box tombol daftar dn masuk (birugelap)
  textTheme: const TextTheme(
    bodyText1:
        TextStyle(color: Color.fromARGB(255, 21, 30, 41)), //text deskripsi
  ),
  backgroundColor: Color.fromARGB(255, 194, 216, 238), //nav bawah
);
