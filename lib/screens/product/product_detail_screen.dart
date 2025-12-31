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

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔽 CONTENIDO SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Título
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Precio
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Descripción
                    const Text(
                      'Este producto es una muestra del catálogo. '
                      'Aquí puedes mostrar una descripción más detallada.',
                    ),
                  ],
                ),
              ),
            ),

            // 🔘 BOTÓN PROTEGIDO (NO LO TAPA EL SISTEMA)
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                12 + bottomInset, // 🔥 CLAVE
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().addProduct(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto agregado al carrito'),
                      ),
                    );
                  },
                  child: const Text('Agregar al carrito'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
