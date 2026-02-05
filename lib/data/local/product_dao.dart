import 'package:sqflite/sqflite.dart';
import 'package:carto/models/product.dart';
import 'database.dart';

class ProductDAO {
  Future<Database> get _db async => await AppDatabase.database;

  // Insertar un producto
  Future<void> insertProduct(Product product) async {
    final db = await _db;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insertar múltiples productos
  Future<void> insertProducts(List<Product> products) async {
    final db = await _db;
    final batch = db.batch();
    
    for (var product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  // Obtener todos los productos
  Future<List<Product>> getAllProducts() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('products');
    
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Obtener un producto por ID
  Future<Product?> getProductById(String id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  // Actualizar un producto
  Future<int> updateProduct(Product product) async {
    final db = await _db;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Eliminar un producto
  Future<int> deleteProduct(String id) async {
    final db = await _db;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ELIMINAR TODOS LOS PRODUCTOS - MÉTODO NUEVO
  Future<int> deleteAllProducts() async {
    final db = await _db;
    return await db.delete('products');
  }

  // Obtener productos por categoría
  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
    
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Buscar productos por título
  Future<List<Product>> searchProducts(String query) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Actualizar stock de un producto
  Future<int> updateProductStock(String productId, int newStock) async {
    final db = await _db;
    
    // Primero obtenemos el producto actual
    final product = await getProductById(productId);
    if (product == null) return 0;
    
    // Creamos una copia actualizada
    final updatedProduct = product.copyWith(stock: newStock);
    
    // Actualizamos en la base de datos
    return await updateProduct(updatedProduct);
  }

  // Método para verificar si hay productos
  Future<bool> hasProducts() async {
    final db = await _db;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM products')
    );
    return (count ?? 0) > 0;
  }
}