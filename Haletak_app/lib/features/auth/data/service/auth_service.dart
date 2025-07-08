import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../model/auth_model.dart';

class AuthService {
  final String baseUrl = "https://finalchat-production.up.railway.app/api";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys for secure storage
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  // Login with API
  Future<Map<String, dynamic>?> login(LoginRequest request,
      {int maxRetries = 3}) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        final url = Uri.parse('$baseUrl/login');
        final response = await http
            .post(
              url,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(request.toJson()),
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData['user'] == null ||
              responseData['user']['id'] == null) {
            throw Exception('Server error: User data not provided');
          }

          if (responseData['token'] == null) {
            throw Exception('Server error: Token not provided');
          }

          await _storeUserData(
            token: responseData['token'],
            userId: responseData['user']['id'],
            name: responseData['user']['name'],
            email: responseData['user']['email'],
          );

          return {
            'name': responseData['user']['name'],
            'token': responseData['token'],
          };
        } else if (response.statusCode >= 500) {
          await Future.delayed(Duration(seconds: 1 * (attempt + 1)));
          attempt++;
          continue;
        } else {
          return null;
        }
      } on TimeoutException {
        if (attempt >= maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: 1 * (attempt + 1)));
        attempt++;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }

  // Register with API
  Future<bool> register(RegisterRequest request) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": request.name,
        "email": request.email,
        "password": request.password,
        "password_confirmation": request.password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['user'] == null || responseData['user']['id'] == null) {
        throw Exception(
            'Server error: User data not provided in registration response');
      }

      if (responseData['token'] == null) {
        throw Exception(
            'Server error: Token not provided in registration response');
      }

      await _storeUserData(
        token: responseData['token'],
        userId: responseData['user']['id'],
        name: responseData['user']['name'],
        email: responseData['user']['email'],
      );

      return true;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // Store all user data securely
  // Store all user data securely
  Future<void> _storeUserData({
    required String token,
    required int userId,
    required String name,
    required String email,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _userNameKey, value: name);
    await _storage.write(key: _userEmailKey, value: email);

    if (kDebugMode) {
      print('Stored user data:');
      print('User ID: $userId');
      print('Name: $name');
      print('Email: $email');
      final displayToken =
          token.length > 10 ? '${token.substring(0, 10)}...' : token;
      print('Token: $displayToken');
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get stored user ID
  Future<int?> getUserId() async {
    final id = await _storage.read(key: _userIdKey);
    return id != null ? int.tryParse(id) : null;
  }

  // Get stored user name
  Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  // Get stored user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // Clear all user data on logout
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userNameKey);
    await _storage.delete(key: _userEmailKey);
    await _auth.signOut();
    await _googleSignIn.signOut();

    if (kDebugMode) {
      print('User logged out - all auth data cleared');
    }
  }

  // Verify if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final loginType = await _storage.read(key: 'login_type');

    if (token == null || loginType == null) return false;

    if (loginType == 'firebase') {
      final firebaseUser = _auth.currentUser;
      return firebaseUser != null;
    }

    // Laravel login check
    final userId = await getUserId();
    return userId != null;
  }

  // Get complete user data
  Future<Map<String, dynamic>?> getUserData() async {
    if (!await isLoggedIn()) return null;

    final loginType = await _storage.read(key: 'login_type');

    if (loginType == 'firebase') {
      final user = _auth.currentUser;
      return {
        'id': 0,
        'name': user?.displayName ?? 'Firebase User',
        'email': user?.email ?? '',
        'token': 'firebase',
      };
    } else {
      // Laravel
      return {
        'id': await getUserId(),
        'name': await getUserName(),
        'email': await getUserEmail(),
        'token': await getToken(),
      };
    }
  }

  // Google Sign-In with Firebase
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // user canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Firebase user is null after Google sign-in');
      }

      // You can optionally get the Firebase ID token (not used here)
      final String? idToken = await firebaseUser.getIdToken();

      await _storeUserData(
        token: "firebase", // Mark this as a Firebase login
        userId: 0, // Or -1 if you want to clearly separate from Laravel users
        name: firebaseUser.displayName ?? 'Google User',
        email: firebaseUser.email ?? '',
      );

      // Optionally, store login method type
      await _storage.write(key: 'login_type', value: 'firebase');

      return firebaseUser;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }
}
