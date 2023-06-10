import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/connection.dart';

String header = "Bearer";

class AdminApis {
  static Future<Response> deleteUser(String id) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("userToken")!;
      print("token: " + token);
      return delete(
        Uri.parse(
          "${ConnectionUrls.urlIp}user/${id}",
        ),
        headers: {
          "Authorization": "${header} ${token}",
          "content-type": "application/json"
        },
      );
    } on Exception catch (e) {
      print("deleteUser exception: $e");
      return Response("error deleteUser", 404);
    }
  }
}
