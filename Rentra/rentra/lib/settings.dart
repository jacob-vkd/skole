import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  static const keyDarkMode = 'key-dark-mode';

  @override
  Widget build(BuildContext context) {
    // Initialize settings before building the UI
    Settings.init();

    return Scaffold(
      appBar: null,
      body: SettingsScreen(
        children: [
          SwitchSettingsTile(
            settingKey: keyDarkMode,
            title: 'Dark Mode',
            defaultValue: false,
            onChange: (value) {
              print('Dark mode switched: $value');
              // You can perform any actions here based on the switch value
            },
          ),
        ],
      ),
    );
  }
}
