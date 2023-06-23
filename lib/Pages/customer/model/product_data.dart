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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
