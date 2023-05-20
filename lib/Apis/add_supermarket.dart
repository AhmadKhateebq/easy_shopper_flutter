import "dart:convert";

import "package:graduation_project/Constants/connection.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import '../model/supermarket.dart';

String header = "Bearer";

class AddSupermarketApi {


  static Future<http.Response> addSupermarket() async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token=  sp.getString('userToken');
      return http.post(Uri.parse("${ConnectionUrls.urlIp}supermarkets/"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("get super exception: $e");
      return http.Response("error", 404);
    }
  }
}
