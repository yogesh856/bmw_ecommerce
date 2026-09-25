import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? userId;
  String? name;
  String? email;
  bool isLoggedIn = false;

  // ── Load saved session on app start ──────────────────────
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    name   = prefs.getString('user_name');
    email  = prefs.getString('user_email');
    isLoggedIn = userId != null;
    notifyListeners();
  }

  // ── Login & persist ───────────────────────────────────────
  Future<void> login(Map<String, dynamic> userData) async {
    userId     = userData['user_id'];
    name       = userData['name'];
    email      = userData['email'];
    isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id',    userId!);
    await prefs.setString('user_name',  name!);
    await prefs.setString('user_email', email!);

    notifyListeners();
  }

  // ── Logout & clear ────────────────────────────────────────
  Future<void> logout() async {
    userId     = null;
    name       = null;
    email      = null;
    isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');

    notifyListeners();
  }
}
