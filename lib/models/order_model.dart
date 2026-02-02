//Modelo que representa una orden de compra
class OrderModel {
  //Identificador único de la orden
  final String id;

  //Lista de productos incluidos en la orden
  final List items;

  //Total monetario de la orden
  final double total;

  //Fecha y hora en que se realizó la orden
  final DateTime date;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });
}