import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;



FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<bool> initLocalNotifications() async {
  var onDidReceiveLocalNotification;
  var selectNotification;
  try {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
    return true;
  } catch (e) {
    print ('initLocalNotifications ERROR: ' + e.toString());
    return false;
  }
}

Future<bool> scheduleNotification(String title, String body, DateTime notificationDateTime, int id) async {
  try {
    //await flutterLocalNotificationsPlugin.zonedSchedule(0, 'New Phase', 'scheduled body', tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, tz.TZDateTime.from(notificationDateTime, tz.getLocation('Europe/Berlin')),
        const NotificationDetails(android: AndroidNotificationDetails('channel id', 'channel name', 'channel description')),
        androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
    return true;
  } catch (e) {
    print ('scheduleNotification ERROR: ' + e.toString());
    return false;
  }
}
