import 'package:flutter/foundation.dart';
import 'package:carto/data/local/product_dao.dart';
import 'package:carto/data/repositories/product_repository.dart';
import 'package:carto/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isRefreshing = false; // Nuevo estado para refresco manual
  String? _error;
  DateTime? _lastRefreshTime; // Para tracking de última actualización

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing; // Nuevo getter
  String? get error => _error;
  bool get hasError => _error != null;
  DateTime? get lastRefreshTime => _lastRefreshTime;

  // Nueva propiedad para detectar cambios
  int get productCount => _products.length;

  final ProductRepository _repository;

  ProductProvider() : _repository = ProductRepository(ProductDAO());

  // Cargar todos los productos (carga inicial)
  Future<void> loadProducts() async {
    if (_isLoading && !_isRefreshing) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _repository.getAllProducts();
      _lastRefreshTime = DateTime.now();
    } catch (e) {
      _error = 'Error al cargar los productos: $e';
      debugPrint('ProductProvider Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refrescar productos (con estado separado para UI)
  Future<void> refreshProducts() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    _error = null;
    notifyListeners();

    try {
      final previousCount = _products.length;
      _products = await _repository.getAllProducts();
      _lastRefreshTime = DateTime.now();

      // Devolver información sobre si hubo cambios
      final newCount = _products.length;
      final hadChanges = newCount != previousCount;

      if (hadChanges) {
        debugPrint(
            'Refresh detectó cambios: $previousCount -> $newCount productos');
      }
    } catch (e) {
      _error = 'Error al refrescar productos: $e';
      debugPrint('ProductProvider Refresh Error: $e');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // Refresco silencioso (para auto-refresh, no muestra loading)
  Future<bool> silentRefresh() async {
    try {
      final previousCount = _products.length;
      _products = await _repository.getAllProducts();
      _lastRefreshTime = DateTime.now();

      final newCount = _products.length;
      final hadChanges = newCount != previousCount;

      if (hadChanges) {
        debugPrint(
            'SilentRefresh detectó cambios: $previousCount -> $newCount productos');
        notifyListeners(); // Solo notificar si hubo cambios
      }

      return hadChanges;
    } catch (e) {
      debugPrint('ProductProvider SilentRefresh Error: $e');
      return false;
    }
  }

  // Obtener producto por ID
  Future<Product?> getProductById(String id) async {
    try {
      return await _repository.getProductById(id);
    } catch (e) {
      debugPrint('Error obteniendo producto $id: $e');
      return null;
    }
  }

  // Buscar productos
  Future<List<Product>> searchProducts(String query) async {
    try {
      return await _repository.searchProducts(query);
    } catch (e) {
      debugPrint('Error buscando productos: $e');
      return [];
    }
  }

  // Obtener productos por categoría
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await _repository.getProductsByCategory(category);
    } catch (e) {
      debugPrint('Error obteniendo productos por categoría: $e');
      return [];
    }
  }

  // Actualizar stock cuando se compra
  Future<bool> updateStockOnPurchase(String productId, int quantity) async {
    try {
      final success = await _repository.updateProductStock(productId, quantity);

      if (success) {
        // Actualizar la lista local de productos
        final index = _products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          final product = _products[index];
          final newStock = product.stock - quantity;

          _products[index] = product.copyWith(stock: newStock);
          notifyListeners();
        }
      }

      return success;
    } catch (e) {
      debugPrint('Error actualizando stock: $e');
      return false;
    }
  }

  // Forzar recarga de un producto específico
  Future<void> reloadProduct(String productId) async {
    try {
      final updatedProduct = await _repository.getProductById(productId);
      if (updatedProduct != null) {
        final index = _products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error recargando producto $productId: $e');
    }
  }

  // Obtener productos con stock bajo
  List<Product> get lowStockProducts {
    return _products.where((product) => product.isLowStock).toList();
  }

  // Obtener productos agotados
  List<Product> get outOfStockProducts {
    return _products.where((product) => product.isOutOfStock).toList();
  }

  // Obtener productos por rating
  List<Product> getProductsByRating(double minRating) {
    return _products.where((product) => product.rating >= minRating).toList();
  }

  // Verificar si necesita refresco (útil para auto-refresh)
  bool get needsRefresh {
    if (_lastRefreshTime == null) return true;
    final difference = DateTime.now().difference(_lastRefreshTime!);
    return difference.inMinutes >= 5; // 5 minutos
  }

  // Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Resetear provider (para testing o logout)
  void reset() {
    _products = [];
    _isLoading = false;
    _isRefreshing = false;
    _error = null;
    _lastRefreshTime = null;
    notifyListeners();
  }

  // Para debugging
  @override
  String toString() {
    return 'ProductProvider(products: ${_products.length}, loading: $_isLoading, refreshing: $_isRefreshing, error: $_error)';
  }
}