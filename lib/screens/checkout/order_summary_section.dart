import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../ui/design_tokens.dart';
import 'section_card.dart';

//Sección que muestra el resumen final del pedido
class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    //Obtiene el estado actual del carrito desde Provider
    final cart = context.watch<CartProvider>();

    return SectionCard(
      //Título visible de la sección
      title: 'Resumen del pedido',

      //Ícono representativo del resumen
      icon: Icons.receipt_outlined,

      //Contenido principal de la tarjeta
      child: Text(
        //Muestra el total del carrito con dos decimales
        'Total: \$${cart.total.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}