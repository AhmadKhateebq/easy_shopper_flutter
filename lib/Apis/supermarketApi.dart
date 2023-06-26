import "dart:convert";

import "package:graduation_project/Constants/connection.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import "../Pages/customer/model/product_data.dart";

String header = "Bearer";

class SupermarketApis {
  static Future<http.Response> getSupermarketItems(String id) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.get(
          Uri.parse("${ConnectionUrls.urlIp}supermarkets/${id}/products"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("getSupermarketItems exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> removeProduct(
      String supId, String prodID) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.delete(
          Uri.parse(
              "${ConnectionUrls.urlIp}supermarkets/${supId}/products/${prodID}"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("removeProduct exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> getAllSupermarketList() async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.get(Uri.parse("${ConnectionUrls.urlIp}supermarkets/"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("get super exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> addItemtoSupermarket(
      String price, String stock, String supId, String itemId) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.post(
          Uri.parse(
              "${ConnectionUrls.urlIp}supermarkets/${supId}/products/${itemId}"),
          headers: {
            "content-type": "application/json",
            "Authorization": "${header} ${token}",
          },
          body: jsonEncode(<String, dynamic>{
            "price": price,
            "stock": stock,
          }));
    } on Exception catch (e) {
      print("add super exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> getSupermarketsWithListOfItems(
      double radius, List<Product> products, double x, double y) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      List<Map<String, dynamic>> productJsonList =
          products.map((product) => product.toJson()).toList();
      print(productJsonList);
      Map<String, dynamic> requestBody = {
        'Coordinates': [
          {'x': x.toString(), 'y': y.toString()},
        ],
        'products': productJsonList
      };
      print(requestBody);
      return http.post(
          Uri.parse(
              "${ConnectionUrls.urlIp}/supermarkets/near-with-items/$radius"),
          headers: {
            "content-type": "application/json",
            "Authorization": "${header} ${token}",
          },
          body: jsonEncode(requestBody));
    } on Exception catch (e) {
      print("add super exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> addSupermarket(
      String name, String locationX, String locationY) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.post(Uri.parse("${ConnectionUrls.urlIp}supermarkets/"),
          headers: {
            "content-type": "application/json",
            "Authorization": "${header} ${token}",
          },
          body: jsonEncode(<String, dynamic>{
            "locationX": locationX,
            "locationY": locationY,
            "name": name
          }));
    } on Exception catch (e) {
      print("add super exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> deleteSuperMarket(String id) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.delete(
        Uri.parse("${ConnectionUrls.urlIp}supermarkets/${id}"),
        headers: {
          "content-type": "application/json",
          "Authorization": "${header} ${token}",
        },
      );
    } on Exception catch (e) {
      print("add super exception: $e");
      return http.Response("error", 404);
    }
  }
}
