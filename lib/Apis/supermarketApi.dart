import 'dart:convert';

import 'package:graduation_project/Apis/requests.dart';
import 'package:http/http.dart' as http;
import '../Pages/customer/model/product_data.dart';

class SupermarketApis {
  static Future<http.Response> getSupermarketItems(String id) async {
    try {
      final response = await Requests.getRequest('/supermarkets/$id/products');
      return response;
    } catch (e) {
      print('getSupermarketItems exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> removeProduct(
      String supId, String prodID) async {
    try {
      final response =
          await Requests.deleteRequest('/supermarkets/$supId/products/$prodID');
      return response;
    } catch (e) {
      print('removeProduct exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> getAllSupermarketList() async {
    try {
      final response = await Requests.getRequest('/supermarkets/');
      return response;
    } catch (e) {
      print('get super exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> addItemtoSupermarket(
      String price, String stock, String supId, String itemId) async {
    try {
      final body = jsonEncode({
        "price": price,
        "stock": stock,
      });
      final response = await Requests.postRequest(
          '/supermarkets/$supId/products/$itemId', body);
      return response;
    } catch (e) {
      print('add super exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> getSupermarketsWithListOfItems(
      double radius, List<Product> products, double x, double y) async {
    try {
      final productJsonList =
          products.map((product) => product.toJson()).toList();
      final requestBody = {
        'Coordinates': [
          {'x': x.toString(), 'y': y.toString()},
        ],
        'products': productJsonList
      };
      final body = jsonEncode(requestBody);
      final response = await Requests.postRequest(
          '/supermarkets/near-with-items/$radius', body);
      return response;
    } catch (e) {
      print('add super exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> addSupermarket(
      String name, String locationX, String locationY) async {
    try {
      final body = jsonEncode(
          {"locationX": locationX, "locationY": locationY, "name": name});
      final response = await Requests.postRequest('/supermarkets/', body);
      return response;
    } catch (e) {
      print('add super exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> deleteSuperMarket(String id) async {
    try {
      final response = await Requests.deleteRequest('/supermarkets/$id');
      return response;
    } catch (e) {
      print('add super exception: $e');
      return http.Response('error', 404);
    }
  }
}
