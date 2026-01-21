class Product {
  final String id;
  final String title;
  final double price;
  final String? image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
    );
  }
}