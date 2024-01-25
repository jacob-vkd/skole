import 'package:flutter/material.dart';
import 'main.dart';
import 'rent_out.dart';

class RentraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  static const Color backgroundColor = Color.fromARGB(255, 120, 201, 62);

  const RentraAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.blue,
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
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
            ListTile(
              title: const Text('Rent an Item'),
              onTap: () {
                Navigator.pop(context);
              },
            ), 
            ListTile(
              title: const Text('Rent Out an Item'),
              onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RentOutPage()),
                  );
                // Navigator.pop(context);
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
              },
          ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await LoginPageState.logout(context);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

