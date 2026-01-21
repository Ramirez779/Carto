import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis pedidos')),
      body: orders.isEmpty
          ? const Center(child: Text('No hay pedidos aún'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text('\$${order.total.toStringAsFixed(2)}'),
                  subtitle: Text(order.date.toString()),
                );
              },
            ),
    );
  }
}