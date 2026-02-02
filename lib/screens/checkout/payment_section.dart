import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';
import 'section_card.dart';

//Sección del checkout que muestra el método de pago seleccionado
class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      //Título que aparece en la tarjeta
      title: 'Método de pago',

      //Ícono principal de la sección
      icon: Icons.credit_card_outlined,

      //Contenido interno de la sección
      child: Row(
        children: [
          //Ícono del tipo de pago
          Icon(
            Icons.credit_card,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),

          //Texto descriptivo del método de pago
          const Text('Tarjeta de crédito'),
        ],
      ),
    );
  }
}