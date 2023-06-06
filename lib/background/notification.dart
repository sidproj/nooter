import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const initSettings = InitializationSettings(android: androidSettings);
    final temp = await _localNotificationPlugin.initialize(
      initSettings,
    );

    if (temp == true) {
      print("Setup for notification is successful!");
    }
  }

  void showNotification(String title, String body) async {
    // final http.Response response = await http.get(Uri.parse(profile ?? ""));

    // final bigPictureStyleInformation = BigPictureStyleInformation(
    //     ByteArrayAndroidBitmap.fromBase64String(
    //         base64Encode(response.bodyBytes)));
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "NMSG1" + DateTime.now().toString(),
      "New Message",
      channelDescription:
          "This channel is used to show notification on new message",
      importance: Importance.max,
      priority: Priority.max,
      ticker: "ticker",
      // styleInformation: bigPictureStyleInformation,
    );
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    _localNotificationPlugin.show(0, title, body, notificationDetails,
        payload: "This is payload");
  }
}
