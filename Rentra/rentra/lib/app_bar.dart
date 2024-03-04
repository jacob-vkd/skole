import 'package:flutter/material.dart';
import 'package:rentra/home.dart';
import 'main.dart';
import 'settings.dart';
import 'product_create.dart';
import 'product_overview.dart';
import 'theme_notifier.dart';

class RentraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ThemeNotifier themeNotifier; // Add themeNotifier field

  const RentraAppBar(
      {Key? key, required this.title, required this.themeNotifier})
      : super(key: key);

  static const Color backgroundColor = Color.fromARGB(255, 120, 201, 62);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor:
          themeNotifier.value == ThemeMode.dark ? Colors.blue : Colors.white,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }
}

class CommonDrawer extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  const CommonDrawer({Key? key, required this.themeNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(themeNotifier: themeNotifier,)),
              );
            },
          ),
          ListTile(
            title: const Text('Rent an Item'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductList(themeNotifier: themeNotifier,)),
              );
            },
          ),
          ListTile(
            title: const Text('Rent Out an Item'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RentOutPage(themeNotifier: themeNotifier)),
              );
            },
          ),
          ListTile(
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(themeNotifier: themeNotifier)),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              LoginPageState.logout(context);
            },
          ),
        ],
      ),
    );
  }
}
