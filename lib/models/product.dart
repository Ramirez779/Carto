// Modelo que representa un producto en la aplicación
class Product {
  // Identificador único del producto
  final String id;

  // Nombre o título del producto
  final String title;

  // Precio del producto
  final double price;

  // URL de la imagen del producto
  final String image;

  // Descripción detallada del producto
  final String description;

  // Categoría a la que pertenece el producto
  final String category;

  // Cantidad disponible en inventario
  final int stock;

  // Calificación promedio del producto (0.0 - 5.0)
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.description = '',
    this.category = 'Uncategorized',
    this.stock = 0,
    this.rating = 0.0,
  });

  // Convierte el producto a un Map para uso en JSON o Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
      'stock': stock,
      'rating': rating,
    };
  }

  // Crea un producto a partir de un Map de JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Uncategorized',
      stock: json['stock'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convierte el producto a un Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
      'stock': stock,
      'rating': rating,
    };
  }

  // Crea un producto a partir de un Map de SQLite
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      price: map['price'] as double,
      image: map['image'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      stock: map['stock'] as int,
      rating: map['rating'] as double,
    );
  }

  // Crea una copia del producto con algunos campos modificados
  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? image,
    String? description,
    String? category,
    int? stock,
    double? rating,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
    );
  }

  // Verifica si el producto está agotado
  bool get isOutOfStock => stock <= 0;

  // Verifica si el producto tiene stock bajo (menos de 5 unidades)
  bool get isLowStock => stock > 0 && stock <= 5;

  // Devuelve el precio formateado como string con símbolo de moneda
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  // Devuelve la calificación formateada con un decimal
  String get formattedRating => rating.toStringAsFixed(1);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: \$$price, stock: $stock)';
  }
}

// Enumeración para categorías de productos (opcional, para mejor organización)
enum ProductCategory {
  electronics('Electrónica'),
  audio('Audio'),
  wearables('Wearables'),
  computing('Computación'),
  home('Hogar'),
  accessories('Accesorios'),
  other('Otros');

  final String displayName;
  const ProductCategory(this.displayName);
}

// Clase helper para manejar operaciones con productos
class ProductHelper {
  // Filtra productos por categoría
  static List<Product> filterByCategory(
    List<Product> products,
    String category,
  ) {
    return products.where((p) => p.category == category).toList();
  }

  // Busca productos por término
  static List<Product> searchProducts(
    List<Product> products,
    String searchTerm,
  ) {
    if (searchTerm.isEmpty) return products;
    
    final term = searchTerm.toLowerCase();
    return products.where((product) {
      return product.title.toLowerCase().contains(term) ||
             product.description.toLowerCase().contains(term) ||
             product.category.toLowerCase().contains(term);
    }).toList();
  }

  // Ordena productos por diferentes criterios
  static List<Product> sortProducts(
    List<Product> products,
    ProductSort sortBy,
  ) {
    final sorted = List<Product>.from(products);
    
    switch (sortBy) {
      case ProductSort.priceLowToHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceHighToLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.nameAZ:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case ProductSort.rating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSort.newest:
        // Aquí asumimos que el ID contiene información de fecha o orden
        // En una implementación real, tendrías un campo 'createdAt'
        sorted.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    
    return sorted;
  }
}

// Enumeración para tipos de ordenamiento
enum ProductSort {
  priceLowToHigh('Precio: menor a mayor'),
  priceHighToLow('Precio: mayor a menor'),
  nameAZ('Nombre: A-Z'),
  rating('Mejor calificados'),
  newest('Más nuevos');

  final String displayName;
  const ProductSort(this.displayName);
}