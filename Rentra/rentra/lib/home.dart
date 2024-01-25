import 'package:flutter/material.dart';
import 'app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
      child: Text('Welcome to Rentra'),
      ),
      drawer: const CommonDrawer()
    );
  }
}
