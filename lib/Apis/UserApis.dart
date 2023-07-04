import 'dart:convert';

import 'package:http/http.dart';
import '../Pages/customer/model/user_data.dart';
import 'requests.dart';

class UserApi {
  static final _endpoint = 'user';
  static Future<Response> createUser(AppUser user) async {
    final userJson = user.toJson();
    try {
      final response = await Requests.postRequest(_endpoint, userJson);
      return response;
    } catch (e) {
      print('Exception: $e');
      return Response('error', 404);
    }
  }

  static Future<Response> updateUser(AppUser user) async {
    final endpoint = '$_endpoint/${user.id}';
    final userJson = user.toJson();

    try {
      final response = await Requests.putRequest(endpoint, userJson);
      return response;
    } catch (e) {
      print('Exception: $e');
      return Response('error', 404);
    }
  }

  static Future<Response> getUser(int userId) async {
    final endpoint = '$_endpoint/$userId';

    try {
      final response = await Requests.getRequest(endpoint);
      return response;
    } catch (e) {
      print('Exception: $e');
      return Response('error', 404);
    }
  }

  static Future<Response> getAllUserNames() async {
    final endpoint = '$_endpoint/usernames';
    try {
      final response = await Requests.getRequest(endpoint);
      return response;
    } catch (e) {
      print('Exception: $e');
      return Response('error', 404);
    }
  }

  static Future<Response> deleteUser(int userId) async {
    final endpoint = '$_endpoint/$userId';

    try {
      final response = await Requests.deleteRequest(endpoint);
      return response;
    } catch (e) {
      print('Exception: $e');
      return Response('error', 404);
    }
  }

  static Future<Response> updatePassword(
      int userId, String currentPassword, String newPassword) async {
    final endpoint = '$_endpoint/$userId/password';
    final passwordUpdate = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };

    try {
      final response =
          await Requests.putRequest(endpoint, jsonEncode(passwordUpdate));
      return response;
    } catch (e) {
      print('Exception: $e');
      return Response('error', 404);
    }
  }
}
