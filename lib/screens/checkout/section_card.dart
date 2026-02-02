import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';

//Tarjeta reutilizable para secciones del checkout (dirección, pago, resumen)
class SectionCard extends StatelessWidget {
  //Título que se muestra en la cabecera de la sección
  final String title;

  //Ícono que acompaña al título
  final IconData icon;

  //Contenido interno de la sección
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
      //Espaciado interno de la tarjeta
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        //Color de fondo según el tema de la app
        color: AppColors.surface,
        //Bordes redondeados
        borderRadius: BorderRadius.circular(AppRadius.l),
        //Borde sutil para separar la sección visualmente
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Cabecera de la sección (icono + título)
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          //Contenido personalizado de la sección
          child,
        ],
      ),
    );
  }
}