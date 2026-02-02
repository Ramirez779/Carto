import 'package:flutter/material.dart';

//Tarjeta reutilizable para pantallas de autenticación
class AuthCard extends StatelessWidget {
  //Título principal de la tarjeta
  final String title;

  //Contenido dinámico (inputs, botones, etc.)
  final List<Widget> children;

  const AuthCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //Limita el ancho máximo en pantallas grandes
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        //Estilo visual de la tarjeta
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Título de la sección
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          //Inserta los widgets recibidos
          ...children,
        ],
      ),
    );
  }
}