import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  const SettingsPage({Key? key, required this.themeNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize settings before building the UI

    return Scaffold(
      appBar: null,
      body: SettingsScreen(
        children: [
          SwitchSettingsTile(
            settingKey: 'key-dark-mode',
            title: 'Dark Mode',
            defaultValue: false,
            onChange: (value) {
              themeNotifier
                  .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
    );
  }

  // Input: None
  // Return: Bool
  static Future<bool?> getSettingsPref() async {
    final prefs = await SharedPreferences.getInstance();
    bool? darkMode = false;
    if (prefs.containsKey('key-dark-mode')) {
      darkMode = prefs.getBool('key-dark-mode');
    }
    return darkMode;
  }

  static Future<String> getTokenFromPref() async {
    final prefs = await SharedPreferences.getInstance();
    String token = '';
    if (prefs.containsKey('userToken')) {
      token = prefs.getString('userToken')!;
    } else {
      throw Exception('User is not authenticated');
    }
    return token;
  }
}
