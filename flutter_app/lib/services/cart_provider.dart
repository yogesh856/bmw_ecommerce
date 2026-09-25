import 'package:flutter/material.dart';
import 'api_service.dart';

class CartProvider extends ChangeNotifier {
  List<dynamic> items = [];
  int get itemCount => items.length;

  double get total => items.fold(0, (sum, item) {
    return sum + (item['price'] * (item['quantity'] ?? 1));
  });

  Future<void> loadCart(String userId) async {
    final cart = await ApiService.getCart(userId);
    items = cart['items'] ?? [];
    notifyListeners();
  }

  Future<void> addItem(String userId, String carId, {String? color}) async {
    await ApiService.addToCart(userId, carId, color: color);
    await loadCart(userId);
  }

  Future<void> removeItem(String userId, String carId, {String? color}) async {
    await ApiService.removeFromCart(userId, carId, color: color);
    await loadCart(userId);
  }

  void clearLocal() {
    items = [];
    notifyListeners();
  }
}
