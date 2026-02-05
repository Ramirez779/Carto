import 'package:flutter_test/flutter_test.dart';
import 'package:carto/providers/cart_provider.dart';
import 'package:carto/models/product.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    test('Cart starts empty', () {
      expect(cartProvider.items.isEmpty, true);
      expect(cartProvider.total, 0.0);
    });

    test('Add product to cart', () {
      final product = Product(
        id: '1',
        title: 'Producto Test',
        price: 10.0,
        image: 'test_image_url', // AGREGADO: parámetro image requerido
        description: 'Descripción de prueba', // Opcional
        category: 'Test', // Opcional
        stock: 10, // Opcional
        rating: 4.5, // Opcional
      );

      cartProvider.addProduct(product);

      expect(cartProvider.items.length, 1);
      expect(cartProvider.total, 10.0);
    });

    test('Remove product from cart', () {
      final product = Product(
        id: '1',
        title: 'Producto Test',
        price: 10.0,
        image: 'test_image_url', // AGREGADO
        description: 'Descripción de prueba',
        category: 'Test',
        stock: 10,
        rating: 4.5,
      );

      cartProvider.addProduct(product);
      cartProvider.removeProduct(product);

      expect(cartProvider.items.isEmpty, true);
    });
  });
}