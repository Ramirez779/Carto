import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';
import 'section_card.dart';

// Sección que muestra la dirección de entrega
class AddressSection extends StatelessWidget {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Dirección de entrega',
      icon: Icons.location_on_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dirección principal
          Text(
            'Calle Principal #123',
            style: TextStyle(
              fontSize: 16, // Tamaño aumentado
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          // Ciudad y país
          Text(
            'Ciudad, País',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          // Opción para cambiar dirección
          GestureDetector(
            onTap: () {
              // Navegar a pantalla de edición de dirección
            },
            child: Text(
              'Cambiar dirección',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}