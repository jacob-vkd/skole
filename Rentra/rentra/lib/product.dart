import 'package:flutter/material.dart';
import 'custom_scaffold.dart';
import 'app_bar.dart';
import 'theme_notifier.dart';
import 'main.dart';
import 'home.dart';


class Product {
  final String name;
  final String description;
  final String category;
  final String price_type;
  final String image;
  final double price;

  Product(this.name, this.description, this.category, this.price_type, this.image, this.price);
}


class ProductView extends StatefulWidget {
  final ThemeNotifier themeNotifier; // Add themeNotifier field
  final Product product; // Define product as a field
  const ProductView({Key? key, required this.product, required this.themeNotifier})
      : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Product',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Image.network(
              '$apiUrl/${product.image}', // Provide the URL of the image here
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
            Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Description: ${product.description}'),
            Text('Category: ${product.category}'),
            Text('Price: ${product.price.toString()} DKK ${product.price_type}'),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    themeNotifier: widget.themeNotifier,
                  )),
        ),
              child: const Text('Rent'), 
            ),
            // Display other information about the product as needed
          ],
        ),
      ),
      drawer: CommonDrawer(
        themeNotifier: widget.themeNotifier,
      ),
    );
  }
}
