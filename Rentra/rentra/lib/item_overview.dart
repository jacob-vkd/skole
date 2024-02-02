import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'main.dart';


class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  // List to store fetched products
  List<Product> products = [];

  // Function to fetch products from the Django API
  Future<void> fetchProducts() async {
    var token = await LoginPageState.getTokenFromPref();
    try {
      final response = await http.get(
      Uri.parse('$apiUrl/product/'),
      headers: {
        'Content-Type': 'application/json',
        'Authenticate': "Token $token"
      });

      if (response.statusCode < 300) {
        final List<dynamic> productData = json.decode(response.body);
        // Convert JSON data to Product objects
        List<Product> productList = productData.map((data) {
          print(data);
          var category_name = '';
          var category = data['category_id'];
          if (category != null){
            category_name = category['name'];
          }
          return Product(
            data['name'],
            data['description'],
            category_name,
            data['price_type'],
            data['image'],
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

Future<Image> convertFileToImage(File? picture) async {
  if (picture == null) {
    // Handle the case where the image is null
    // You might return a placeholder image or throw an error, depending on your requirements
    throw Exception('Image is null');
  }
  List<int> imageBase64 = picture.readAsBytesSync();
  String imageAsString = base64Encode(imageBase64);
  Uint8List uint8list = base64.decode(imageAsString);
  Image image = Image.memory(uint8list);
  return image;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Products'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          // var img = convertFileToImage(products[index].image);
          return ListTile(
            leading: FutureBuilder<Image>(
            future: convertFileToImage(products[index].image),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  backgroundImage: snapshot.data!.image,
                  radius: 5.0,
                );
              } else {
              // While the image is still loading, you can display a placeholder or a loading indicator
              return CircularProgressIndicator();
    }
  },
),
            title: Text(products[index].name),
            subtitle: Text(products[index].description),
            trailing: Text('\DKK${products[index].price.toStringAsFixed(2)} ${products[index].price_type}'),
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


class Product {
  final String name;
  final String description;
  final String category;
  final String price_type;
  final File? image;
  final double price;

  Product(this.name, this.description, this.category, this.price_type, this.image, this.price);
}