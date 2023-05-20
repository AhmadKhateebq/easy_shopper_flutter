import 'dart:convert';

import 'package:http/http.dart';

import '../Constants/connection.dart';

class AdminApis {
  static Future<Response> deleteUser(String username, String email,String fname,String lname,String id) async {
    try {
      return delete(
          Uri.parse(
            "${ConnectionUrls.urlIp}user/",
          ),
          headers: {"content-type": "application/json"},
          body: jsonEncode(
            <String, dynamic>{"username": username, "email": email, "fname": fname, "lname": lname,"id":id},
          ));
    } on Exception catch (e) {
      print("deleteUser exception: $e");
      return Response("error deleteUser", 404);
    }
  }
}
