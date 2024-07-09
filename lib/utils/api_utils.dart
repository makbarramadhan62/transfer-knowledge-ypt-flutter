import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiUtils {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to put data');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
