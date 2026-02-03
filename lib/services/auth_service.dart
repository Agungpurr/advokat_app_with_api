import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _currentUserKey = 'current_user';

  // 🔧 FIX: Ganti dengan URL yang sama seperti api_service.dart
  static const String baseUrl = 'http://10.0.2.2:3000';
  // Untuk Android Emulator: http://10.0.2.2:3000
  // Untuk iOS Simulator: http://localhost:3000
  // Untuk Device fisik: http://YOUR_IP_ADDRESS:3000

  // Inisialisasi
  Future<void> initialize() async {
    final token = await getToken();
    if (token != null) {
      print('✅ Token ditemukan di local storage');
    } else {
      print('ℹ️ Tidak ada token tersimpan');
    }
  }

  // Register user baru
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String nama,
    String role = 'user',
  }) async {
    try {
      print('📤 Registering user: $username');

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'nama': nama,
          'role': role,
        }),
      );

      print('📡 Register response status: ${response.statusCode}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {'success': true, 'message': 'Registrasi berhasil'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal'
        };
      }
    } catch (e) {
      print('❌ Register error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Login dengan API
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔐 Attempting login for: $username');
      print('📡 Connecting to: $baseUrl/api/auth/login');

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('📡 Login response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Backend response format: { success, message, data: { token, user } }
        final token = data['data']?['token'];
        final userData = data['data']?['user'];

        if (token == null) {
          throw Exception('Token tidak ditemukan dalam response');
        }

        // Simpan token dan user data
        await saveToken(token);
        await _saveCurrentUser(User.fromJson(userData));

        print('✅ Login berhasil, token disimpan');

        return {
          'success': true,
          'message': 'Login berhasil',
          'user': User.fromJson(userData),
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_currentUserKey);
    print('🚪 User logged out, token removed');
  }

  // Get current user (cek session)
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);

    if (userJson == null) return null;

    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      print('❌ Error parsing user: $e');
      return null;
    }
  }

  // Check apakah user sudah login
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Simpan token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    // Simpan juga dengan key 'token' untuk kompatibilitas dengan api_service.dart
    await prefs.setString('token', token);
    print('💾 Token saved: ${token.substring(0, min(20, token.length))}...');
  }

  // Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // Coba ambil dari kedua key untuk kompatibilitas
    final token = prefs.getString(_tokenKey) ?? prefs.getString('token');
    if (token != null) {
      print(
          '🔑 Token retrieved: ${token.substring(0, min(20, token.length))}...');
    } else {
      print('⚠️ No token found in storage');
    }
    return token;
  }

  // Verify token (opsional - untuk cek apakah token masih valid)
  Future<bool> verifyToken() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Token verification error: $e');
      return false;
    }
  }

  // Private method
  Future<void> _saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_currentUserKey, userJson);
  }

  // Get headers with token (untuk digunakan di API calls lain)
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}

// Helper function untuk mencegah error substring
int min(int a, int b) => a < b ? a : b;
