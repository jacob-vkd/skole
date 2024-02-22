import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(ThemeMode value) : super(value);

  void setThemeMode(ThemeMode mode) {
    value = mode;
    saveThemeMode(mode);
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('key-dark-mode', mode == ThemeMode.dark);
  }

  Future<ThemeMode> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isDarkMode = prefs.getBool('key-dark-mode') ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
