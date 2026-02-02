//Modelo que representa un producto
class Product {
  //Identificador único del producto
  final String id;

  //Nombre o título del producto
  final String title;

  //Precio del producto
  final double price;

  //URL de la imagen del producto
  final String? image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.image,
  });

  //Convierte el producto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
    };
  }

  //Crea un producto a partir de un JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
    );
  }
}