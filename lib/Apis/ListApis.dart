import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/connection.dart';
import '../Pages/customer/model/list_data.dart';

class ListApis {
  static const String header = 'Bearer';
  static String urlIp = ConnectionUrls.urlIp;

  static Future<http.Response> _getRequest(String endpoint) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('userToken');
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
    return _getRequest(endpoint);
  }

  static Future<http.Response> getListByUserId(String id) async {
    final endpoint = '$id/list';
    return _getRequest(endpoint);
  }

  static Future<http.Response> removeProduct(
      String supId, String prodId) async {
    final endpoint = 'list/$supId/items/$prodId';
    return _deleteRequest(endpoint);
  }

  static Future<http.Response> removeList(int listId, int userId) async {
    final endpoint = '$userId/list/$listId/';
    return _deleteRequest(endpoint);
  }

  static Future<http.Response> createList(UserList userList) async {
    final sp = await SharedPreferences.getInstance();
    final userId = sp.getInt('userId');
    final endpoint = '/$userId/list';
    final userListJson = userList.toJson();

    try {
      final response = await _postRequest(endpoint, userListJson);
      return response;
    } catch (e) {
      print('Exception: $e');
      return http.Response('error', 404);
    }
  }
}
