import 'package:flutter/material.dart';
import 'package:rentra/app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String appBarTitle;
  final CommonDrawer? drawer;

  const CustomScaffold({super.key, required this.body, required this.appBarTitle, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.lightBlue,
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
      ),
      body: body,
      drawer: drawer,
      bottomSheet:FractionallySizedBox(
    widthFactor: 100.0,
    heightFactor: 0.07,
    child: Container(
      color: Colors.lightBlue,
    ),
  ),
    );
  }
}