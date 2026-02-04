import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';

// Tarjeta reutilizable para secciones del checkout
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: Colors.black.withOpacity(0.08), // Borde más sutil
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la sección
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.textPrimary, // Icono en color de texto
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3, // Espaciado de letras mejorado
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Contenido personalizado
          child,
        ],
      ),
    );
  }
}