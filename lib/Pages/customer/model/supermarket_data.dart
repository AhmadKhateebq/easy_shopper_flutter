import 'package:graduation_project/Pages/customer/model/product_data.dart';
import 'package:graduation_project/Pages/customer/model/supermarket.dart';

class Supermarket_data {
  Supermarket supermarket;
  List<supermarketProducts> contains;
  List<Product> dontContains;
  double containPercentage;
  int originalItemsSize;
  int containingSize;
  double total;

  Supermarket_data({
    required this.supermarket,
    required this.contains,
    required this.dontContains,
    required this.containPercentage,
    required this.originalItemsSize,
    required this.containingSize,
    required this.total,
  });
  factory Supermarket_data.fromJson(Map<String, dynamic> json) {
    return Supermarket_data(
        supermarket: Supermarket.fromJson(json['supermarket']),
        contains: (json['contains'] as List<dynamic>)
            .map((data) => supermarketProducts.fromJson(data))
            .toList(),
        dontContains: (json['dontContains'] as List<dynamic>)
            .map((data) => Product.fromJson(data))
            .toList(),
        containPercentage: json['containPercentage'],
        originalItemsSize: json['originalItemsSize'],
        containingSize: json['containingSize'],
        total: json["total"]);
  }
  factory Supermarket_data.parseSupermarketData(Map<String, dynamic> jsonData) {
    Map<String, dynamic> supermarketJson = jsonData['supermarket'];
    Supermarket supermarket = Supermarket(
      id: supermarketJson['id'],
      name: supermarketJson['name'],
      locationX: double.parse(supermarketJson['locationX']),
      locationY: double.parse(supermarketJson['locationY']),
    );

    List<dynamic> containsJson = jsonData['contains'];
    List<supermarketProducts> contains = containsJson
        .map((productJson) => supermarketProducts.fromJson(productJson))
        .toList();

    List<dynamic> dontContainsJson = jsonData['dontContains'];
    List<Product> dontContains = dontContainsJson
        .map((productJson) => Product(
              id: productJson['id'],
              name: productJson['name'],
              brand: productJson['brand'],
              category: productJson['category'],
              description: productJson['description'],
              imageUrl: productJson['imageUrl'],
            ))
        .toList();

    return Supermarket_data(
      supermarket: supermarket,
      contains: contains,
      dontContains: dontContains,
      containPercentage: jsonData['containPercentage'],
      originalItemsSize: jsonData['originalItemsSize'],
      containingSize: jsonData['containingSize'],
      total: jsonData['total'],
    );
  }
}
