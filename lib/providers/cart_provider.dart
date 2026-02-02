import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

//Provider encargado del estado del carrito de compras
class CartProvider extends ChangeNotifier {
  //Lista interna de items del carrito
  final List<CartItem> _items = [];

  //Exposición segura de los items (solo lectura)
  List<CartItem> get items => List.unmodifiable(_items);

  //Calcula el total del carrito
  double get total {
    return _items.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  //Carga el carrito guardado desde SharedPreferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('cart_items');

      //Si no hay datos guardados, no hace nada
      if (jsonString == null || jsonString.isEmpty) {
        return;
      }

      final List<dynamic> decoded = jsonDecode(jsonString);

      _items.clear();
      for (final item in decoded) {
        try {
          //Reconstruye cada item del carrito desde JSON
          _items.add(CartItem.fromJson(item));
        } catch (e) {
          debugPrint('Error parsing cart item: $e');
        }
      }

      //Notifica a los listeners que el estado cambió
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  //Guarda el carrito actual en SharedPreferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _items.map((item) => item.toJson()).toList();
      prefs.setString('cart_items', jsonEncode(data));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  //Agrega un producto al carrito o incrementa su cantidad
  void addProduct(Product product) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
    _saveCart();
  }

  //Elimina un producto del carrito
  void removeProduct(Product product) {
    _items.removeWhere(
      (item) => item.product.id == product.id,
    );
    notifyListeners();
    _saveCart();
  }

  //Vacía completamente el carrito
  void clear() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }
}