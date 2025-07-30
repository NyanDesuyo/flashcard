import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart'; // Assuming you have a User model

class AuthApiService {
  final String baseUrl = 'http://192.168.100.11:8080'; // e.g., 'https://your-api.com'

  // Register
  Future<User?> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']); // Adjust based on your API response
    } else {
      // Handle errors (e.g., email already exists)
      print('Registration failed: ${response.body}');
      return null;
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // Assuming your API returns { "token": "jwt_string" }
    } else {
      // Handle errors (e.g., invalid credentials)
      print('Login failed: ${response.body}');
      return null;
    }
  }
}