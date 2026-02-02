import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carto/models/product.dart';
import 'package:carto/providers/cart_provider.dart';

//Pantalla de detalle de un producto
class ProductDetailScreen extends StatelessWidget {
  //Producto recibido desde la pantalla anterior
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    //Espacio inferior del sistema (gestos / notch)
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    //Detecta si el tema actual es oscuro
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      //Color de fondo según el tema
      backgroundColor:
          isDark ? const Color(0xff0F1115) : const Color(0xffF5F6FA),

      //AppBar con título del producto
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xff0F1115) : const Color(0xffF5F6FA),
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),

      body: SafeArea(
        child: Column(
          children: [
            //Contenido principal desplazable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Contenedor de la imagen del producto
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xff1C1F26) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      //Imagen remota o ícono por defecto
                      child: product.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                product.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  //Fallback si falla la imagen
                                  return const Center(
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 96,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 96,
                                color: Colors.grey,
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    //Título del producto
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    //Precio del producto
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff4F6EF7),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //Descripción del producto (texto de ejemplo)
                    Text(
                      'Este producto forma parte del catálogo de la tienda. '
                      'Aquí puedes mostrar una descripción más detallada, '
                      'beneficios, características o cualquier información relevante.',
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.grey[300] : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Botón fijo para agregar al carrito
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                12 + bottomInset,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4F6EF7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    //Agrega el producto al carrito
                    context.read<CartProvider>().addProduct(product);

                    //Muestra confirmación al usuario
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Producto agregado al carrito'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text(
                    'Agregar al carrito',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}