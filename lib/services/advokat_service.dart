// lib/services/advokat_service.dart (WITH DEBUG LOGGING + AUTH TOKEN)
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/advokat_model.dart';

class AdvokatService {
  // Sesuaikan dengan IP komputer Anda jika test di device fisik
  // Gunakan 10.0.2.2 untuk Android Emulator
  // Gunakan localhost atau 127.0.0.1 untuk iOS Simulator
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Untuk device fisik, ganti dengan IP komputer Anda:
  // static const String baseUrl = 'http://192.168.x.x:3000/api';

  // 🔥 ADDED: Helper method untuk mendapatkan token
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(
          '🔑 Retrieved token: ${token != null ? "exists (${token.length} chars)" : "null"}');
      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  // 🔥 ADDED: Helper method untuk membuat headers dengan token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print('✅ Added Authorization header');
    } else {
      print('⚠️ No token found - request may fail if auth required');
    }

    return headers;
  }

  Future<List<Advokat>> getAllAdvokat({String? kota, String? bidang}) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (kota != null) queryParams['kota'] = kota;
      if (bidang != null) queryParams['bidang'] = bidang;

      final uri = Uri.parse('$baseUrl/advokat')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      print('🔍 Fetching advokat from: $uri'); // DEBUG

      // 🔥 CHANGED: Use _getHeaders() instead of hardcoded headers
      final headers = await _getHeaders();

      final response = await http.get(uri, headers: headers);

      print('📡 Response status: ${response.statusCode}'); // DEBUG
      print('📦 Response body: ${response.body}'); // DEBUG

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        print('✅ JSON decoded successfully'); // DEBUG
        print('🔑 JSON keys: ${jsonResponse.keys}'); // DEBUG

        // Handle different response structures
        List<dynamic> advokatList;

        if (jsonResponse.containsKey('data')) {
          advokatList = jsonResponse['data'] as List;
          print(
              '📋 Data from "data" key: ${advokatList.length} items'); // DEBUG
        } else if (jsonResponse.containsKey('advokat')) {
          advokatList = jsonResponse['advokat'] as List;
          print(
              '📋 Data from "advokat" key: ${advokatList.length} items'); // DEBUG
        } else if (jsonResponse is List) {
          advokatList = jsonResponse as List;
          print('📋 Data is direct list: ${advokatList.length} items'); // DEBUG
        } else {
          print('❌ Unexpected response structure: $jsonResponse'); // DEBUG
          return [];
        }

        final result = advokatList
            .map((json) {
              try {
                return Advokat.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('❌ Error parsing advokat: $e');
                print('   JSON: $json');
                return null;
              }
            })
            .whereType<Advokat>()
            .toList();

        print('✅ Successfully parsed ${result.length} advokat'); // DEBUG
        return result;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401) - Token invalid or missing'); // DEBUG
        throw Exception('Unauthorized - Please login again');
      } else {
        print('❌ Error response: ${response.statusCode}'); // DEBUG
        print('   Body: ${response.body}'); // DEBUG
        throw Exception('Failed to load advokat: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('💥 Exception in getAllAdvokat: $e'); // DEBUG
      print('   Stack trace: $stackTrace'); // DEBUG
      rethrow;
    }
  }

  Future<Advokat> getAdvokatById(String id) async {
    try {
      print('🔍 Fetching advokat by ID: $id'); // DEBUG

      // 🔥 CHANGED: Use _getHeaders()
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/advokat/$id'),
        headers: headers,
      );

      print('📡 Response status: ${response.statusCode}'); // DEBUG

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Handle different response structures
        Map<String, dynamic> advokatData;

        if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          advokatData = jsonResponse['data'] as Map<String, dynamic>;
        } else if (jsonResponse is Map && jsonResponse.containsKey('advokat')) {
          advokatData = jsonResponse['advokat'] as Map<String, dynamic>;
        } else {
          advokatData = jsonResponse as Map<String, dynamic>;
        }

        return Advokat.fromJson(advokatData);
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401)'); // DEBUG
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to load advokat: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Exception in getAdvokatById: $e'); // DEBUG
      rethrow;
    }
  }

  Future<Advokat> createAdvokat(Advokat advokat) async {
    try {
      print('📤 Creating advokat: ${advokat.nama}'); // DEBUG

      final body = json.encode(advokat.toJson());
      print('📦 Request body: $body'); // DEBUG

      // 🔥 CHANGED: Use _getHeaders() - THIS FIXES YOUR 401 ERROR!
      final headers = await _getHeaders();

      final response = await http.post(
        Uri.parse('$baseUrl/advokat'),
        headers: headers,
        body: body,
      );

      print('📡 Response status: ${response.statusCode}'); // DEBUG
      print('📦 Response body: ${response.body}'); // DEBUG

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        // Handle different response structures
        Map<String, dynamic> advokatData;

        if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          advokatData = jsonResponse['data'] as Map<String, dynamic>;
        } else if (jsonResponse is Map && jsonResponse.containsKey('advokat')) {
          advokatData = jsonResponse['advokat'] as Map<String, dynamic>;
        } else {
          advokatData = jsonResponse as Map<String, dynamic>;
        }

        print('✅ Advokat created successfully'); // DEBUG
        return Advokat.fromJson(advokatData);
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401) - Token missing or invalid'); // DEBUG
        final errorBody = json.decode(response.body);
        throw Exception(
            'Unauthorized: ${errorBody['message'] ?? 'Please login again'}');
      } else {
        print('❌ Failed to create advokat: ${response.statusCode}'); // DEBUG
        throw Exception('Failed to create advokat: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in createAdvokat: $e'); // DEBUG
      rethrow;
    }
  }

  // lib/services/advokat_service.dart - FIXED UPDATE METHOD

  Future<Advokat> updateAdvokat(String id, Advokat advokat) async {
    try {
      print('📝 Updating advokat ID: $id');

      // 🔥 CRITICAL FIX: Pastikan ID tidak di-include dalam body JSON
      final bodyMap = advokat.toJson();
      bodyMap.remove('id'); // Remove ID dari body, karena sudah ada di URL

      final body = json.encode(bodyMap);
      print('📦 Request body: $body');

      final headers = await _getHeaders();

      final response = await http.put(
        Uri.parse('$baseUrl/advokat/$id'),
        headers: headers,
        body: body,
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Handle different response structures
        Map<String, dynamic> advokatData;

        if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          advokatData = jsonResponse['data'] as Map<String, dynamic>;
          print('✅ Got advokat data from "data" key');
        } else if (jsonResponse is Map && jsonResponse.containsKey('advokat')) {
          advokatData = jsonResponse['advokat'] as Map<String, dynamic>;
          print('✅ Got advokat data from "advokat" key');
        } else if (jsonResponse is Map) {
          advokatData = jsonResponse as Map<String, dynamic>;
          print('✅ Using response directly as advokat data');
        } else {
          // Jika tidak ada data dalam response, fetch ulang
          print('⚠️ No data in response, fetching updated advokat...');
          return await getAdvokatById(id);
        }

        return Advokat.fromJson(advokatData);
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401)');
        throw Exception('Unauthorized - Please login again');
      } else if (response.statusCode == 404) {
        print('❌ Not Found (404)');
        throw Exception('Advokat not found');
      } else {
        final errorBody = response.body;
        print('❌ Failed to update: $errorBody');

        // Parse error message if available
        try {
          final errorJson = json.decode(errorBody);
          final errorMessage =
              errorJson['message'] ?? errorJson['error'] ?? 'Update failed';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Failed to update advokat: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('💥 Exception in updateAdvokat: $e');
      rethrow;
    }
  }

  Future<void> deleteAdvokat(String id) async {
    try {
      print('🗑️ Deleting advokat ID: $id'); // DEBUG

      // 🔥 CHANGED: Use _getHeaders()
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse('$baseUrl/advokat/$id'),
        headers: headers,
      );

      print('📡 Response status: ${response.statusCode}'); // DEBUG

      if (response.statusCode == 200) {
        print('✅ Advokat deleted successfully');
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401)'); // DEBUG
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to delete advokat: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in deleteAdvokat: $e'); // DEBUG
      rethrow;
    }
  }
}
