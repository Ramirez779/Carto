import 'package:flutter/material.dart';
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

  void addProduct(Product product) {
    final index =
        _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.removeWhere(
      (item) => item.product.id == product.id,
    );
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
