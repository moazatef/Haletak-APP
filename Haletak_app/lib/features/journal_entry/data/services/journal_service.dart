// lib/features/journal/data/services/journal_service.dart
import 'dart:convert';

import 'package:aluna/features/auth/data/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/journal_entry.dart';

class JournalService {
  final String baseUrl = 'https://finalchat-production.up.railway.app/api';

  final String token;

  final int defaultUserId;

  JournalService({
    required this.token,
    this.defaultUserId = 2,
  });

  Future<Journal> createJournal(Journal journal) async {
    final url = '$baseUrl/text';

    final requestData = {
      'title': journal.title,
      'text': journal.text,
      'users_id': journal.userId ?? defaultUserId,
    };

    debugPrint('Creating journal at URL: $url');
    debugPrint('Request body: ${jsonEncode(requestData)}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: jsonEncode(requestData),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] != null) {
          return Journal.fromJson(responseData['data']);
        } else {
          return journal.copyWith(id: responseData['id']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to create journal: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error creating journal: $e');
      rethrow;
    }
  }

  // Update the getJournals method in JournalService
  Future<List<Journal>> getJournals() async {
    try {
      final id = await AuthService().getUserId();
      if (id == null) throw Exception('User not logged in');

      final url = '$baseUrl/text/$id'; // Use dynamic user ID

      debugPrint('Headers being sent: ${_getHeaders()}');
      debugPrint('Request URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: _getHeaders(),
      );

      debugPrint('Get journals response: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] != null) {
          List<dynamic> journalsJson = responseData['data'];
          return journalsJson.map((json) => Journal.fromJson(json)).toList();
        } else {
          return [];
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load journals: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching journals: $e');
      rethrow;
    }
  }

  // Update an existing journal entry
  Future<Journal> updateJournal(
      // ignore: non_constant_identifier_names
      int user_id,
      int entryId,
      Journal journal) async {
    final requestData = {
      'title': journal.title,
      'text': journal.text,
      'users_id': user_id,
    };

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/text/$user_id/$entryId'),
        headers: _getHeaders(),
        body: jsonEncode(requestData),
      );

      debugPrint('Update journal response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] != null) {
          return Journal.fromJson(responseData['data']);
        } else {
          return journal;
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to update journal: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating journal: $e');
      rethrow;
    }
  }

  // Delete a journal entry
  // ignore: non_constant_identifier_names
  Future<bool> deleteJournal(int id, int entry_id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/text/$id/$entry_id'),
        headers: _getHeaders(),
      );

      debugPrint('Delete journal response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to delete journal: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting journal: $e');
      rethrow;
    }
  }

  // Get a single journal entry
  Future<Journal> getJournalById(int userId, int journalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/store/$userId/$journalId'),
        headers: _getHeaders(),
      );

      debugPrint('Get journal by ID response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] != null) {
          return Journal.fromJson(responseData['data']);
        } else {
          throw Exception('Journal data not found in response');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to get journal: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error getting journal by ID: $e');
      rethrow;
    }
  }

  // Helper to get standard headers for all requests
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Debug method for testing API endpoints
  Future<void> debugEndpoints() async {
    // Check base API
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _getHeaders(),
      );
      debugPrint('DEBUG - Base API response: ${response.statusCode}');
      debugPrint('DEBUG - Body: ${response.body}');
    } catch (e) {
      debugPrint('DEBUG - Error accessing base API: $e');
    }

    // Check store endpoint
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/store'),
        headers: _getHeaders(),
      );
      debugPrint('DEBUG - Store API response: ${response.statusCode}');
      debugPrint('DEBUG - Body: ${response.body}');
    } catch (e) {
      debugPrint('DEBUG - Error accessing store API: $e');
    }

    // Check user journals endpoint with default user
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/store/$defaultUserId'),
        headers: _getHeaders(),
      );
      debugPrint('DEBUG - User journals response: ${response.statusCode}');
      debugPrint('DEBUG - Body: ${response.body}');
    } catch (e) {
      debugPrint('DEBUG - Error accessing user journals: $e');
    }
  }

  // Verify token is working by making a simple authenticated request
  Future<bool> verifyToken() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _getHeaders(),
      );
      return response.statusCode != 401;
    } catch (e) {
      debugPrint('Error verifying token: $e');
      return false;
    }
  }
}
