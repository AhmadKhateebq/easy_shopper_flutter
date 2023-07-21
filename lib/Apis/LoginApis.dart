import "dart:convert";

import "package:flutter_facebook_auth/flutter_facebook_auth.dart";
import "package:graduation_project/Constants/connection.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

//admin header :
//"Authorization": "Bearer 1477",

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
      var prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("userToken")!;
      return http.get(Uri.parse("${ConnectionUrls.urlIp}user/"),
          headers: {"Authorization": "${header} ${token}"});
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


  static Future<void> loginWithFacebook() async {
    await FacebookAuth.instance.logOut();
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile','email'],loginBehavior: LoginBehavior.webOnly); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    String accessToken ="";
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
