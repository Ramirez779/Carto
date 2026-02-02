import 'cart_item.dart';

//Modelo que representa una orden de compra
class Order {
  //Identificador único de la orden
  final String id;

  //Lista de productos del carrito incluidos en la orden
  final List<CartItem> items;

  //Monto total de la orden
  final double total;

  //Fecha y hora de creación de la orden
  final DateTime date;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });
}