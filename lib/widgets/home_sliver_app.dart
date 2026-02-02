import 'package:flutter/material.dart';

//AppBar tipo Sliver para la pantalla principal
class HomeSliverAppBar extends StatelessWidget {
  const HomeSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      //Color de fondo del AppBar
      backgroundColor: const Color(0xffF5F6FA),
      elevation: 0,

      //Permite que el AppBar aparezca al hacer scroll
      floating: true,
      snap: true,

      //Oculta el botón de regreso
      automaticallyImplyLeading: false,
      titleSpacing: 16,

      //Contenedor personalizado del título
      title: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            //Estilo visual del buscador/AppBar
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              //Título principal
              const Text(
                'Explorar productos',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              //Botón de búsqueda
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              //Botón del carrito
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}