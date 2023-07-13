class CartProduct {
  final String name;
  final int id;
  final double price;
  final String origin;
  final String image_url;
  final int quantity;
  final double total;

  const CartProduct({
    this.name,
    this.id,
    this.price,
    this.origin,
    this.image_url,
    this.quantity,
    this.total,
  });

  static CartProduct fromJson(json) {
    return CartProduct(
      name: json['name'],
      id: json['id'],
      price: json['price'],
      origin: json['origin'],
      image_url: json['image_url'],
      quantity: json['quantity'],
      total: json['total'],
    );
  }
}

class Cart {
  final int user_id;
  final List<CartProduct> products;


  Cart({this.user_id, this.products});

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<CartProduct> products = [];
    if (json["products"] != null) {
      products = List<CartProduct>.from(
          (json["products"] as List).map((e) => CartProduct.fromJson(e)));
    }


    return Cart(
    user_id: json['user_id'],
    products: products,
    );
  }
}