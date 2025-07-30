// lib/services/flashcard_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- ADD THIS
import '../models/flashcard.dart'; // Assuming you have a Flashcard model
import 'secure_storage_service.dart';
import '../providers/auth_provider.dart'; // <--- ADD THIS to access secureStorageServiceProvider

class FlashcardApiService {
  final String baseUrl = 'YOUR_BASE_API_URL';
  final SecureStorageService _secureStorageService;

  FlashcardApiService(this._secureStorageService);

  // Helper to get authenticated headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _secureStorageService.getJwt();
    if (token == null) {
      throw Exception('JWT token not found. User is not authenticated.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Create Flashcard
  Future<Flashcard?> createFlashcard(String question, String answer) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/flashcard/create'),
      headers: headers,
      body: jsonEncode({'question': question, 'answer': answer}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Flashcard.fromJson(data); // Adjust based on your API response
    } else if (response.statusCode == 401) {
      // Handle unauthorized (e.g., token expired/invalid)
      throw Exception('Unauthorized: Token expired or invalid.');
    } else {
      print('Create flashcard failed: ${response.body}');
      return null;
    }
  }

  // Read Flashcards (Paginated)
  Future<List<Flashcard>> readFlashcards(int page, int pageSize) async {
    final headers = await _getAuthHeaders();
    final uri = Uri.parse('$baseUrl/flashcard/read?page=$page&pageSize=$pageSize');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Flashcard.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired or invalid.');
    } else {
      print('Read flashcards failed: ${response.body}');
      return [];
    }
  }

  // Read Random Flashcard
  Future<Flashcard?> readRandomFlashcard() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(Uri.parse('$baseUrl/flashcard/read/random'), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Flashcard.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired or invalid.');
    } else {
      print('Read random flashcard failed: ${response.body}');
      return null;
    }
  }

  // Update One Flashcard
  Future<Flashcard?> updateFlashcard(String id, String question, String answer) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/flashcard/update/one/$id'),
      headers: headers,
      body: jsonEncode({'question': question, 'answer': answer}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Flashcard.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired or invalid.');
    } else {
      print('Update flashcard failed: ${response.body}');
      return null;
    }
  }
}

final flashcardApiServiceProvider = Provider((ref) =>
    FlashcardApiService(ref.read(secureStorageServiceProvider)));