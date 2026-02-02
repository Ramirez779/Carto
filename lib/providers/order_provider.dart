import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

//Provider encargado de gestionar las órdenes de compra
class OrderProvider extends ChangeNotifier {
  //Lista interna de órdenes
  final List<Order> _orders = [];

  //Exposición segura de las órdenes (solo lectura)
  List<Order> get orders => List.unmodifiable(_orders);

  //Agrega una nueva orden a partir del carrito
  void addOrder(List<CartItem> items, double total) {
    _orders.insert(
      0,
      Order(
        //Identificador basado en la fecha actual
        id: DateTime.now().toString(),
        //Copia de los items del carrito
        items: List.from(items),
        //Total de la orden
        total: total,
        //Fecha de creación de la orden
        date: DateTime.now(),
      ),
    );

    //Notifica a los listeners que el estado cambió
    notifyListeners();
  }
}