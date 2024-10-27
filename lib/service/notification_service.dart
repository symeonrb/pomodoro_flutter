import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  static Future<void> initialize() async {
    await _configureLocalTimeZone();

    instance._plugin = FlutterLocalNotificationsPlugin();

    await instance._plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notification');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await instance._plugin.initialize(initializationSettings);
  }

  static Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Paris'));
  }

  late final FlutterLocalNotificationsPlugin _plugin;

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> scheduleNotification({
    required String title,
    required Duration showIn,
  }) async {
    await _plugin.zonedSchedule(
      generateUidInt(),
      title,
      null,
      tz.TZDateTime.now(tz.local).add(showIn),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro',
          'Pomodoro',
          channelDescription: 'Pomodoro channel',
          visibility: NotificationVisibility.public,
          importance: Importance.max,
          priority: Priority.max,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          sound: RawResourceAndroidNotificationSound('pomodoro'),
        ),
        iOS: DarwinNotificationDetails(
          sound: 'pomodoro.aiff',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
