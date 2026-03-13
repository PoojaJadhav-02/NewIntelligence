
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider extends ChangeNotifier{

  final _storage = GetStorage();

  final _themeKey = 'isDarkMode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode  == ThemeMode.dark;

  ThemeProvider(){
    _loadTheme();
  }

  void setTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      _storage.write(_themeKey, true);
    } else {
      _themeMode = ThemeMode.light;
      _storage.write(_themeKey, false);
    }
    notifyListeners();
  }


  void _loadTheme(){
    final isDark = _storage.read(_themeKey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    log(' Theme Mode : $_themeMode');
    notifyListeners();
  }


  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white
      ),
      textTheme: const TextTheme(
          displayMedium: TextStyle(color: Colors.black)
      )
  );


  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black
      ),
      textTheme: const TextTheme(
          displayMedium: TextStyle(color: Colors.white)
      )
  );




}