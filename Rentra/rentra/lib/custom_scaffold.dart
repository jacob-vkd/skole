import 'package:flutter/material.dart';
import 'package:rentra/app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String appBarTitle;
  final CommonDrawer? drawer;

  const CustomScaffold({Key? key, required this.body, required this.appBarTitle, this.drawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.lightBlue,
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: body), // Take remaining space
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            width: double.infinity,
            child: FractionallySizedBox(
              widthFactor: 1.0, // Take full width
              heightFactor: 1.0,
              child: Container(
                color: Colors.lightBlue,
              ),
            ),
          ),
        ],
      ),
      drawer: drawer,
    );
  }
}
