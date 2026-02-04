import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';
import 'section_card.dart';

// Sección del checkout que muestra el método de pago
class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Método de pago',
      icon: Icons.credit_card_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.credit_card,
                color: AppColors.textPrimary, // Icono en color neutro
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Tarjeta de crédito',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Detalles de la tarjeta
          Text(
            '**** **** **** 1234',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}