class Product {
  final String name;
  final int id;
  final double price;
  final String origin;
  final String image_url;

  const Product({
    this.name,
    this.id,
    this.price,
    this.origin,
    this.image_url,
  });

  static Product fromJson(json) {
    return Product(
      name: json['name'],
      id: json['id'],
      price: json['price'],
      origin: json['origin'],
      image_url: json['image_url'],
    );
  }
}