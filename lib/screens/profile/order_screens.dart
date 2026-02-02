import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

//Pantalla que muestra el historial de pedidos
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Obtiene la lista de órdenes desde el provider
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis pedidos'),
      ),
      body: orders.isEmpty
          //Mensaje cuando no hay pedidos
          ? const Center(child: Text('No hay pedidos aún'))
          //Lista de pedidos realizados
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  //Total de la orden
                  title: Text('\$${order.total.toStringAsFixed(2)}'),
                  //Fecha de la orden
                  subtitle: Text(order.date.toString()),
                );
              },
            ),
    );
  }
}