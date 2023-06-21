
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import "../Constants/connection.dart";

String header = "Bearer";

class ListApis {
  static Future<http.Response> getListItems(String id) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.get(Uri.parse("${ConnectionUrls.urlIp}list/${id}/items"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("getListItems exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> getListByUserId(String id) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.get(Uri.parse("${ConnectionUrls.urlIp}${id}/list"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("getListByUserId exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> removeProduct(
      String supId, String prodID) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.delete(
          Uri.parse("${ConnectionUrls.urlIp}list/${supId}/items/${prodID}"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("removeProduct exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> addItemtolist(
      String supId, String itemId) async {
    try {
      var sp = await SharedPreferences.getInstance();
      String? token = sp.getString('userToken');
      return http.post(
        Uri.parse("${ConnectionUrls.urlIp}list/${supId}/items/${itemId}"),
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
