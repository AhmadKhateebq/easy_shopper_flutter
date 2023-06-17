import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager {
  static Future initializeFLN(FlutterLocalNotificationsPlugin flnPlugin) async {
    var androidSettings =
        new AndroidInitializationSettings("mipmap/ic_launcher");
    return flnPlugin
        .initialize(new InitializationSettings(android: androidSettings));
  }

  static Future showNotification(FlutterLocalNotificationsPlugin flnPlugin,
      String title, String body) async {
    var androidNotifcationSetteings = new AndroidNotificationDetails(
        "ch1", "ch1_name",
        priority: Priority.high, playSound: true, importance: Importance.max);
    flnPlugin.show(0, title, body,
        NotificationDetails(android: androidNotifcationSetteings));
  }
}
