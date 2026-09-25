import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  // Auto-detect: Web (Chrome) → localhost, Android Emulator → 10.0.2.2
  static final String baseUrl =
      kIsWeb ? 'http://localhost:5000/api' : 'http://10.0.2.2:5000/api';

  static const Duration _timeout = Duration(seconds: 10);

  // ── Helper ────────────────────────────────────────────────
  static Future<Map<String, dynamic>> _postJson(String url, Map body) async {
    try {
      final res = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      final decoded = jsonDecode(res.body);
      if (res.statusCode >= 400) {
        throw Exception(decoded['error'] ?? 'Something went wrong');
      }
      return decoded as Map<String, dynamic>;
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Server not responding. Try again.');
    }
  }

  static Future<dynamic> _getJson(String url) async {
    try {
      final cacheBusterUrl = url + (url.contains('?') ? '&' : '?') + 't=${DateTime.now().millisecondsSinceEpoch}';
      final res = await http.get(Uri.parse(cacheBusterUrl)).timeout(_timeout);
      final decoded = jsonDecode(res.body);
      if (res.statusCode >= 400) {
        throw Exception(
            (decoded is Map ? decoded['error'] : null) ?? 'Something went wrong');
      }
      return decoded;
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Server not responding. Try again.');
    }
  }

  // ── AUTH ─────────────────────────────────────────────────

  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String phone) async {
    return await _postJson('$baseUrl/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    return await _postJson('$baseUrl/auth/login', {
      'email': email,
      'password': password,
    });
  }

  // ── CARS ─────────────────────────────────────────────────

  static Future<List<dynamic>> getAllCars({String? category}) async {
    String url = '$baseUrl/cars/';
    if (category != null) url += '?category=$category';
    return await _getJson(url) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getCarById(String carId) async {
    return await _getJson('$baseUrl/cars/$carId') as Map<String, dynamic>;
  }

  static Future<List<dynamic>> searchCars(String query) async {
    return await _getJson('$baseUrl/cars/search?q=$query') as List<dynamic>;
  }

  // ── CART ─────────────────────────────────────────────────

  static Future<Map<String, dynamic>> getCart(String userId) async {
    return await _getJson('$baseUrl/cart/$userId') as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> addToCart(
      String userId, String carId, {String? color}) async {
    return await _postJson(
        '$baseUrl/cart/add', {'user_id': userId, 'car_id': carId, if (color != null) 'color': color});
  }

  static Future<Map<String, dynamic>> removeFromCart(
      String userId, String carId, {String? color}) async {
    return await _postJson(
        '$baseUrl/cart/remove', {'user_id': userId, 'car_id': carId, if (color != null) 'color': color});
  }

  // ── ORDERS ───────────────────────────────────────────────

  static Future<Map<String, dynamic>> placeOrder(
      String userId, List items, String address, String paymentMethod) async {
    return await _postJson('$baseUrl/orders/place', {
      'user_id': userId,
      'items': items,
      'address': address,
      'payment_method': paymentMethod,
    });
  }

  static Future<List<dynamic>> getUserOrders(String userId) async {
    return await _getJson('$baseUrl/orders/user/$userId') as List<dynamic>;
  }
}
