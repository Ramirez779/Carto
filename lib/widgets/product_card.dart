import 'package:flutter/material.dart';
import 'package:carto/models/product.dart';

//Tarjeta reutilizable para mostrar un producto
class ProductCard extends StatelessWidget {
  //Información del producto
  final Product product;

  //Acción al tocar la tarjeta
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      //Mejora accesibilidad indicando que es un botón
      button: true,
      label: 'Producto ${product.title}, precio ${product.price} dólares',
      child: InkWell(
        //Maneja el evento de toque
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            //Estilo visual de la tarjeta
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Contenedor de imagen del producto
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: product.image != null
                    //Imagen cargada desde red
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          //Manejo de error al cargar la imagen
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error_outline,
                                size: 42,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      )
                    //Icono por defecto si no hay imagen
                    : const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 42,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              //Nombre del producto
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              //Precio del producto
              Text(
                '\$${product.price}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}