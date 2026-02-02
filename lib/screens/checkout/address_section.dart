import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';
import 'section_card.dart';

//Sección que muestra la dirección de entrega
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
          //Dirección principal
          Text(
            'Calle Principal #123',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          //Ciudad y país
          Text(
            'Ciudad, País',
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