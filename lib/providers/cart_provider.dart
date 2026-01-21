import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total {
    return _items.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  //Cargar carrito desde SharedPreferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('cart_items');

      if (jsonString == null || jsonString.isEmpty) {
        return; //no hay nada guardado
      }

      final List<dynamic> decoded = jsonDecode(jsonString);

      _items.clear();
      for (final item in decoded) {
        try {
          _items.add(CartItem.fromJson(item));
        } catch (e) {
          debugPrint('Error parsing cart item: $e');
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  //Guardar carrito
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _items.map((item) => item.toJson()).toList();
      prefs.setString('cart_items', jsonEncode(data));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void addProduct(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
    _saveCart();
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
    _saveCart();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }
}