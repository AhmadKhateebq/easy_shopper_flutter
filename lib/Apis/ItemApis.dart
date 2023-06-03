import "dart:convert";

import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import "../Constants/connection.dart";

String header = "Bearer";

class ItemApis {
  static Future<http.Response> getAllItems() async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token =
          sp.getString('userToken') != null ? sp.getString('userToken') : "";
      return http.get(
        Uri.parse("${ConnectionUrls.urlIp}products/"),
        headers: {
          "Authorization": "${header} ${token}",
        },
      );
    } on Exception catch (e) {
      print("getAllItems exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> createProduct(name,description,category,brand) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token =
      sp.getString('userToken') != null ? sp.getString('userToken') : "";

          return http.post(
      Uri.parse(
      "${ConnectionUrls.urlIp}/products/"),
    headers: {
    "content-type": "application/json",
    "Authorization": "${header} ${token}",
    },
    body: jsonEncode(<String, dynamic>{
    "name": name,
    "description": description,
    "category": category,
    "brand": brand,
    }));
    } on Exception catch (e) {
      print("getAllItems exception: $e");
      return http.Response("error", 404);
    }
  }

}
