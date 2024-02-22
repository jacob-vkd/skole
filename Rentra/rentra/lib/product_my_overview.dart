import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'custom_scaffold.dart';
import 'product_overview.dart';

class MyProductList extends StatefulWidget {
  const MyProductList({super.key});

  @override
  _MyProductListState createState() => _MyProductListState();
}

class _MyProductListState extends State<MyProductList> {
  // List to store fetched products
  List<Product> products = [];

  // Function to fetch products from the Django API
  Future<void> fetchProducts() async {
    var token = await LoginPageState.getTokenFromPref();
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/product/'),
          headers: {
            'Content-Type': 'application/json',
            'Authenticate': "Token $token"
          });

      if (response.statusCode < 300) {
        final List<dynamic> productData =
            json.decode(utf8.decode(response.bodyBytes));
        // Convert JSON data to Product objects
        List<Product> productList = productData.map((data) {
          print(data);
          return Product(
            data['name'],
            data['description'],
            data['category_id'].toString(),
            data['price_type'],
            data['image'] ?? '/media/images/r.png',
            double.parse(data['price'].toString()),
          );
        }).toList();

        setState(() {
          products = productList;
        });
      } else {
        print('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch products when the widget is initialized
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'My Listings',
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('$apiUrl/${products[index].image}'),
              radius: 30.0,
            ),
            title: Text(products[index].name),
            subtitle: Text(products[index].description),
            trailing: Text(
                'DKK${products[index].price.toStringAsFixed(2)} ${products[index].price_type}'),
            onTap: () {
              // Handle product selection (navigate to details page, etc.)
              print('Selected product: ${products[index].name}');
            },
          );
        },
      ),
    );
  }
}
