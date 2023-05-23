import "dart:convert";

import "package:graduation_project/Constants/connection.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import '../model/supermarket.dart';

String header = "Bearer";

class SupermarketApis {
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
