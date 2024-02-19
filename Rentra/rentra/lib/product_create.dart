import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'custom_scaffold.dart';

class Product {
  String name;
  String description;
  String category;
  String priceType;
  double price;
  int userId;

  Product({
    required this.name,
    required this.description,
    required this.category,
    required this.priceType,
    required this.price,
    required this.userId,
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
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _priceTypes = [];
  String _selectedCategory = '';
  String _selectedpriceType = '';

  @override
  void initState() {
    super.initState();
    _newProduct = Product(
      name: '',
      description: '',
      category: '',
      priceType: '',
      price: 0.0,
      userId: 0,
    );
    fetchCategories();
    fetchPriceTypes();
  }

  Future<void> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/api/product/categories/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body);
        final List<dynamic> categoryData = responseData['categories'];

        List<Map<String, dynamic>> categoryList = [
          for (var category in categoryData)
            {'id': category['id'], 'name': category['name'] as String}
        ];
        setState(() {
          _categories = categoryList;
          _selectedCategory =
              _categories.isNotEmpty ? _categories[0]['name'] : '';
          _newProduct.category = _selectedCategory;
        });
      } else {
        print('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

Future<void> fetchPriceTypes() async {
  try {
    final response = await http.get(Uri.parse('$apiUrl/api/product/pricetype'));
    print(apiUrl);
    if (response.statusCode < 300) {
      final List<dynamic> responseData = json.decode(response.body);
      // Assuming responseData is a list of price types
      List<Map<String, dynamic>> priceTypeList = [
        for (var priceType in responseData)
          {'id': priceType['id'], 'name': priceType['name'] as String}
      ];
      setState(() {
        _priceTypes = priceTypeList;
        _selectedpriceType = priceTypeList.isNotEmpty ? _priceTypes[0]['name'] : '';
        _newProduct.priceType = _selectedpriceType;
      });
    } else {
      print('Failed to load price types');
    }
  } catch (error) {
    print('Error fetching price types: $error');
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
    return CustomScaffold(
      appBarTitle: 'Rent Out An Item',
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
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['name'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value ?? '';
                      _newProduct.category = _selectedCategory;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedpriceType,
                  items: _priceTypes.map((priceType) {
                    return DropdownMenuItem<String>(
                      value: priceType['name'],
                      child: Text(priceType['name']),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedpriceType = value ?? '';
                      _newProduct.priceType = _selectedpriceType;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Price Type'),
                ),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Price Type'),
              //   onChanged: (value) {
              //     setState(() {
              //       _newProduct.priceType = value;
              //     });
              //   },
              //   // Add any validation you need
              // ),
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
                  ? const Text('No image selected.')
                  : Image.file(
                      _image!,
                      height: 200.0,
                    ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
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
  final prefs = await SharedPreferences.getInstance();
  String? token;
  int? userId;
  if (prefs.containsKey('userToken')) {
    token = prefs.getString('userToken')!;
  } else {
    throw Exception('User is not authenticated');
  }
  if (prefs.containsKey('userId')) {
    userId = prefs.getInt('userId')!;
  }
  try {
    // Handle submitting the product data.
    final categoryId = await getCatId(_newProduct.category);

    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/api/product/create/'),
    );

    // Set headers
    request.headers['Authenticate'] = 'Token $token';

    // Create a map for fields
    var fieldsMap = {
      'name': _newProduct.name,
      'description': _newProduct.description,
      'category_id': categoryId.toString(), // Convert to String
      'price_type': _newProduct.priceType,
      'price': _newProduct.price.toString(), // Convert to String
      'user_id': userId.toString(), // Convert to String
    };
    var stringFieldsMap = Map<String, String>.from(fieldsMap);

    // Add fields to the request
    request.fields.addAll(stringFieldsMap);

    // Add the image file to the request
    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType('image', 'png'), // Adjust the content type as needed
        ),
      );
    }

    // Send the request
    var response = await request.send();

    // Check the response status
    if (response.statusCode < 300) {
      // Successfully uploaded
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your item has been listed'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Handle product creation error
      print('Create product failed with code: ${response.statusCode}');
    }
  } catch (error) {
    // Handle exceptions
    print('Error during product submission: $error');
  }
}



Future<int> getCatId(String catString) async {
  final prefs = await SharedPreferences.getInstance();
  String? token;
  if (prefs.containsKey('userToken')) {
    token = prefs.getString('userToken')!;
  } else {
    throw Exception('User is not authenticated');
  }

  final response = await http.post(
    Uri.parse('$apiUrl/api/product/categories/'),
    headers: {
      'Content-Type': 'application/json',
      'Authenticate': 'Token $token',
    },
    body: json.encode({
      'name': catString,
    }),
  );
  final Map<String, dynamic> responseBody = json.decode(response.body);
  return responseBody['category_id'];
}
}