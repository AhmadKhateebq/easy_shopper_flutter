import "dart:convert";

import "package:graduation_project/Constants/connection.dart";
import "package:http/http.dart" as http;

//admin header :
//"Authorization": "Bearer 1477",

String _adminHeader = "Bearer 1477";
String header = "Bearer";

class LoginApis {
  static Future<http.Response> login(String username, String password) async {
    try {
      return http.post(
          Uri.parse(
            "${ConnectionUrls.urlIp}login/",
          ),
          headers: {"content-type": "application/json"},
          body: jsonEncode(
            <String, dynamic>{"username": username, "password": password},
          ));
    } on Exception catch (e) {
      print("login exception: $e");
      return http.Response("error login", 404);
    }
  }

  static Future<http.Response> getUser() async {
    try {
      return http.get(Uri.parse("${ConnectionUrls.urlIp}user/"),
          headers: {"Authorization": _adminHeader});
    } on Exception catch (e) {
      print("get user exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> getAllUsersList(String token) async {
    try {
      return http.get(Uri.parse("${ConnectionUrls.urlIp}list/"),
          headers: {"Authorization": "${header} ${token}"});
    } on Exception catch (e) {
      print("get user exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> registerUser(String username, String fname,
      String lname, String email, String password) async {
    try {
      return http.post(Uri.parse("${ConnectionUrls.urlIp}register/"),
          headers: {"content-type": "application/json"},
          body: jsonEncode(
            <String, dynamic>{
              "username": username,
              "fname": fname,
              "lname": lname,
              "email": email,
              "password": password
            },
          ));
    } on Exception catch (e) {
      print("registerUser exception: $e");
      return http.Response("error", 404);
    }
  }
}
