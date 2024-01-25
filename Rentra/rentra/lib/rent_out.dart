import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Product {
  String name;
  String description;
  String category;
  String priceType;
  double price;

  Product({
    required this.name,
    required this.description,
    required this.category,
    required this.priceType,
    required this.price,
  });
}

class RentOutPage extends StatefulWidget {
  const RentOutPage({super.key});

  @override
  _RentOutPageState createState() => _RentOutPageState();
}

class _RentOutPageState extends State<RentOutPage> {
  final _formKey = GlobalKey<FormState>();
  late Product _newProduct;
  File? _image;
  List<String> _categories = [];
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _newProduct = Product(
      name: '',
      description: '',
      category: '',
      priceType: '',
      price: 0.0,
    );
    fetchCategories();
  }

Future<void> fetchCategories() async {
  final response = await http.get(Uri.parse('$apiUrl/product/categories/'));

  print(response.statusCode);
  print('$apiUrl/product/categories/');
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    // Assuming 'categories' is the key containing the list of categories
    final List<dynamic> categoryData = responseData['categories'];

    print(categoryData);
    List<String> categoryList = [for (var category in categoryData) category['name'] as String];
    print(categoryList);
    setState(() {
      _categories = categoryList;
      _selectedCategory = _categories.isNotEmpty ? _categories[0] : '';
    });
  } else {
    // Handle error
    print('Failed to load categories');
  }
}


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Out'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TextFormFields for each property of the product
              TextFormField(
                decoration: const InputDecoration(labelText: 'Item Name'),
                onChanged: (value) {
                  setState(() {
                    _newProduct.name = value;
                  });
                },
                // Add any validation you need
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    _newProduct.description = value;
                  });
                },
                // Add any validation you need
              ),
               DropdownButtonFormField<String>(
                value: _selectedCategory, // Use the selected category
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                    _newProduct.category = _selectedCategory; // Update the selected category
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price Type'),
                onChanged: (value) {
                  setState(() {
                    _newProduct.priceType = value;
                  });
                },
                // Add any validation you need
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                onChanged: (value) {
                  setState(() {
                    _newProduct.price = double.tryParse(value) ?? 0.0;
                  });
                },
                // Add any validation you need
              ),
            _image == null
            ? Text('No image selected.')
                : Image.file(
                    _image!,
                    height: 200.0,
                  ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, submit the product
                    _submitProduct();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitProduct() async {
    // Handle submitting the product data.
    print('New Productasdasdasd');
    print('${_newProduct.name} ${_newProduct.description} ${_newProduct.category}, ${_newProduct.price}, ${_newProduct.priceType}');

    var category = int.tryParse(_newProduct.category);
    final response = await http.post(
      Uri.parse('$apiUrl/product/create/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': _newProduct.name,
        'description': _newProduct.description,
        'category_id': category,
        'price_type': _newProduct.priceType,
        'price': _newProduct.price
      }),
    );
    if (response.statusCode < 300) {
      // Navigate to the Home Screen
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text('Your item has been listed'),
      ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),);
    } else {
      // Handle product creation error
      print('Create product failed with code: ${response.statusCode}');
    }
  }


}

