import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carto/models/product.dart';
import 'package:carto/providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xff0F1115) : const Color(0xffF5F6FA),
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
            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen de producto
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
                      child: product.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                product.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
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

                    // Título
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Precio
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff4F6EF7),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Descripción
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

            // Botón fijo abajo
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
                    context.read<CartProvider>().addProduct(product);

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