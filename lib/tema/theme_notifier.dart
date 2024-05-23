import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode getThemeMode() => _themeMode;

  ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
      // Definisi tema terang
      primaryColor: Colors.blue,
      hintColor: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.blue,
      ),
      // Tambahan atribut lainnya
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      // Definisi tema gelap
      primaryColor: Colors.black,
      hintColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        color: Colors.black,
      ),
      // Tambahan atribut lainnya
    );
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
