import 'dart:convert';

import 'package:graduation_project/Apis/requests.dart';
import 'package:http/http.dart';

import '../Pages/customer/model/list_data.dart';

class NotificationApis{
  static Future<Response> handleList(int userId , List<SharedWith> canEditList
  , List<SharedWith> newShared )async{

    String body = jsonEncode({
      "userId" : userId,
      "editShared" : canEditList,
      "newShared": newShared
    });

   var response =  await Requests.postRequest("/notification/list",body );
   print("notification list response : ${response.body}");
    return response;
  }
}