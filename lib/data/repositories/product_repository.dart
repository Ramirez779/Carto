import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:carto/data/local/product_dao.dart';
import 'package:carto/models/product.dart';

class ProductRepository {
  final ProductDAO _productDAO;

  ProductRepository(this._productDAO);

  // Cargar productos iniciales desde el archivo JSON
  Future<void> seedInitialProducts() async {
    try {
      debugPrint('=== VERIFICANDO PRODUCTOS ===');
      
      // 1. Obtener productos existentes
      final existingProducts = await _productDAO.getAllProducts();
      debugPrint('✓ Productos en DB: ${existingProducts.length}');
      
      // 2. Cargar JSON para ver cuántos deberían haber
      final jsonString = await rootBundle.loadString('assets/products.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      debugPrint('✓ Productos en JSON: ${jsonList.length}');
      
      // 3. Si NO hay 30 productos, eliminar y resembrar
      if (existingProducts.length < 30) {
        debugPrint('⚠ Faltan productos, resembrando...');
        
        // Eliminar todos
        await _productDAO.deleteAllProducts();
        debugPrint('✓ Base de datos limpiada');
        
        // Insertar todos del JSON
        final List<Product> allProducts = jsonList
            .map((json) => Product.fromJson(json))
            .toList();
        
        await _productDAO.insertProducts(allProducts);
        debugPrint('✓ ${allProducts.length} productos insertados');
      } else {
        debugPrint('✓ Ya hay todos los productos (${existingProducts.length})');
      }
      
      debugPrint('=== VERIFICACIÓN COMPLETADA ===');
      
    } catch (e) {
      debugPrint('ERROR en seedInitialProducts: $e');
      rethrow;
    }
  }

  // Obtener todos los productos
  Future<List<Product>> getAllProducts() async {
    try {
      final products = await _productDAO.getAllProducts();
      
      // Si no hay productos o hay menos de 30, sembrar
      if (products.isEmpty || products.length < 30) {
        debugPrint('No hay suficientes productos, verificando...');
        await seedInitialProducts();
        return await _productDAO.getAllProducts();
      }
      
      return products;
    } catch (e) {
      debugPrint('Error al obtener productos: $e');
      return [];
    }
  }

  // Obtener producto por ID
  Future<Product?> getProductById(String id) async {
    try {
      return await _productDAO.getProductById(id);
    } catch (e) {
      debugPrint('Error al obtener producto por ID: $e');
      return null;
    }
  }

  // Buscar productos
  Future<List<Product>> searchProducts(String query) async {
    try {
      return await _productDAO.searchProducts(query);
    } catch (e) {
      debugPrint('Error al buscar productos: $e');
      return [];
    }
  }

  // Obtener productos por categoría
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await _productDAO.getProductsByCategory(category);
    } catch (e) {
      debugPrint('Error al obtener productos por categoría: $e');
      return [];
    }
  }

  // Actualizar stock de un producto
  Future<bool> updateProductStock(String productId, int quantity) async {
    try {
      // Obtener producto actual
      final product = await _productDAO.getProductById(productId);
      if (product == null) return false;

      // Calcular nuevo stock
      final newStock = product.stock - quantity;
      if (newStock < 0) return false;

      // Actualizar en base de datos
      final rowsAffected = await _productDAO.updateProductStock(productId, newStock);
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error al actualizar stock: $e');
      return false;
    }
  }

  // MÉTODO EXTRA: Limpiar y resembrar (para debug/testing)
  Future<void> forceReseed() async {
    try {
      debugPrint('=== FORZANDO RESEMBRADO ===');
      await _productDAO.deleteAllProducts();
      
      // Cargar JSON
      final jsonString = await rootBundle.loadString('assets/products.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Insertar todos
      final List<Product> allProducts = jsonList
          .map((json) => Product.fromJson(json))
          .toList();
      
      await _productDAO.insertProducts(allProducts);
      debugPrint('✓ ${allProducts.length} productos insertados');
      debugPrint('=== RESEMBRADO COMPLETADO ===');
    } catch (e) {
      debugPrint('ERROR en forceReseed: $e');
    }
  }
}