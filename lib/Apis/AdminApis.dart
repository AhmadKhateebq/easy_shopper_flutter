import 'dart:convert';

import 'package:http/http.dart';

import '../Constants/connection.dart';

//admin header :
//"Authorization": "Bearer 1477",
class AdminApis {
  static Future<Response> deleteUser(String id) async {
    try {
      return delete(
        Uri.parse(
          "${ConnectionUrls.urlIp}user/${id}",
        ),
        headers: {
          "Authorization": "Bearer 1477",
          "content-type": "application/json"
        },
      );
    } on Exception catch (e) {
      print("deleteUser exception: $e");
      return Response("error deleteUser", 404);
    }
  }
}
