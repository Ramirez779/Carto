import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';

// Encabezado de la pantalla de checkout
class CheckoutHeader extends StatelessWidget {
  const CheckoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila con ícono y título
        Row(
          children: [
            // Contenedor circular con ícono en color neutro
            Container(
              width: 40, // Ligeramente más grande para mejor presencia
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface, // Fondo neutro
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 20,
                color:
                    AppColors.textPrimary, // Icono en color de texto primario
              ),
            ),
            const SizedBox(width: 16), // Espaciado aumentado
            // Título principal
            Text(
              'Finaliza tu compra',
              style: TextStyle(
                fontSize: 22, // Tamaño aumentado para jerarquía
                fontWeight: FontWeight.w800, // Peso aumentado
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Subtítulo descriptivo
        Text(
          'Revisa y confirma los detalles de tu pedido',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}