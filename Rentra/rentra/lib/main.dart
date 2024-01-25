import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home.dart';

const String apiUrl = 'http://127.0.0.1:8000/api';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

Future<String> getCsrfToken(String apiUrl) async {
  final response = await http.get(Uri.parse('$apiUrl/csrf_token/'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['csrf_token'];
  } else {
    throw Exception('Failed to fetch CSRF token');
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

Future<void> login({bool create_account=false}) async {
  try {
    String username = _emailController.text;
    String password = _passwordController.text;
    
    print(username);
    print(password);
    print(create_account);

    final csrfToken = await getCsrfToken(apiUrl);
    print(csrfToken);
    final response = await http.post(
      Uri.parse('$apiUrl/login/'),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': csrfToken,
      },
      body: json.encode({
        'username': username,
        'password': password,
        'createaccount': create_account,
      }),
    );

    if (response.statusCode == 200) {
      // Navigate to the Home Screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),);
      print('Login successful');
    } else {
      // Handle login error
      print('Login failed with status: ${response.statusCode}');
      // Parse the response body into a Map
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Access the 'message' key
      final errorMessage = responseBody['message'];
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(errorMessage),
      ),
      );
    }
  } catch (error) {
    // Handle exceptions
    print('Error during login: $error');
  }
}

static Future<void> logout(BuildContext context) async {
  try {
    final csrfToken = await getCsrfToken(apiUrl);
    print('TOKEN HERE');
    print(csrfToken);
    final response = await http.post(
      Uri.parse('$apiUrl/logout/'),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': csrfToken,
      },
      // Omit the request body for logout, as it's typically not required
    );

    if (response.statusCode == 200) {
      // Handle successful logout response
      print('Logout successful');

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()),);
    } else {
      // Handle logout error
      print('Logout failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    // Handle exceptions
    print('Error during logout: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Centered Header
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/rentralogo.png',
                height: 74.0,
                width: 200.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32.0),

            // Email TextField
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),

            // Password TextField
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            // Login Button
            ElevatedButton(
              onPressed: () => login(),
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => login(create_account: true),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}


