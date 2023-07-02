import "dart:convert";

import "package:http/http.dart" as http;

import "requests.dart";
// admin header :
// "Authorization": "Bearer 1477",

String header = "Bearer";

class LoginApis {
  static Future<http.Response> login(String username, String password) async {
    try {
      final endpoint = "login/";
      final body = jsonEncode(<String, dynamic>{
        "username": username,
        "password": password,
      });

      return Requests.postRequest(endpoint, body);
    } catch (e) {
      print("login exception: $e");
      return http.Response("error login", 404);
    }
  }

  static Future<http.Response> getUser() async {
    try {
      final endpoint = "user/";
      return Requests.getRequest(endpoint);
    } catch (e) {
      print("get user exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> getAllUsersList(String token) async {
    try {
      final endpoint = "list/";

      return Requests.getRequest(endpoint);
    } catch (e) {
      print("get user exception: $e");
      return http.Response("error", 404);
    }
  }

  static Future<http.Response> registerUser(String username, String fname,
      String lname, String email, String password) async {
    try {
      final endpoint = "register/";
      final body = jsonEncode(<String, dynamic>{
        "username": username,
        "fname": fname,
        "lname": lname,
        "email": email,
        "password": password,
      });

      return Requests.postRequest(endpoint, body);
    } catch (e) {
      print("registerUser exception: $e");
      return http.Response("error", 404);
    }
  }
}
