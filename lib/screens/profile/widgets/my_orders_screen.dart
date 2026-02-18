import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/order_provider.dart';
import '../../../ui/design_tokens.dart';

/// Pantalla de historial de pedidos
class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mis pedidos'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: orderProvider.orders.isEmpty
          ? _buildEmptyState()
          : _buildOrdersList(orderProvider.orders),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes pedidos aún',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tus compras aparecerán aquí',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _OrderCard(order: orders[index], orderIndex: index);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;
  final int orderIndex;

  const _OrderCard({
    required this.order,
    required this.orderIndex,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final date = order.date as DateTime;
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      final formattedDate = '$day/$month/$year';

      // ID corto
      final orderId = order.id.toString();
      final shortId = orderId.length > 8 ? orderId.substring(0, 8) : orderId;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pedido #$shortId',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusChip(orderIndex),
                ],
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fecha
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    formattedDate,
                  ),
                  const SizedBox(height: 12),

                  // Total
                  _buildInfoRow(
                    Icons.payments_outlined,
                    'Total: \$${order.total.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                  const SizedBox(height: 16),

                  // Productos
                  _buildProductsList(order.items),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Si hay error, mostrar card de error
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Text(
          'Error al cargar pedido',
          style: TextStyle(color: Colors.red[700]),
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: isBold ? AppColors.primary : AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(int index) {
    Color color;
    String text;

    switch (index % 3) {
      case 0:
        color = Colors.green;
        text = 'Entregado';
        break;
      case 1:
        color = Colors.blue;
        text = 'En camino';
        break;
      default:
        color = Colors.orange;
        text = 'Procesando';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildProductsList(List items) {
    try {
      if (items.isEmpty) {
        return Text(
          'Sin productos',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Productos:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Mostrar máximo 3 productos
          ...items.take(3).map<Widget>((item) {
            try {
              final name = item.product?.name ?? 'Producto';
              final price = item.product?.price ?? 0.0;
              final qty = item.quantity ?? 1;
              final subtotal = price * qty;

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '$name x$qty',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } catch (e) {
              return const SizedBox.shrink();
            }
          }).toList(),

          // Contador de productos restantes
          if (items.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+ ${items.length - 3} más',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      );
    } catch (e) {
      return Text(
        'Error al cargar productos',
        style: TextStyle(
          fontSize: 12,
          color: Colors.red[700],
          fontStyle: FontStyle.italic,
        ),
      );
    }
  }
}