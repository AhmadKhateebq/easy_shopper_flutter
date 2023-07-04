import "dart:convert";

import "package:http/http.dart" as http;
import "requests.dart";

class ItemApis {
  static Future<http.Response> getAllItems() async {
    try {
      final response = await Requests.getRequest('/products/');
      return response;
    } catch (e) {
      print('getAllItems exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> createProduct(
      String name, String description, String category, String brand) async {
    try {
      final body = jsonEncode({
        "name": name,
        "description": description,
        "category": category,
        "brand": brand,
      });
      final response = await Requests.postRequest('/products/', body);
      return response;
    } catch (e) {
      print('createProduct exception: $e');
      return http.Response('error', 404);
    }
  }
}
