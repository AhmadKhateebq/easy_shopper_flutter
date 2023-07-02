import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/customer/model/list_data.dart';
import 'requests.dart';

class ListApis {
  static Future<http.Response> getListItems(String id) async {
    final endpoint = 'list/$id/items';
    return Requests.getRequest(endpoint);
  }

  static Future<http.Response> getListByUserId(String id) async {
    final endpoint = '$id/list';
    return Requests.getRequest(endpoint);
  }

  static Future<http.Response> getListSharedWithUser(String id) async {
    final endpoint = '$id/list';
    return Requests.getRequest(endpoint);
  }

  static Future<http.Response> removeProduct(
      String supId, String prodId) async {
    final endpoint = 'list/$supId/items/$prodId';
    return Requests.deleteRequest(endpoint);
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
}
