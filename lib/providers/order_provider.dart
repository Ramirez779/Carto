import 'dart:math';
import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  void addOrder(List items, double total) {
    _orders.insert(
      0,
      OrderModel(
        id: Random().nextDouble().toString(),
        items: items,
        total: total,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
