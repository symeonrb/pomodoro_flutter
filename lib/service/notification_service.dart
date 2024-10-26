import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_flutter/main.dart';
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
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
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

Future<void> onDidReceiveLocalNotification(
  int id,
  String? title,
  String? body,
  String? payload,
) =>
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              print(payload);
              Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
