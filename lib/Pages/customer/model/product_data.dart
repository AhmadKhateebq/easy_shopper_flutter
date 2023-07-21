class Product {
  int? id;
  String name;
  String brand;
  String category;
  String description;
  String imageUrl;

  Product({
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.imageUrl,
    required id,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      name: json["name"],
      category: json["category"],
      description: json["description"],
      imageUrl: json['imageUrl'],
      brand: json['brand']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['imageUrl'] = imageUrl;
    data['description'] = description;
    data['brand'] = brand;
    return data;
  }
}

class SupermarketProduct {
  int? id;
  Product product;
  double price;
  double stock;

  SupermarketProduct({
    required this.id,
    required this.product,
    required this.price,
    required this.stock,
  });

  factory SupermarketProduct.fromJson(Map<String, dynamic> json) =>
      SupermarketProduct(
        id: json['id'],
        product: Product.fromJson(json['product']),
        price: json['price'],
        stock: json['stock'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product.toJson();
    data['price'] = price;
    data['stock'] = stock;
    return data;
  }
}
