import "dart:convert";

import "package:flutter_facebook_auth/flutter_facebook_auth.dart";

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

  static Future<void> loginWithFacebook() async {
    await FacebookAuth.instance.logOut();
    final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
        loginBehavior: LoginBehavior
            .webOnly); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    String accessToken = "";
    if (result.status == LoginStatus.success) {
      // you are logged
      accessToken = result.accessToken!.token;
    } else {
      print(result.status);
      print(result.message);
    }
    // Make an API request to your server with the Facebook access token
    final response = await http.post(
      Uri.parse('http://localhost:8085/login/facebook'),
      body: {
        'access_token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      // Successfully logged in with Facebook
      // Process the response from your server
    } else {
      // Failed to log in with Facebook
      // Handle the error
    }
  }
}
