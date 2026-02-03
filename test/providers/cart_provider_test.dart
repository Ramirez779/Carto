// test/providers/cart_provider_test.dart
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
        // Ajusta según los parámetros reales de tu modelo Product
        // Si no tiene description y category, quítalos
        // Si tiene otros parámetros, ajústalos
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
      );

      cartProvider.addProduct(product);
      cartProvider.removeProduct(product);

      expect(cartProvider.items.isEmpty, true);
    });
  });
}