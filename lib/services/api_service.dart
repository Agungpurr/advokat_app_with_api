// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Ganti dengan IP server Anda atau domain
  // static const String baseUrl = 'http://localhost:3000/api';
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  // Untuk Android Emulator: http://10.0.2.2:3000/api
  // Untuk iOS Simulator: http://localhost:3000/api
  // Untuk Device fisik: http://YOUR_IP_ADDRESS:3000/api

  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Remove token from SharedPreferences
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // GET request
  Future<http.Response> get(String endpoint,
      {bool requiresAuth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT request
  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE request
  Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Login and save token
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await post('/auth/login', {
        'username': username,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        // Save token
        await _saveToken(data['data']['token']);
        return {
          'success': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String nama,
    String role = 'user',
  }) async {
    try {
      final response = await post('/auth/register', {
        'username': username,
        'email': email,
        'password': password,
        'nama': nama,
        'role': role,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success']) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    await _removeToken();
  }

  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await get('/auth/me', requiresAuth: true);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }
}
