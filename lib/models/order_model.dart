class OrderModel {
  final String id;
  final List items;
  final double total;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });
}
