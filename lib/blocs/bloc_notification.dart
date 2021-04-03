import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BlocNotification extends ChangeNotifier {
  factory BlocNotification() => _instance;

  BlocNotification._internal();

  static final _instance = BlocNotification._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotifPlugin =
      FlutterLocalNotificationsPlugin();

  // initialize local notification
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('medicines');
  IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  InitializationSettings initializationSettings;

  void initializing() async {
    initializationSettingsAndroid = AndroidInitializationSettings('medicines');
    initializationSettingsIOS = IOSInitializationSettings();
    initializationSettingsMacOS = MacOSInitializationSettings();

    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    await flutterLocalNotifPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
  }

  void showNotification(String data) async {
    print('alarmHandle - schedule');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotifPlugin.show(
        0, 'Reminder Obat', data, platformChannelSpecifics,
        payload: 'item x');
  }

  void cancelNotif() async {
    await flutterLocalNotifPlugin.cancelAll();
  }
}

// Create instance for all(s)
BlocNotification blocNotificationInstance = BlocNotification();
