import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_scaffold.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int amountItemsRented = 0;
  int amountItemsRenting = 0;
  int amountItemsListed = 0;
  DateTime? nextReturnDate;

  @override
  void initState() {
    super.initState();
    fetchUserItemsRentedRenting();
  }

@override
Widget build(BuildContext context) {
  return CustomScaffold(
    appBarTitle: 'Rentra',
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Items Renting: $amountItemsRenting', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Text('Items Listed: $amountItemsListed', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Text('Items Rented: $amountItemsRented', style: TextStyle(fontSize: 18)),
          if (nextReturnDate != null) ...[
            SizedBox(height: 20),
            Text('Next Return Date: $nextReturnDate', style: TextStyle(fontSize: 18)),
          ]
        ],
      ),
    ),
    drawer: CommonDrawer(),
  );
}

  Future<void> fetchUserItemsRentedRenting() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String? token ='';
      int? userId = 0;
      if (pref.containsKey('userToken')) {
        token = pref.getString('userToken')!;
      }
      if (pref.containsKey('userId')) {
        userId = pref.getInt('userId')!;
      }
      final response = await http.post(
        Uri.parse('$apiUrl/api/product/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authenticate': "Token $token"
        },
        body: json.encode({
          'user_id': userId,
        }),
      );
      if (response.statusCode < 300) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody);
        setState(() {
          amountItemsRented = responseBody['products_renting'].length;
          amountItemsRenting = responseBody['products_rented'].length;
          amountItemsListed = responseBody['products'].length;
        });
      } else {
        print('Failed to fetch user products');
      }
    } catch (error) {
      print('Error fetching user products: $error');
    }
  }
}
