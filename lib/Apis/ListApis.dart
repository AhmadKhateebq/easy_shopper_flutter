import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/connection.dart';
import '../Pages/customer/model/list_data.dart';
import 'requests.dart';

class ListApis {
  static const String header = 'Bearer';
  static String urlIp = ConnectionUrls.urlIp;

  static Future<http.Response> _getRequest(String endpoint,
      {bool? isAdminAuth}) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final token = isAdminAuth == true ? "1477" : sp.getString('userToken');
      final url = Uri.parse('$urlIp$endpoint');
      final response =
          await http.get(url, headers: {'Authorization': '$header $token'});
      return response;
    } catch (e) {
      print('Exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> _postRequest(
      String endpoint, String body) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('userToken');
      final url = Uri.parse('$urlIp$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': '$header $token',
      };
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      print('Exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> _deleteRequest(String endpoint) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('userToken');
      final url = Uri.parse('$urlIp$endpoint');
      final response =
          await http.delete(url, headers: {'Authorization': '$header $token'});
      return response;
    } catch (e) {
      print('Exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> getListItems(String id) async {
    final endpoint = 'list/$id/items';
    return _getRequest(endpoint, isAdminAuth: true);
  }

  static Future<http.Response> getListByUserId(String id) async {
    final endpoint = '$id/list';
    return Requests.getRequest(endpoint);
  }

  static Future<http.Response> getListById(String id) async {
    final endpoint = '/list/$id';
    return Requests.getRequest(endpoint);
  }

  static Future<http.Response> getListSharedWithUser(String id) async {
    final endpoint = '/list/shared/$id';
    return Requests.getRequest(endpoint);
  }

  static Future<http.Response> removeProduct(
      String supId, String prodId) async {
    final endpoint = 'list/$supId/items/$prodId';
    return Requests.deleteRequest(endpoint);
  }

  static Future<http.Response> addItemToUserList(
      String listId, String prodId) async {
    final endpoint = 'list/$listId/items/$prodId';
    return _postRequest(endpoint, "");
  }

  static Future<http.Response> removeItemFromUserList(
      String listId, String prodId) async {
    final endpoint = 'list/$listId/items/$prodId';
    return _deleteRequest(endpoint);
  }

  static Future<http.Response> removeList(int listId, int userId) async {
    final endpoint = '$userId/list/$listId/';
    return Requests.deleteRequest(endpoint);
  }

  static Future<http.Response> createList(UserList userList) async {
    final sp = await SharedPreferences.getInstance();
    final userId = sp.getInt('userId');
    final endpoint = '/$userId/list';
    final userListJson = userList.toJson();

    try {
      final response = await Requests.postRequest(endpoint, userListJson);
      return response;
    } catch (e) {
      print('Exception: $e');
      return http.Response('error', 404);
    }
  }

  static Future<http.Response> updateList(UserList userList) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final userId = sp.getInt('userId');
      if (userId == null) {
        return http.Response('User ID not found in SharedPreferences', 400);
      }

      final endpoint = '/$userId/list/${userList.id}';
      final userListJson = userList.toJson();

      final response = await Requests.putRequest(endpoint, userListJson);
      return response;
    } catch (e) {
      print('Exception: $e');
      return http.Response('An error occurred during the request', 500);
    }
  }

  static Future<void> setNickname(
      int userId, int listId, String nickname) async {
    String endpoint = 'list/nickname/';
    String body = jsonEncode({
      'userId': userId,
      'listId': listId,
      'nickname': nickname,
    });

    try {
      final response = await Requests.postRequest(endpoint, body);
      if (response.statusCode == 200) {
        // Request successful
        print('Nickname set successfully!');
      } else {
        // Request failed
        print('Failed to set nickname: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred
      print('Error setting nickname: $e');
    }
  }
}
