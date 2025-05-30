import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];
  
  List<Map<String, dynamic>> get cartItems => _cartItems;
  
  int get itemCount => _cartItems.length;
  
  double get subtotal => _cartItems.fold(0, (sum, item) => sum + (item['price'] as num));
  
  double get tax => subtotal * 0.05;
  
  double get total => subtotal + tax;
  
  void addToCart(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners();
  }
  
  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }
  
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
