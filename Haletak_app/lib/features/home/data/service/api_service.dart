// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../model/user_model.dart';

// Future<User> fetchUserFromApi() async {
//   const String apiUrl = ''; 

//   try {
//     final response = await http.get(Uri.parse(apiUrl));

//     // Check for success response
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//       return User.fromJson(data); 
//     } else {
//       throw Exception("Failed to load user data: ${response.reasonPhrase}");
//     }
//   } catch (e) {
//     throw Exception("Error fetching user data: $e");
//   }
// }
