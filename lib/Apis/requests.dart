import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/connection.dart';

class Requests {
  static const String header = 'Bearer';
  static String urlIp = ConnectionUrls.urlIp;
  static Future<http.Response> getRequest(String endpoint) async {
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

  static Future<http.Response> postRequest(String endpoint, String body) async {
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

  static Future<http.Response> deleteRequest(String endpoint) async {
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

  static Future<http.Response> putRequest(String endpoint, String body) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('userToken');
      final url = Uri.parse('${ConnectionUrls.urlIp}$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': '$header $token',
      };
      final response = await http.put(url, headers: headers, body: body);
      return response;
    } catch (e) {
      print('Exception: $e');
      return http.Response('error', 404);
    }
  }
}
