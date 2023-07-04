import 'package:http/http.dart';
import 'requests.dart';

String header = "Bearer";

class AdminApis {
  static Future<Response> deleteUser(String id) async {
    try {
      final endpoint = "user/$id";
      return Requests.deleteRequest(endpoint);
    } catch (e) {
      print("deleteUser exception: $e");
      return Response("error deleteUser", 404);
    }
  }
}
