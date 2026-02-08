import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';

// Encabezado de pantalla de checkout
class CheckoutHeader extends StatelessWidget {
  const CheckoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Contenedor circular con ícono
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        //título
        Text(
          'Finaliza tu compra',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}