import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future dailyAtTimeNotification(
    {DateTime alarmTime, String title, String contents}) async {
  final notiTitle = title;
  final notiDesc = contents;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );


  var android = AndroidNotificationDetails('id', notiTitle, notiDesc,
      importance: Importance.max, priority: Priority.max);
  var ios = IOSNotificationDetails();
  var detail = NotificationDetails(android: android, iOS: ios);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.deleteNotificationChannelGroup('id');

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    notiTitle,
    notiDesc,
    _setNotiTime(alarmTime),
    detail,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _setNotiTime(DateTime alarmTime) {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(tz.local, alarmTime.year, alarmTime.month, alarmTime.day,
      alarmTime.hour, alarmTime.minute);

  return scheduledDate;
}


