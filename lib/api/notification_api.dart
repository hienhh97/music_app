import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationAPI {
  static final onNotifications = BehaviorSubject<String?>();
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notification.initialize(
      settings,
      // onSelectNotification: (payload) async {
      //   onNotifications.add(payload);
      // },
    );
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel ID',
          'channel name',
          'channel description',
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails());
  }

  static Future showNotification({
    int id = 0,
    required String title,
    required String body,
    var payload,
  }) async {
    _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }
}
