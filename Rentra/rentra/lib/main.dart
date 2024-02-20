import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'custom_scaffold.dart';
import 'settings.dart';

const String apiUrl = 'http://127.0.0.1:8000';
dynamic globaluser;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  
  static bool darkmode = false;
  final ThemeMode _themeMode = ThemeMode.system;

  

  @override
  Widget build(BuildContext context) {
    final ThemeData rentraTheme = darkmode ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: const LoginPage(),
    );
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
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
  

  Future<void> login() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String username = _emailController.text;
      String password = _passwordController.text;

      final response = await http.post(
        Uri.parse('$apiUrl/api/login/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      // print('Response body: ${response.body}');
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        prefs.setString('userToken', responseBody['token']);
        int? userId = responseBody['user']['id'];
        prefs.setInt('userId', userId!);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
        print('Login successful');
      } else {
        // Handle login error
        print('Login failed with status: ${response.statusCode}');
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

  Future<void> createUser() async {
    try {
      String username = _emailController.text;
      String password = _passwordController.text;
      final pref = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$apiUrl/api/login/create_user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      // print('Response body: ${response.body}');
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        pref.setString('userToken', responseBody['token']);
        int? userId = responseBody['user']['id'];
        pref.setInt('userId', userId!);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
        print('Create account successful');
      } else {
        // Handle login error
        print('Create account failed with status: ${response.statusCode}');
        // Access the 'message' key
        final errorMessage = responseBody['message'];
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text(errorMessage.toString()),
        ),
        );
      }
    } catch (error) {
      // Handle exceptions
      print('Error during create account: $error');
    }
  }

static Future<void> logout(BuildContext context) async {
  final pref = await SharedPreferences.getInstance();
  String? token ='';
  if (pref.containsKey('userToken')) {
      token = pref.getString('userToken')!;
    }
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/api/logout/'),
      headers: {
        'Content-Type': 'application/json',
        'Authenticate': "Token $token"
      },
    );

    if (response.statusCode == 200) {
      // Handle successful logout response
      print('Logout successful');

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()),);
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

static Future<String> getTokenFromPref() async {
  final prefs = await SharedPreferences.getInstance();
  String token = '';
  if (prefs.containsKey('userToken')) {
    token = prefs.getString('userToken')!;
    } 
  else {
    throw Exception('User is not authenticated');
    }
  return token;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: '',
      body: Center(
        // padding: const EdgeInsets.all(16.0),
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
              onPressed: () => createUser(),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
