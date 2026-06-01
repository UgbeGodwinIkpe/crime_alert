import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    loadTheme();
  }

  // LOAD SAVED THEME
  Future<void> loadTheme() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    _isDarkMode =
        prefs.getBool("darkMode") ?? false;

    notifyListeners();
  }

  // TOGGLE THEME
  Future<void> toggleTheme(bool value) async {

    _isDarkMode = value;

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      "darkMode",
      value,
    );

    notifyListeners();
  }
}