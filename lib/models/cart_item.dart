import 'product.dart';

//Modelo que representa un producto dentro del carrito
class CartItem {
  //Producto asociado al item
  final Product product;

  //Cantidad del producto
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  //Convierte el objeto a JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  //Crea una instancia a partir de un JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] as int,
    );
  }
}