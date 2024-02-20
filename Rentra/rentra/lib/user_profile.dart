// import 'package:flutter/material.dart';
// import 'app_bar.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'custom_scaffold.dart';
// import 'package:http/http.dart' as http;
// import 'main.dart';


// class UserProfile extends StatefulWidget {
//   const UserProfile({Key? key}) : super(key: key);

//   @override
//   _UserProfileState createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   File? _image;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserItemsRentedRenting();
//   }

// @override
// Widget build(BuildContext context) {
//   return CustomScaffold(
//     appBarTitle: 'Rentra',
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           GestureDetector(onTap: (){print('SHOW LIST OF ITEMS IM RENTING CURRENTLY');},
//           child: Text('Items Renting: $amountItemsRenting', style: const TextStyle(fontSize: 26))),
//           const SizedBox(height: 26),
//           GestureDetector(onTap: (){print('SHOW LIST OF ITEMS I HAVE FOR RENT');},
//           child: Text('Items Listed: $amountItemsListed', style: const TextStyle(fontSize: 26)),),
//           const SizedBox(height: 26),
//           GestureDetector(onTap: (){print('SHOW LIST OF ITEMS IM CURRENTLY RENTING TO OTHER PEOPLE');},
//           child: Text('Items Rented: $amountItemsRented', style: const TextStyle(fontSize: 26))),
//           if (nextReturnDate != null) ...[
//             const SizedBox(height: 26),
//             GestureDetector(onTap: (){print('SHOW NEXT RETURN ITEM');},
//             child: Text('Next Return Date: $nextReturnDate', style: const TextStyle(fontSize: 26))),
//           ]
//         ],
//       ),
//     ),
//     drawer: CommonDrawer(),
//   );
// }


//   Future<void> fetchUserItemsRentedRenting() async {
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String? token ='';
//       int? userId = 0;
//       if (pref.containsKey('userToken')) {
//         token = pref.getString('userToken')!;
//       }
//       if (pref.containsKey('userId')) {
//         userId = pref.getInt('userId')!;
//       }
//       print('TOKEN');
//       print('Token $token');
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/product/user'), 
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Token $token'
//         },
//         body: json.encode({
//           'user_id': userId,
//         }),
//       );
//       if (response.statusCode < 300) {
//         final Map<String, dynamic> responseBody = json.decode(response.body);
//         print(responseBody);
//         setState(() {
//           amountItemsRented = responseBody['products_rented'].length;
//           amountItemsRenting = responseBody['products_renting'].length;
//           amountItemsListed = responseBody['products'].length;
//         });
//       } else {
//         print('Failed to fetch user products');
//       }
//     } catch (error) {
//       print('Error fetching user products: $error');
//     }
//   }
// }
